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
#import "SoundImage.h"
#import "RowCollectionViewCell.h"

@interface ViewController ()

@property (nonatomic) IBOutlet UIView *overlayView;
@property (nonatomic) UIImagePickerController *imagePickerController;
@property (nonatomic) NSArray        *soundImageObjects;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, assign) CGFloat lastContentOffset;
@property (nonatomic, assign) CGFloat currentIndex;

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

    
    SoundImage *soundsImageObject = [SoundImage new];
    soundsImageObject.imageName = @"drummer";
    soundsImageObject.fileToBePlayedURL =[[NSURL alloc] initWithString:[[NSBundle mainBundle] pathForResource:@"drumBeat" ofType:@"wav"]];
    soundsImageObject.titleImage = @"hola";
    soundsImageObject.muted = NO;
    
    
    SoundImage *soundsImageObject2 = [SoundImage new];
    soundsImageObject2.imageName = @"drummer";
    soundsImageObject2.fileToBePlayedURL =[[NSURL alloc] initWithString:[[NSBundle mainBundle] pathForResource:@"drumBeat" ofType:@"wav"]];
    soundsImageObject2.titleImage = @"hola";
    soundsImageObject2.muted = YES;
    
    _soundImageObjects         = @[soundsImageObject,soundsImageObject2,soundsImageObject,soundsImageObject2,soundsImageObject];
}

- (void)dealloc
{
    // TODO:
    _overlayView           = nil;
    _soundImageObjects     = nil;
    _imagePickerController = nil;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _soundImageObjects.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RowCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellReuseIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    
    SoundImage *rowSoundImage = (SoundImage *)_soundImageObjects[indexPath.item];
    cell.imageView.image = [UIImage imageNamed:rowSoundImage.imageName];
    cell.titleImage.text    = rowSoundImage.titleImage;
    cell.outputFileSoundURL = rowSoundImage.fileToBePlayedURL;
    UIImage *muteButtonImage = nil;
    if ([rowSoundImage isMuted] == YES)
    {
        muteButtonImage = [UIImage imageNamed:@"mute"];
    }
    else
    {
        muteButtonImage = [UIImage imageNamed:@"unmuted"];
    }
    [cell.muteButton setImage:muteButtonImage forState:UIControlStateNormal];

    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)_collectionView.collectionViewLayout;
    CGPoint queryPoint = CGPointZero;
    for (UICollectionViewCell *cell in [_collectionView visibleCells])
    {
        // Determine the direction of the scrollview
        if (self.lastContentOffset > scrollView.contentOffset.y)
        {
           queryPoint  = CGPointMake(0, flowLayout.itemSize.height);
        }
        else if (self.lastContentOffset < scrollView.contentOffset.y)
        {
            CGFloat queryXOffet  = (flowLayout.itemSize.width / 2);
            CGFloat queryYOffet = (self.view.frame.size.height - (flowLayout.itemSize.height - 80));
            queryPoint = CGPointMake(queryXOffet, queryYOffet);
        }
        
        CGPoint convertedPoint = [_collectionView convertPoint:queryPoint fromView:_collectionView.superview];
        NSIndexPath *topVisibleCellIndexPath = [_collectionView indexPathForItemAtPoint:convertedPoint];
        if (topVisibleCellIndexPath.item != _currentIndex && topVisibleCellIndexPath != nil)
        {
            _currentIndex = topVisibleCellIndexPath.item;
            RowCollectionViewCell *currentCollectionViewCell = (RowCollectionViewCell *)cell;
            
            SoundImage *soundsImageObject = (SoundImage *)_soundImageObjects[topVisibleCellIndexPath.item];
            if ([soundsImageObject isMuted] == YES)
            {
                [[SoundManager sharedInstance] stopSound];
            }
            else
            {
                RowCollectionViewCell *currentCollectionViewCell = (RowCollectionViewCell *)cell;
                [[SoundManager sharedInstance] playSoundWithContentsOfURL:currentCollectionViewCell.outputFileSoundURL];
            }
        }
        self.lastContentOffset = scrollView.contentOffset.y;
    }
}

#pragma mark - Actions

- (IBAction)photoButtonTapped:(id)sender
{
    // Set Up the collection view
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(RowCollectionViewCell.class) bundle:nil] forCellWithReuseIdentifier:kCellReuseIdentifier];

    
    // Start recording
    [[SoundManager sharedInstance] recordSound];
    
    // Show the camera
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.delegate = self;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;

    
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

#pragma mark - RowCollectionViewCellDelegate

- (void)rowCollectionViewCellMuteButtonTapped:(RowCollectionViewCell *)rowCollectionViewCell
{
    NSIndexPath *indexPath = [_collectionView indexPathForCell:rowCollectionViewCell];
    SoundImage *soundImage = (SoundImage *)_soundImageObjects[indexPath.item];
    if ([soundImage isMuted] == YES)
    {
        [[SoundManager sharedInstance] playSoundWithContentsOfURL:rowCollectionViewCell.outputFileSoundURL];
        soundImage.muted = NO;
    }
    else
    {
        [[SoundManager sharedInstance] stopSound];
        soundImage.muted = YES;
    }
    [_collectionView reloadData];
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
    //[[SoundManager sharedInstance] playSound];
    [_imagePickerController dismissViewControllerAnimated:YES completion:nil];
    _imagePickerController = nil;
}

@end
