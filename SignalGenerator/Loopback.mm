//
//  Loopback.m
//  SignalGenerator
//
//  Created by 橋本翔太 on 2018/04/28.
//  Copyright © 2018 hasi6363. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Loopback.h"
#import "cpp/GraphManager.hpp"

#define OUTPUT_NODE_KEY "output_key"

@interface Loopback ()
{
    GraphManager* mGraphManager;
}

@end

@implementation Loopback

- (instancetype)init
{
    self = [super init];
    _audioInfo = [[AudioInfo alloc] init];
    _audioInfo.sampleRate = 44100;
    _audioInfo.frequency = 440;
    _audioInfo.curFreq = _audioInfo.frequency;
    
    AudioComponentDescription acd = [self getACD];
    AudioStreamBasicDescription asbd = [self getASBD:44100];
    
    mGraphManager = new GraphManager();
    mGraphManager->addNode(OUTPUT_NODE_KEY, &acd);
    //mGraphManager->setCallback(OUTPUT_NODE_KEY,&callback);
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

- (void) start
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

@end
