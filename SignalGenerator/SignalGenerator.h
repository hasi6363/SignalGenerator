#import <Foundation/Foundation.h>
#import <AudioUnit/AudioUnit.h>

@interface SignalGenerator : NSObject

@property (nonatomic, readonly) BOOL isPlaying;
@property (nonatomic) Float64 sampleRate;
@property (nonatomic) double frequency;
@property (nonatomic) double curFreq;
@property (nonatomic) double phase;

- (void) play;
- (void) stop;

@end

