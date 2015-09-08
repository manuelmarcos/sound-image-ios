//
//  RowCollectionViewCell.m
//  SoundImage
//
//  Created by Manuel Marcos Regalado on 01/02/2015.
//  Copyright (c) 2015 ribot. All rights reserved.
//

#import "RowCollectionViewCell.h"

@implementation RowCollectionViewCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self  addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(soundImagePressed)]];

    }
    return self;
}
- (void)soundImagePressed
{
    if ([_delegate respondsToSelector:@selector(rowCollectionViewCellMuteButtonTapped:)])
    {
        [_delegate rowCollectionViewCellMuteButtonTapped:self];
    }
}

@end
