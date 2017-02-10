//
//  VCAssetsPicker.h
//  youka
//
//  Created by leijun on 14-7-28.
//  Copyright (c) 2014年 BlueRain. All rights reserved.
//

# import <AssetsLibrary/AssetsLibrary.h>
//# import "UITypes+Extension.h"
#import "Masonry.h"

@protocol VCAssetsPickerControllerDelegate;

@interface VCAssetsPicker : UINavigationController

@property (nonatomic, assign) id <UINavigationControllerDelegate, VCAssetsPickerControllerDelegate> delegate;

@property (nonatomic, strong) ALAssetsFilter *assetsFilter;

@property (nonatomic, assign) NSInteger maximumNumberOfSelection;

@end


@protocol VCAssetsPickerControllerDelegate <NSObject>


- (void)assetsPickerController:(VCAssetsPicker *)picker didFinishPickingAssets:(NSArray *)assets;

@optional
- (void)assetsPickerControllerDidCancel:(VCAssetsPicker *)picker;

@end
