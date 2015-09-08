//
//  ViewController.h
//  SoundImage
//
//  Created by Manuel Marcos Regalado on 23/01/2015.
//  Copyright (c) 2015 ribot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "RowCollectionViewCell.h"

@interface ViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, RowCollectionViewCellDelegate>

@end
