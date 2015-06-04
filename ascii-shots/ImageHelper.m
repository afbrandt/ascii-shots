//
//  ImageHelper.m
//  ascii-shots
//
//  Created by Andrew Brandt on 4/26/15.
//  Copyright (c) 2015 dorystudios. All rights reserved.
//

#import "ImageHelper.h"
#import "ASAsciiFilter.h"

@interface ImageHelper()

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) ASAsciiFilter *myFilter;
@property (nonatomic, strong, readwrite) CIImage *image;
@property (nonatomic, strong) NSDictionary *pxBufOpts;
//@property (nonatomic, strong) AVCaptureDeviceInput *camera;

@end

@implementation ImageHelper

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        [self configureCaptureSession];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"template3"
                                                     ofType:@"jpg"];
        NSData *templateFile = [NSData dataWithContentsOfFile:path];
        CIImage *templateImage = [CIImage imageWithData:templateFile];
        self.myFilter = [ASAsciiFilter filterWithTemplate:templateImage];
        
        self.pxBufOpts = @{(id)kCVPixelBufferPixelFormatTypeKey: @(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)};
    }
    
    return self;
}


- (void)startCaptureSession {
    [self.session startRunning];
}

#pragma MARK: - AVCaptureVideoDataOutputSampleBufferDelegate method

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    CIImage *srcImage = [[CIImage alloc] initWithCVPixelBuffer:CMSampleBufferGetImageBuffer(sampleBuffer)];
    
    CIImage *rotatedImage = [srcImage imageByApplyingTransform:CGAffineTransformMakeRotation(-M_PI/2)];
    
    CIFilter *pFilter = [CIFilter filterWithName:@"CIPixellate"];
    [pFilter setValue:rotatedImage forKey:kCIInputImageKey];
    [pFilter setValue:@30.0 forKey:kCIInputScaleKey];
    CIImage *pixelated = [pFilter outputImage];
    
    self.myFilter.inputImage = pixelated;
    self.image = [self.myFilter outputImage];
}

#pragma MARK: - Configuration methods

- (void)configureCaptureSession {
    self.session = [[AVCaptureSession alloc] init];
    //configure session input
    NSArray *sources = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in sources) {
        if (device.position == AVCaptureDevicePositionBack) {
            NSError *error;
            AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
            //self.camera = input;
            if ([self.session canAddInput:input]) {
                [self.session addInput:input];
            }
        }
    }
    //configure session output
    AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
    [output setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    output.alwaysDiscardsLateVideoFrames = YES;
    NSString *keyRGB = (NSString *)kCVPixelBufferPixelFormatTypeKey;
    NSNumber *valRGB = [NSNumber numberWithUnsignedInt: kCVPixelFormatType_32BGRA];
    [output setVideoSettings:@{keyRGB:valRGB}];
    if ([self.session canAddOutput:output]) {
        [self.session addOutput:output];
    }
    [self.session commitConfiguration];
}


@end
