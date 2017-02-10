
# ifndef __UILOCALIMAGEPICKER_9ADAD60150AD4112965B59C7CA6C850A_H_INCLUDED
# define __UILOCALIMAGEPICKER_9ADAD60150AD4112965B59C7CA6C850A_H_INCLUDED

typedef  enum
{
    ImageSourceTypeNone, //弹出选择
    ImageSourceTypeCamera,
    ImageSourceTypePhotoLibrary
} ImageSourceType;

@class UIImageLibraryPicker;
@protocol ImageLibraryPickerDelegate <NSObject>

- (void)imagePicker:(UIImageLibraryPicker *)picker didFinished:(NSString *)path;

@end

@interface UIImageLibraryPicker : NSObject

@property (nonatomic, copy) NSString* title;
@property (nonatomic, assign) CGSize thumbSize;  //返回的图片使用thumbSize
@property (nonatomic, assign) BOOL editImage;//yes 则裁剪图片   默认为NO
@property (nonatomic, assign) BOOL isFyjCut;
@property (nonatomic, strong) NSString *path;
@property (nonatomic,strong)  NSString *thumbPath;//thumbSize > 0的时候才有效
@property (nonatomic,assign) NSInteger limitCount;//默认为1  如果设置 > 1 则允许多张图片
@property (nonatomic,weak) id<ImageLibraryPickerDelegate> delegate;

- (void)execute;

- (void)execute:(ImageSourceType)type;

@end

# endif
