
//# import "Common.h"
# import "UIImageLibrary.h"
# import "FileSystem+Extension.h"
# import "AppDelegate.h"
//# import "Objc+Extension.h"
# import "ImageResizeOperation.h"
# import "VCAssetsPicker.h"
# import "UIButtonExt.h"
@interface UIImageLibraryPicker ()
<UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate,VCAssetsPickerControllerDelegate>
{
    UIView *  alphaView;
}
@property (nonatomic,assign) NSUInteger downdount;
@end

@implementation UIImageLibraryPicker

- (id)init {
    self = [super init];
    
    self.path = [FileSystem shared].temporary;
   // self.title = @"选择照片";
    _thumbSize = CGSizeZero;
    _editImage = NO;
    _isFyjCut = YES;
    _limitCount = 1;

    return self;
}
- (void)execute {
    [self execute:ImageSourceTypeNone];
}
- (void)execute:(ImageSourceType)type
{
    switch (type) {
        case ImageSourceTypeNone:
        {
            

            
            UIActionSheet* action = [[UIActionSheet alloc] initWithTitle:@"选取照片"
                                                                delegate:self
                                                       cancelButtonTitle:@"取消"
                                                  destructiveButtonTitle:nil
                                                       otherButtonTitles:@"从手机相册选择",@"拍照", nil];
            [action showInView:[AppDelegate sharedInstance].window];
        }
            break;
       
        case ImageSourceTypePhotoLibrary:
            [self showPicker:UIImagePickerControllerSourceTypePhotoLibrary];

            break;
        case ImageSourceTypeCamera:
            [self showPicker:UIImagePickerControllerSourceTypeCamera];
            break;
        default:
            break;
    }
}
- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    for (UIView *subViwe in actionSheet.subviews) {
        if ([subViwe isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton*)subViwe;
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
    }
}
- (void)showPicker:(UIImagePickerControllerSourceType) sourceType
{
    if ([UIImagePickerController isSourceTypeAvailable:sourceType])
    {
        if (sourceType == UIImagePickerControllerSourceTypePhotoLibrary && self.limitCount > 1) {
            VCAssetsPicker *picker = [[VCAssetsPicker alloc] init];
            picker.maximumNumberOfSelection = self.limitCount;
            picker.assetsFilter = [ALAssetsFilter allAssets];
            picker.delegate = self;
            [[AppDelegate sharedInstance].topMostViewContrller presentViewController:picker animated:YES completion:nil];

        }
        else
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.sourceType = sourceType;
            imagePicker.delegate = self;
            [imagePicker setAllowsEditing:self.editImage];
            [[AppDelegate sharedInstance].topMostViewContrller presentViewController:imagePicker animated:YES completion:nil];
        }
    }

}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if (buttonIndex == 1) {
        sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else if (buttonIndex == 0) {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    if ([UIImagePickerController isSourceTypeAvailable:sourceType])
    {
       [self showPicker:sourceType];
        
    }

}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    [self cbDone:image];
    [picker dismissViewControllerAnimated:YES completion:nil];

}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image;
    if(self.editImage)
    {
        image = [info objectForKey: UIImagePickerControllerEditedImage];
    }
    else
    {
        image = [info objectForKey: UIImagePickerControllerOriginalImage];
    }
    [self cbDone:image];
    [picker dismissViewControllerAnimated:YES completion:nil];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
 
}

- (void)cbCancel:(id)sender {
       /// [crop.navigationController dismissModalViewController];
}

- (void)cbDone:(UIImage *)image {
    
    NSString *fileName = [NSString stringWithFormat:@"%lu%@.jpg",(unsigned long)self.downdount, [[NSString stringWithFormat:@"%d",(int)time(NULL)] md5]];
    if(self.isFyjCut)
    {
        CGSize outputImageSize = [self calculateFYJSizeimage:image];//CGSizeMake(maxWidth, maxHeight);
        ImageResizeOperation *op = [[ImageResizeOperation alloc] initWithImage:image];
        [op writeResultToPath:[self.path stringByAppendingString:fileName]];
        [op resizeToFitWithinSize:outputImageSize];
        [op start];
    }
    else
    {
        float maxWidth =  [UIScreen mainScreen].bounds.size.width *2;
        float maxHeight = [UIScreen mainScreen].bounds.size.height*2;
        CGSize outputImageSize = CGSizeMake(maxWidth, maxHeight);
        ImageResizeOperation *op = [[ImageResizeOperation alloc] initWithImage:image];
        [op writeResultToPath:[self.path stringByAppendingString:fileName]];
        [op resizeToFitWithinSize:outputImageSize];
        [op start];
    }
    

    if (CGSizeEqualToSize(self.thumbSize, CGSizeZero) == NO)
    {
       NSString* thumb_fileName  = [NSString stringWithFormat:@"thumb_%@",fileName];

        self.thumbPath = [self.path stringByAppendingString:thumb_fileName];
        ImageResizeOperation *opt = [[ImageResizeOperation alloc] initWithImage:image];
        [opt writeResultToPath:self.thumbPath];
        [opt resizeToFitWithinSize:CGSizeMake(self.thumbSize.width*2, self.thumbSize.height*2) ];
        [opt start];
        
        self.thumbPath = [self.path stringByAppendingString:fileName];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(imagePicker:didFinished:)]) {
        [_delegate imagePicker:self didFinished:[self.path stringByAppendingString:fileName]];
    }
}
//图片尺寸规则
-(CGSize)calculateFYJSizeimage:(UIImage *)image
{
    CGSize fyjSize = CGSizeZero;
    
    float w = image.size.width;
    float h = image.size.height;
    if(h>w)
    {
        float ratio = h/w;
        if(ratio > 2.4)
        {
            fyjSize = CGSizeMake(w, h);
        }
        else
        {
            if(h <= 640)
            {
                fyjSize = CGSizeMake(w, h);
            }
            else if (h <= 1920)
            {
                fyjSize = CGSizeMake(w/2, h/2);
            }
            else
            {
                fyjSize = CGSizeMake(w/h*960.0, 960.0);
            }
        }
    }
    else
    {
        float ratio = w/h;
        if(ratio > 2.4)
        {
            fyjSize = CGSizeMake(w, h);
        }
        else
        {
            if(w <= 640)
            {
                fyjSize = CGSizeMake(w, h);
            }
            else if(w <= 1920)
            {
                fyjSize = CGSizeMake(w/2, h/2);
            }
            else
            {
                fyjSize = CGSizeMake(960, h/w*960);
            }
        }
    }
    return fyjSize;
}
#pragma mark - mutable image picker delegate
- (void)assetsPickerController:(VCAssetsPicker *)picker didFinishPickingAssets:(NSArray *)assets

{
  //  DISPATCH_ASYNC(
    
        for (ALAsset *a in assets) {
            UIImage *fullImage = [UIImage imageWithCGImage:[a.defaultRepresentation fullScreenImage]
                                                                scale:[a.defaultRepresentation scale] orientation:UIImageOrientationUp];
            ////(UIImageOrientation)[a.defaultRepresentation orientation]
            //延迟0.1秒处理，避免产生的图片名字冲突
           // DISPATCH_DELAY_BEGIN(.1)
            self.downdount++;
                [self cbDone:fullImage];
            }
                [picker dismissViewControllerAnimated:YES completion:nil];
 
        //  )

}
- (void)assetsPickerControllerDidCancel:(VCAssetsPicker *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];

}

@end
