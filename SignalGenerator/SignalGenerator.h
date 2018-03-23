#import <Foundation/Foundation.h>
#import <AudioUnit/AudioUnit.h>

@interface SignalGenerator : NSObject

@property (nonatomic, readonly) BOOL mIsPlaying;
@property (nonatomic) Float64 mSampleRate;
@property (nonatomic) float mFrequency;
@property (nonatomic) float mCurFreq;
@property (nonatomic) float mPhase;

- (void) play;
- (void) stop;
- (void) prepareAudioUnit;

@end

