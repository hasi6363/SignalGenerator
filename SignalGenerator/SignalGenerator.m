//
//  SignalGenerator.m
//  SignalGenerator
//
//  Created by 橋本翔太 on 2018/03/15.
//  Copyright © 2018 hasi6363. All rights reserved.
//

#import "SignalGenerator.h"
#import "RemoteOutputController.h"

@interface SignalGenerator ()
{
    RemoteOutputController *mOutput;
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
    
    mOutput = [[RemoteOutputController alloc] initWithSampleRate: _audioInfo.sampleRate];
    [mOutput setCallback:render_callback withAudioInfo:(__bridge void*)_audioInfo];
    return self;
}

- (void) play
{
    if(!self.isPlaying)
    {
        [mOutput start];
    }
    _isPlaying = YES;
}

- (void) stop
{
    if(self.isPlaying)
    {
        [mOutput stop];
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
    SInt16 *buffer = ioData->mBuffers[0].mData;
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


