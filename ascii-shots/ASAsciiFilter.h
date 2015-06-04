//
//  ASAsciiFilter.h
//  ascii-shots
//
//  Created by Andrew Brandt on 5/4/15.
//  Copyright (c) 2015 dorystudios. All rights reserved.
//

#import <CoreImage/CoreImage.h>

@interface ASAsciiFilter : CIFilter

@property (nonatomic, retain) CIImage *inputImage;
@property (nonatomic, strong, readonly) CIImage *templateImage;

+ (instancetype)filterWithTemplate: (CIImage *)image;

@end
