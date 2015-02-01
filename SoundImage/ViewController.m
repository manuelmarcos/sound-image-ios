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
#import "RowCollectionViewCell.h"

@interface ViewController ()

@property (nonatomic) IBOutlet UIView *overlayView;
@property (nonatomic) NSArray        *images;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@end

static NSString *kCellReuseIdentifier = @"uk.co.ribot.RowCollectionViewCell";

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(RowCollectionViewCell.class) bundle:nil] forCellWithReuseIdentifier:kCellReuseIdentifier];

    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)_collectionView.collectionViewLayout;
    CGSize newItemSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.width + 80);
    flowLayout.itemSize = newItemSize;
    
    // Show the camera
    _imagePickerController= [[UIImagePickerController alloc] init];
    _imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    _imagePickerController.delegate = self;
    
    if (_imagePickerController.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        /*
         The user wants to use the camera interface. Set up our custom overlay view for the camera.
         */
        _imagePickerController.showsCameraControls = NO;
        
        /*
         Load the overlay view from the OverlayView nib file. Self is the File's Owner for the nib file, so the overlayView outlet is set to the main view in the nib. Pass that view to the image picker controller to use as its overlay view, and set self's reference to the view to nil.
         */
        [[NSBundle mainBundle] loadNibNamed:@"OverlayView" owner:self options:nil];
        _overlayView.frame = _imagePickerController.cameraOverlayView.frame;
        _imagePickerController.cameraOverlayView = _overlayView;
        _overlayView = nil;
    }
    
    
    _images         = @[@"test",@"test",@"test",@"test",@"test",@"test"];
}

- (void)dealloc
{
    // TODO:
    _overlayView           = nil;
    _images        = nil;
    _imagePickerController = nil;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RowCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellReuseIdentifier forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:_images[indexPath.item]];
    cell.titleImage.text    = @"YEAH";
    return cell;
}

#pragma mark - Actions

- (IBAction)photoButtonTapped:(id)sender
{    
    // Start recording
    [[SoundManager sharedInstance] recordSound];
    
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
    [self finishAndUpdateWithImage:[info valueForKey:UIImagePickerControllerOriginalImage]];
}

- (void)finishAndUpdateWithImage:(UIImage *)imageTaken
{
    // TODO: do something with the image
    [[SoundManager sharedInstance] stopRecord];
    [[SoundManager sharedInstance] playSound];
}

@end
