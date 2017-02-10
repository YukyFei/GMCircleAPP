//
//  ImageResizeOperation.h
//  secret
//
//  Created by leijun on 14-4-3.
//  Copyright (c) 2014年 hoodinn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageResizeOperation : NSOperation

// The resized image, or nil if an error occurred
@property (nonatomic,readonly,strong) UIImage* result;

// TODO: If the resize fails, this will describe the error
//@property (nonatomic,strong) NSError* error;

- (id)initWithImage:(UIImage*)image;
- (id)initWithPath:(NSString*)inputPath;

- (void)resizeToFitWithinSize:(CGSize)fitWithinSize;
- (void)cropToAspectRatioWidth:(CGFloat)width height:(CGFloat)height;
- (void)writeResultToPath:(NSString*)outputPath;

// Options
@property (nonatomic,assign) CGFloat JPEGcompressionQuality;


@end
