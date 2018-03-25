//
//  AudioUnitController.h
//  SignalGenerator
//
//  Created by 橋本翔太 on 2018/03/25.
//  Copyright © 2018 hasi6363. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioUnit/AudioUnit.h>

@interface RemoteOutputController:NSObject

@property (nonatomic) Float64 sampleRate;
@property (nonatomic, readonly) BOOL isPlaying;

- (instancetype)initWithSampleRate:(Float64) sample_rate;
- (void) start;
- (void) stop;
-(void) setCallback:(AURenderCallback)callback withAudioInfo:(void*)audio_info;
@end
