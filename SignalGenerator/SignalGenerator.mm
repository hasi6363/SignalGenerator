//
//  SignalGenerator.m
//  SignalGenerator
//
//  Created by 橋本翔太 on 2018/03/15.
//  Copyright © 2018 hasi6363. All rights reserved.
//

#import "SignalGenerator.h"
#import "cpp/GraphManager.hpp"

#define OUTPUT_NODE_KEY "output_key"

@interface SignalGenerator ()
{
    GraphManager* mGraphManager;
}

@end

@implementation SignalGenerator

- (instancetype)init
{
    self = [super init];
    _audioInfo = [[AudioInfo alloc] init];
    _audioInfo.sampleRate = 44100;
    _audioInfo.frequency = 440;
    _audioInfo.curFreq = _audioInfo.frequency;
    
    
    AudioComponentDescription acd = [self getACD];
    AudioStreamBasicDescription asbd = [self getASBD:44100];
    
    AURenderCallbackStruct callback
    {
        .inputProc = (AURenderCallback)render_callback,
        .inputProcRefCon = (__bridge void*)_audioInfo
    };
    
    mGraphManager = new GraphManager();
    mGraphManager->addNode(OUTPUT_NODE_KEY, &acd);
    mGraphManager->setCallback(OUTPUT_NODE_KEY,&callback);
    mGraphManager->setASBD(OUTPUT_NODE_KEY, &asbd);
    mGraphManager->setEnableIO(OUTPUT_NODE_KEY, 1);
    mGraphManager->connect(OUTPUT_NODE_KEY, 1, OUTPUT_NODE_KEY, 0);
    mGraphManager->initialize();
    return self;
}
- (void) dealloc
{
    mGraphManager->freeNode();
    free(mGraphManager);
}

- (AudioComponentDescription)getACD
{
    AudioComponentDescription acd;
    acd.componentType = kAudioUnitType_Output;
    acd.componentSubType = kAudioUnitSubType_RemoteIO;
    acd.componentManufacturer = kAudioUnitManufacturer_Apple;
    acd.componentFlags = 0;
    acd.componentFlagsMask = 0;
    return acd;
}

- (AudioStreamBasicDescription)getASBD:(Float64) sampleRate
{
    AudioStreamBasicDescription asbd;
    asbd.mSampleRate = sampleRate;
    asbd.mFormatID = kAudioFormatLinearPCM;
    asbd.mFormatFlags = kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked | kAudioFormatFlagIsNonInterleaved;
    asbd.mBitsPerChannel = 16;
    asbd.mChannelsPerFrame = 1;
    asbd.mFramesPerPacket = 1;
    asbd.mBytesPerFrame = asbd.mBitsPerChannel / 8 * asbd.mChannelsPerFrame;
    asbd.mBytesPerPacket = asbd.mBytesPerFrame * asbd.mFramesPerPacket;
    
    return asbd;
}

- (void) play
{
    if(!self.isPlaying)
    {
        mGraphManager->start();
    }
    _isPlaying = YES;
}

- (void) stop
{
    if(self.isPlaying)
    {
        mGraphManager->stop();
    }
    _isPlaying = NO;
}

static OSStatus render_callback(void*                       inRefCon,
                                AudioUnitRenderActionFlags* ioActionFlags,
                                const AudioTimeStamp*       inTimeStamp,
                                UInt32                      inBusNumber,
                                UInt32                      inNumberFrames,
                                AudioBufferList*            ioData)
{
    AudioInfo* info = (__bridge AudioInfo*)inRefCon;
    SInt16 *buffer = (SInt16*)(ioData->mBuffers[0].mData);
    double delta;
    float wave;
    
    for (int i = 0; i< inNumberFrames; i++)
    {
        info.curFreq = 0.001 * info.frequency + 0.999 * info.curFreq;
        delta = info.curFreq * 2.0 * M_PI / info.sampleRate;
        wave = sin(info.phase);
        SInt16 data = wave * 0x7FFF;
        buffer[i] = data;
        info.phase = info.phase + delta;
        if(info.phase > 2.0 * M_PI)
        {
            info.phase -= 2.0 * M_PI;
        }
    }
    return noErr;
}

@end

