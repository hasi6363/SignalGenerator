//
//  AudioInfo.m
//  SignalGenerator
//
//  Created by 橋本翔太 on 2018/03/25.
//  Copyright © 2018 hasi6363. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AudioInfo.h"

@interface AudioInfo()
@end
@implementation AudioInfo
- (void) setFrequency:(double)frequency
{
    if(frequency > 20000)
    {
        frequency = 20000;
    }
    else if(frequency < 1)
    {
        frequency = 1;
    }
    _frequency = frequency;
}
@end
