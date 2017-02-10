
#import <UIKit/UIKit.h>

@class TapImgView;
@protocol TapImgViewDelegate <NSObject>

@optional
-(void)TapImgViewTapTouch:(TapImgView *)imgView;
-(void)TapImgViewdoubleTouch:(TapImgView *)imgView touchPoint:(CGPoint)pt zoomState:(BOOL)isZoom;
@end


@interface TapImgView : UIImageView
@property (nonatomic, strong) id identifier;
@property (nonatomic, readonly) BOOL isZoom;
@property (nonatomic, weak) id<TapImgViewDelegate> delegate;
@end

@class ImgScrollView;
@protocol ImgScrollViewDelegate <NSObject>
@optional
-(void)ImgScrollViewTapTouch:(ImgScrollView *)imgScroll;
@end

@interface ImgScrollView : UIScrollView
@property (nonatomic,weak) id<ImgScrollViewDelegate> imgDelegate;
-(void) setContentWithFrame:(CGRect)rect;
-(void) setImage:(UIImage *)image;
-(void) setAnimationRect:(BOOL)animal;
-(void) canceShowInitRect:(BOOL)animal;

@end