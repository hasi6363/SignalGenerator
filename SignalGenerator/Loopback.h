//
//  Loopback.h
//  SignalGenerator
//
//  Created by 橋本翔太 on 2018/04/28.
//  Copyright © 2018 hasi6363. All rights reserved.
//

#ifndef Loopback_h
#define Loopback_h

#import <Foundation/Foundation.h>
#import <AudioUnit/AudioUnit.h>
#import "AudioInfo.h"

@interface Loopback : NSObject
@property (nonatomic, readonly) BOOL isPlaying;
@property (nonatomic) AudioInfo* audioInfo;

- (void) start;
- (void) stop;
@end

#endif /* Loopback_h */
