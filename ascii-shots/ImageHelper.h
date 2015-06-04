//
//  ImageHelper.h
//  ascii-shots
//
//  Created by Andrew Brandt on 4/26/15.
//  Copyright (c) 2015 dorystudios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@import GLKit;

@interface ImageHelper : NSObject <AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic, strong, readonly) CIImage *image;
@property (nonatomic, assign) CGFloat scale;

- (void)startCaptureSession;

@end
