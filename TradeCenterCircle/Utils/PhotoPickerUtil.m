//
//  PhotoPickerUtil.m
//  YourMate
//
//  Created by Tang Shilei on 14-12-11.
//  Copyright (c) 2014年 Yourmate. All rights reserved.
//

#import "PhotoPickerUtil.h"
#import "UIView+BUIView.h"


@interface PhotoPickerUtil()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(nonatomic,copy)shotPictureBlock mBlock;


@end

@implementation PhotoPickerUtil

DEF_SINGLETON(PhotoPickerUtil);

-(void)showImagePickController:(UIViewController *)viewController  andFinishBlock:(shotPictureBlock)block
{
    
    _mBlock=[block copy];
    
    [UIActionSheet showInView:viewController.view withTitle:@"选择照片" cancelButtonTitle:@"取消" deleteButtonTitle:nil completeBlcok:^(NSUInteger index, UIActionSheet *action) {
        UIImagePickerControllerSourceType sourceType;
        if(index!=action.numberOfButtons-1)
        {
            
            if(index==0)
                sourceType=UIImagePickerControllerSourceTypeCamera;
            else
                sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
            
            
#if TARGET_IPHONE_SIMULATOR
            if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
            }
#endif
            UIImagePickerController *picker=[[UIImagePickerController alloc]init];
            picker.delegate=self;
            //picker.allowsEditing=YES;
            picker.sourceType=sourceType;
            [viewController presentViewController:picker animated:YES completion:nil];
        }
        
        //        else
        //        {
        //
        //        }
        
        
    } otherButtonTitles:@"相机",@"相册", nil];
}



#pragma mark--UIImagePickerControllerDelegate
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image=[info objectForKey:UIImagePickerControllerOriginalImage];
    if(self.mBlock)
        self.mBlock(image);
    //    if(picker.sourceType==UIImagePickerControllerSourceTypeCamera)
    //    {
    //        NSString *imageName= [NSString stringWithFormat:@"%@.jpg",[Configuration stringWithUUID]];
    //        NSString *docPath=[Configuration getDocumentFileDirectoryPath:imageName];
    //        self.picNameLabel.text=imageName;
    //        [self.dataArray addObject:imageName];
    //
    //        if(![Configuration isFileExist:docPath])
    //        {
    //            NSData *data=UIImageJPEGRepresentation(image, 0.8);
    //            [data writeToFile:docPath atomically:YES];
    //        }
    //    }
    //    else
    //    {
    //        NSURL *refURL=[info valueForKey:UIImagePickerControllerReferenceURL];
    //        ALAssetsLibrary *assetsLibrary=[[ALAssetsLibrary alloc]init];
    //        [assetsLibrary assetForURL:refURL resultBlock:^(ALAsset *asset) {
    //
    //            ALAssetRepresentation *imageRep=[asset defaultRepresentation];
    //            NSString *imageName=[imageRep filename];
    //            NSString *docPath=[Configuration getDocumentFileDirectoryPath:imageName];
    //            self.picNameLabel.text=imageName;
    //            [self.dataArray addObject:imageName];
    //            if(![Configuration isFileExist:docPath])
    //            {
    //                NSData *data=UIImageJPEGRepresentation(image, 0.8);
    //                [data writeToFile:docPath atomically:YES];
    //            }
    
    
    //        } failureBlock:nil];
    
    //}
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

@end
