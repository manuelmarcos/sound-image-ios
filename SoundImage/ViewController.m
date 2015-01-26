//
//  ViewController.m
//  SoundImage
//
//  Created by Manuel Marcos Regalado on 23/01/2015.
//  Copyright (c) 2015 ribot. All rights reserved.
//

#import "ViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "SoundManager.h"

@interface ViewController ()

@property (nonatomic) IBOutlet UIView *overlayView;
@property (nonatomic) UIImagePickerController *imagePickerController;
@property (nonatomic) NSMutableArray *capturedImages;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _capturedImages = [NSMutableArray new];
}

- (void)dealloc
{
    _overlayView           = nil;
    _imageView             = nil;
    _capturedImages        = nil;
    _imagePickerController = nil;
}

#pragma mark - Actions

- (IBAction)photoButtonTapped:(id)sender
{
    // Start recording
    [[SoundManager sharedInstance] recordSound];
    
    // Show the camera
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;    
    imagePickerController.delegate = self;
    
    if (imagePickerController.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        /*
         The user wants to use the camera interface. Set up our custom overlay view for the camera.
         */
        imagePickerController.showsCameraControls = NO;
        
        /*
         Load the overlay view from the OverlayView nib file. Self is the File's Owner for the nib file, so the overlayView outlet is set to the main view in the nib. Pass that view to the image picker controller to use as its overlay view, and set self's reference to the view to nil.
         */
        [[NSBundle mainBundle] loadNibNamed:@"OverlayView" owner:self options:nil];
        _overlayView.frame = imagePickerController.cameraOverlayView.frame;
        imagePickerController.cameraOverlayView = _overlayView;
        _overlayView = nil;
    }
    _imagePickerController = imagePickerController;
    [self presentViewController:_imagePickerController animated:YES completion:nil];
}

- (IBAction)takePhoto:(id)sender
{
    [_imagePickerController takePicture];
}

#pragma mark - UIImagePickerControllerDelegate

// This method is called when an image has been chosen from the library or taken from the camera.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    [_capturedImages addObject:image];
    
    [self finishAndUpdate];
}

- (void)finishAndUpdate
{
    [[SoundManager sharedInstance] stopRecord];
    [[SoundManager sharedInstance] playSound];
    
    // TODO: We also stop the recording and play de recording in a loop
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    if ([_capturedImages count] > 0)
    {
        if ([_capturedImages count] == 1)
        {
            // Camera took a single picture.
            [_imageView setImage:[_capturedImages objectAtIndex:0]];
        }
        else
        {
            // Camera took multiple pictures; use the list of images for animation.
            _imageView.animationImages = _capturedImages;
            _imageView.animationDuration = 5.0;    // Show each captured photo for 5 seconds.
            _imageView.animationRepeatCount = 0;   // Animate forever (show all photos).
            [_imageView startAnimating];
        }
        
        // To be ready to start again, clear the captured images array.
        [_capturedImages removeAllObjects];
    }
    _imagePickerController = nil;
}

@end
