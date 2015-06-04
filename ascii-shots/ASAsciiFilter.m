//
//  ASAsciiFilter.m
//  ascii-shots
//
//  Created by Andrew Brandt on 5/4/15.
//  Copyright (c) 2015 dorystudios. All rights reserved.
//

#import "ASAsciiFilter.h"

@interface ASAsciiFilter ()

@end

@implementation ASAsciiFilter

+ (instancetype)filterWithTemplate: (CIImage *)image {
    ASAsciiFilter *filter = [[ASAsciiFilter alloc] init];
    [filter setTemplate:image];
    return filter;
}

- (void)setTemplate: (CIImage *)image {
    _templateImage = image;
}

- (CIKernel *)filterKernel {
    static CIKernel *kernel = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        kernel = [CIKernel kernelWithString:
            @"kernel vec4 ascii (sampler image, sampler templateImage) {\n"
             " vec2 dc = destCoord();\n"
             " vec4 px = sample(image, samplerTransform(image, dc));\n"
             " float offset = floor(6.1*px.r + 3.1*px.b + 1.1*px.g);\n"
             " float x = mod(dc.x, 30.0);\n"
             " float y = mod(dc.y, 30.0);\n"
             " vec2 loc = mod(dc,vec2(30.,30.));\n"
             " loc += vec2(offset*30.0,0);\n"
             " vec4 tempx = sample(templateImage, samplerTransform(templateImage, loc));\n"
             " px.a = 1.-(tempx.r+tempx.b+tempx.g);\n"
             " return px;\n"
             "}"
        ];
    });
    return kernel;
}

- (CIImage *)outputImage {
    NSArray *args = @[self.inputImage, self.templateImage];
    return [[self filterKernel]
                applyWithExtent:self.inputImage.extent
                roiCallback:^CGRect(int index, CGRect rect) {
                    return rect;
                    //return regionOf(index, rect);
                }
                arguments: args];
}

CGRect regionOf(int index, CGRect rect) {
    if (index == 0) {
        return CGRectInset(rect, -1, -1);
    }
    else if (index == 1) {
        return rect;
    }
    return CGRectNull;
}

@end
