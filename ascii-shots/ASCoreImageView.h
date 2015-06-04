//
//  ASCoreImageView.h
//  ascii-shots
//
//  Created by Andrew Brandt on 5/1/15.
//  Copyright (c) 2015 dorystudios. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface ASCoreImageView : GLKView

- (instancetype)initWithFrame: (CGRect)frame;
- (void)startCapture;

@end
