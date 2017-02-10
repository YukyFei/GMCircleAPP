//
//  PhotoPickerUtil.h
//  YourMate
//
//  Created by Tang Shilei on 14-12-11.
//  Copyright (c) 2014年 Yourmate. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^shotPictureBlock)(UIImage *image);
@interface PhotoPickerUtil : NSObject


//单例  sharedInstance
AS_SINGLETON(PhotoPickerUtil);

-(void)showImagePickController:(UIViewController*)viewController andFinishBlock:(shotPictureBlock)block;
@end
