//
//  SignalGenerator.h
//  SignalGenerator
//
//  Created by 橋本翔太 on 2018/04/24.
//  Copyright © 2018 hasi6363. All rights reserved.
//

#ifndef SignalGenerator_h
#define SignalGenerator_h
#import <Foundation/Foundation.h>
#import <AudioUnit/AudioUnit.h>
#import "AudioInfo.h"

@interface SignalGenerator : NSObject
@property (nonatomic, readonly) BOOL isPlaying;
@property (nonatomic) AudioInfo* audioInfo;
- (void) start;
- (void) stop;
@end

#endif /* SignalGenerator_h */
