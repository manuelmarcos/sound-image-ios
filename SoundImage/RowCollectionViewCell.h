//
//  RowCollectionViewCell.h
//  SoundImage
//
//  Created by Manuel Marcos Regalado on 01/02/2015.
//  Copyright (c) 2015 ribot. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RowCollectionViewCellDelegate;

@interface RowCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UILabel     *titleImage;
@property (nonatomic, strong) IBOutlet UIButton    *muteButton;
@property (nonatomic, strong) NSURL *outputFileSoundURL;
@property (nonatomic, weak) id<RowCollectionViewCellDelegate> delegate;

@end

@protocol RowCollectionViewCellDelegate <NSObject>

- (void)rowCollectionViewCellMuteButtonTapped:(RowCollectionViewCell *)rowCollectionViewCell;

@end
