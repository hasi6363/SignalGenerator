//
//  SignalGenerator.m
//  SignalGenerator
//
//  Created by 橋本翔太 on 2018/03/15.
//  Copyright © 2018 hasi6363. All rights reserved.
//

#import "SignalGenerator.h"

@interface SignalGenerator ()
{
    // member variable
    AudioUnit mAudioUnit;
}

@end

@implementation SignalGenerator

- (instancetype)init
{
    self = [super init];
    [self prepareAudioUnit];

    return self;
}

- (void)dealloc
{
    if(self.mIsPlaying)AudioOutputUnitStop(mAudioUnit);
    AudioUnitUninitialize(mAudioUnit);
    AudioComponentInstanceDispose(mAudioUnit);
}

- (void) play
{
    if(!self.mIsPlaying)
    {
        AudioOutputUnitStart(mAudioUnit);
    }
    _mIsPlaying = YES;
}

- (void) stop
{
    if(self.mIsPlaying)
    {
        AudioOutputUnitStop(mAudioUnit);
    }
    _mIsPlaying = NO;
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

- (AudioUnit*) AudioUnit: (AudioUnit*)au setACD:(AudioComponentDescription*)acd
{
    AudioComponentInstanceNew(AudioComponentFindNext(NULL, acd), au);
    AudioUnitInitialize(*au);
    return au;
}

- (void) AudioUnit: (AudioUnit*) au setCallbackStruct: (AURenderCallbackStruct*) callback_struct
{
    AudioUnitSetProperty(*au,
                         kAudioUnitProperty_SetRenderCallback,
                         kAudioUnitScope_Input,
                         0,
                         callback_struct,
                         sizeof(AURenderCallbackStruct));
}
- (void) AudioUnit: (AudioUnit*) au setASBD: (AudioStreamBasicDescription*) asbd
{
    AudioUnitSetProperty(*au,
                         kAudioUnitProperty_StreamFormat,
                         kAudioUnitScope_Input,
                         0,
                         asbd,
                         sizeof(AudioStreamBasicDescription));
}

- (void) prepareAudioUnit
{
    self.mSampleRate = 44100.0;
    self.mFrequency = 440;
    AudioComponentDescription acd =
    {
        .componentType = kAudioUnitType_Output,
        .componentSubType = kAudioUnitSubType_RemoteIO,
        .componentManufacturer = kAudioUnitManufacturer_Apple,
        .componentFlags = 0,
        .componentFlagsMask = 0
    };
    [self AudioUnit:&mAudioUnit setACD: &acd];
    
    AURenderCallbackStruct callback_struct =
    {
        .inputProc = render_callback,
        .inputProcRefCon = (__bridge void*)self // Data refered in callback
    };
    [self AudioUnit:&mAudioUnit setCallbackStruct:&callback_struct];

    AudioStreamBasicDescription asbd =
    {
        .mSampleRate = self.mSampleRate,
        .mFormatID = kAudioFormatLinearPCM,
        .mFormatFlags = kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked | kAudioFormatFlagIsNonInterleaved,
        .mBitsPerChannel = 16,
        .mChannelsPerFrame = 1,
        .mFramesPerPacket = 1
    };
    asbd.mBytesPerFrame = asbd.mBitsPerChannel / 8 * asbd.mChannelsPerFrame;
    asbd.mBytesPerPacket = asbd.mBytesPerFrame * asbd.mFramesPerPacket;
    
    [self AudioUnit:&mAudioUnit setASBD:&asbd];

}

static OSStatus render_callback(void*                       inRefCon,
                                AudioUnitRenderActionFlags* ioActionFlags,
                                const AudioTimeStamp*       inTimeStamp,
                                UInt32                      inBusNumber,
                                UInt32                      inNumberFrames,
                                AudioBufferList*            ioData)
{
    SignalGenerator* def = (__bridge SignalGenerator*)inRefCon;
    SInt16 *outL = ioData->mBuffers[0].mData;
    //SInt16 *outR = ioData->mBuffers[1].mData;
    float delta;
    float wave;
    
    for (int i = 0; i< inNumberFrames; i++)
    {
        def.mCurFreq = 0.001 * def.mFrequency + 0.999 * def.mCurFreq;
        delta = def.mCurFreq * 2.0 * M_PI / def.mSampleRate;
        wave = sin(def.mPhase);
        SInt16 data = wave * 0x7FFF;
        outL[i] = data;
        //outR[i] = data;
        def.mPhase = def.mPhase + delta;
        if(def.mPhase > 2.0 * M_PI)
        {
            def.mPhase -= 2.0 * M_PI;
        }
    }
    return noErr;
}

@end
