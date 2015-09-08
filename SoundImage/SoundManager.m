//
//  SoundManager.m
//  SoundImage
//
//  Created by Manuel Marcos Regalado on 26/01/2015.
//  Copyright (c) 2015 ribot. All rights reserved.
//

#import "SoundManager.h"

@interface SoundManager ()
{
    AVAudioRecorder *recorder;
    AVAudioPlayer *player;
}
@end

@implementation SoundManager

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        // Set the audio file
        NSArray *pathComponents = [NSArray arrayWithObjects:
                                   [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                                   @"MyAudioMemo.m4a",
                                   nil];
        NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
        
        // Setup audio session
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        NSError *setOverrideError;
        [session overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:&setOverrideError];
        if(setOverrideError)
        {
            NSLog(@"%@", [setOverrideError description]);
        }
        // Define the recorder setting
        NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
        
        [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
        [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
        [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
        
        // Initiate and prepare the recorder
        recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:nil];
        recorder.delegate = self;
        recorder.meteringEnabled = YES;
        [recorder prepareToRecord];
    }
    return self;
}

- (void)recordSound
{
    // Stop the audio player before recording
    if (player.playing)
    {
        [player stop];
    }
    
    if (!recorder.recording)
    {
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        
        // Start recording
        [recorder record];
    }
}

- (void)stopRecord
{
    [recorder stop];
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:NO error:nil];
}

- (void)playSound
{
    // Stop the audio player
    [self stopSound];
    
    // Play the sound
    if (!recorder.recording)
    {
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:recorder.url error:nil];
        [player setVolume: 1.0];
        [player setNumberOfLoops:-1];
        [player setDelegate:self];
        [player play];
    }
}

- (void)stopSound
{
    // Stop the audio player
    if (player.playing)
    {
        [player stop];
    }
}

- (void)playSoundWithContentsOfURL:(NSURL *)contentsOfURL
{
    if (!recorder.recording)
    {
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:contentsOfURL error:nil];
        [player setVolume: 1.0];
        [player setNumberOfLoops:-1];
        [player setDelegate:self];
        [player play];
    }
}

#pragma mark - AVAudioRecorderDelegate

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag
{
    // TODO:
}

#pragma mark - AVAudioPlayerDelegate

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Done"
//                                                    message: @"Finish playing the recording!"
//                                                   delegate: nil
//                                          cancelButtonTitle:@"OK"
//                                          otherButtonTitles:nil];
//    [alert show];
    // TODO:
}

+ (SoundManager *)sharedInstance
{
    static SoundManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

@end
