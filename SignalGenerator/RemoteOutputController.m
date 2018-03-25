//
//  AudioUnitController.m
//  SignalGenerator
//
//  Created by 橋本翔太 on 2018/03/25.
//  Copyright © 2018 hasi6363. All rights reserved.
//

#import "RemoteOutputController.h"

@interface RemoteOutputController()
{
    AudioUnit mAudioUnit;
}
@end

@implementation RemoteOutputController
@synthesize sampleRate = _sampleRate;

- (instancetype)init
{
    self = [super init];
    _sampleRate = 44100.0;
    [self setup];
    return self;
}
- (instancetype)initWithSampleRate:(Float64) sample_rate
{
    self = [super init];
    _sampleRate = sample_rate;
    [self setup];
    return self;
}

- (void)dealloc
{
    if(self.isPlaying)
    {
        AudioOutputUnitStop(mAudioUnit);
    }
    AudioUnitUninitialize(mAudioUnit);
    AudioComponentInstanceDispose(mAudioUnit);
}
/*
 1. mAudioUnitを初期化
 1-1 AudioComponentDescription acd生成
 1-2 AudioComponentFindNextからAudioComponentを持ってきて、mAudioUnitをNewする
 1-3 mAudioUnitをInitする
 2. mAudioUnitにRenderCallbackプロパティを設定する
 2-1 AURenderCallbackStructを設定する
 2-1-1 inputProc: callback関数の指定
 2-1-2 inputProcRefCon: callback関数の第一引数に渡る変数を指定
 3. mAudioUnitにStreamFormatを設定する
 3-1 AudioStreamBasicDescription asbdを設定
 
 */
- (void)setup
{
    AudioComponentDescription acd;
    acd.componentType = kAudioUnitType_Output;
    acd.componentSubType = kAudioUnitSubType_RemoteIO;
    acd.componentManufacturer = kAudioUnitManufacturer_Apple;
    acd.componentFlags = 0;
    acd.componentFlagsMask = 0;
    
    AudioStreamBasicDescription asbd;
    asbd.mSampleRate = _sampleRate;
    asbd.mFormatID = kAudioFormatLinearPCM;
    asbd.mFormatFlags = kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked | kAudioFormatFlagIsNonInterleaved;
    asbd.mBitsPerChannel = 16;
    asbd.mChannelsPerFrame = 1;
    asbd.mFramesPerPacket = 1;
    asbd.mBytesPerFrame = asbd.mBitsPerChannel / 8 * asbd.mChannelsPerFrame;
    asbd.mBytesPerPacket = asbd.mBytesPerFrame * asbd.mFramesPerPacket;
    
    OSStatus result = 0;
    AudioComponent ac = AudioComponentFindNext(NULL, &acd);
    result = AudioComponentInstanceNew(ac, &mAudioUnit);
    result = AudioUnitInitialize(mAudioUnit);
    result = AudioUnitSetProperty(mAudioUnit,
                         kAudioUnitProperty_StreamFormat,
                         kAudioUnitScope_Input,
                         0,
                         &asbd,
                         sizeof(AudioStreamBasicDescription));
}

-(void) setCallback:(AURenderCallback)callback withAudioInfo:(void*)audio_info
{
    AURenderCallbackStruct callback_struct =
    {
        .inputProc = callback,
        .inputProcRefCon = audio_info
    };
    AudioUnitSetProperty(mAudioUnit,
                         kAudioUnitProperty_SetRenderCallback,
                         kAudioUnitScope_Input,
                         0,
                         &callback_struct,
                         sizeof(AURenderCallbackStruct));
}
-(void) start
{
    if(!self.isPlaying)
    {
        AudioOutputUnitStart(mAudioUnit);
    }
    _isPlaying = YES;
}

-(void) stop
{
    if(self.isPlaying)
    {
        AudioOutputUnitStop(mAudioUnit);
    }
    _isPlaying = NO;
}

@end
