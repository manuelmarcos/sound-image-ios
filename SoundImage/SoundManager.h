//
//  SoundManager.h
//  SoundImage
//
//  Created by Manuel Marcos Regalado on 26/01/2015.
//  Copyright (c) 2015 ribot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface SoundManager : NSObject <AVAudioRecorderDelegate, AVAudioPlayerDelegate>

- (void)recordSound;
- (void)stopRecord;
- (void)playSound;

+ (SoundManager *)sharedInstance;

@end
