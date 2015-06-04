//
//  ASCoreImageView.m
//  ascii-shots
//
//  Created by Andrew Brandt on 5/1/15.
//  Copyright (c) 2015 dorystudios. All rights reserved.
//

#import "ASCoreImageView.h"
#import "ImageHelper.h"

@interface ASCoreImageView ()

@property (nonatomic, strong, readonly) CIContext *drawContext;
@property (nonatomic, strong) ImageHelper *imageHelper;
@property (nonatomic, strong) CIImage *image;
@property (nonatomic, strong) CIImage *template;

@end

@implementation ASCoreImageView

- (instancetype)initWithFrame: (CGRect)frame {
    EAGLContext *eaglContext = [[EAGLContext alloc] initWithAPI: kEAGLRenderingAPIOpenGLES2];
    self = [super initWithFrame:frame context:eaglContext];
    
    if (self) {
        NSDictionary *options = @{ kCIContextWorkingColorSpace: [NSNull null]};
        _drawContext = [CIContext contextWithEAGLContext:eaglContext options:options];
        self.enableSetNeedsDisplay = NO;

        self.imageHelper = [[ImageHelper alloc] init];
        self.imageHelper.scale = self.window.screen.scale;
        [self.imageHelper addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:nil];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"template1"
                                                     ofType:@"jpg"];
        NSData *templateFile = [NSData dataWithContentsOfFile:path];
        self.template = [CIImage imageWithData:templateFile];
    }
    
    return self;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"image"];
}

- (void)startCapture {
    [self.imageHelper startCaptureSession];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"image"]) {
        self.image = self.imageHelper.image;
        [self display];
    }
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGFloat scale = self.window.screen.scale;
    CGRect destRect = CGRectApplyAffineTransform(self.bounds, CGAffineTransformMakeScale(scale, scale));
    //CGRect destRect = CGRectApplyAffineTransform(self.bounds, CGAffineTransformMakeScale(1.0, 1.0));
    [self.drawContext drawImage:self.image inRect:destRect fromRect:self.image.extent];
    //[self.drawContext drawImage:self.template inRect:self.template.extent fromRect:self.template.extent];
}

@end
