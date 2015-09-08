//
//  SoundImage.h
//  SoundImage
//
//  Created by Manuel Marcos Regalado on 01/02/2015.
//  Copyright (c) 2015 ribot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SoundImage : NSObject

@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) NSString *titleImage;
@property (nonatomic, strong) NSURL *fileToBePlayedURL;
@property (nonatomic, getter = isMuted) BOOL  muted;

@end
