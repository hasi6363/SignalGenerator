#import <Foundation/Foundation.h>
#import <AudioUnit/AudioUnit.h>
#import "AudioInfo.h"

@interface SignalGenerator : NSObject
@property (nonatomic, readonly) BOOL isPlaying;
@property (nonatomic) AudioInfo* audioInfo;

- (void) play;
- (void) stop;

@end

