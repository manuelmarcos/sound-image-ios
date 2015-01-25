//
//  ViewController.h
//  SoundImage
//
//  Created by Manuel Marcos Regalado on 23/01/2015.
//  Copyright (c) 2015 ribot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController <AVAudioRecorderDelegate, AVAudioPlayerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

- (IBAction)recordPauseTapped:(id)sender;
- (IBAction)stopTapped:(id)sender;
- (IBAction)playTapped:(id)sender;
- (IBAction)takePhoto:(id)sender;

@end
