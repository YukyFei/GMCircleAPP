
#import "TapImgView.h"

@interface TapImgView()
{
    UITapGestureRecognizer *tapGes;
    UITapGestureRecognizer *doubleGes;
    UILongPressGestureRecognizer *longGes;
}
@end

@implementation TapImgView

-(id)init
{
    self  = [super init];
    if(self)
    {
        _isZoom = NO;
        self.userInteractionEnabled = YES;
        tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handTap:)];
        tapGes.numberOfTapsRequired = 1;
        tapGes.numberOfTouchesRequired = 1;
        doubleGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handDoubleTap:)];
        doubleGes.numberOfTapsRequired = 2;
        doubleGes.numberOfTouchesRequired = 1;
        [tapGes requireGestureRecognizerToFail:doubleGes];
        longGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handLong:)];
        [self addGestureRecognizer:tapGes];
        [self addGestureRecognizer:doubleGes];
        [self addGestureRecognizer:longGes];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _isZoom = NO;
        self.userInteractionEnabled = YES;
        tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handTap:)];
        tapGes.numberOfTapsRequired = 1;
        tapGes.numberOfTouchesRequired = 1;
        doubleGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handDoubleTap:)];
        doubleGes.numberOfTapsRequired = 2;
        doubleGes.numberOfTouchesRequired = 1;
        [tapGes requireGestureRecognizerToFail:doubleGes];
        longGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handLong:)];
        [self addGestureRecognizer:tapGes];
        [self addGestureRecognizer:doubleGes];
        [self addGestureRecognizer:longGes];
    }
    return self;
}
-(void)handTap:(UITapGestureRecognizer *)tap
{
    if([self.delegate respondsToSelector:@selector(TapImgViewTapTouch:)])
    {
        [self.delegate TapImgViewTapTouch:self];
    }
}
-(void)handDoubleTap:(UITapGestureRecognizer *)tap
{
    _isZoom = !_isZoom;
    CGPoint p = [tap locationInView:self.superview];
//    if([self.delegate respondsToSelector:@selector(TapImgViewdoubleTouch:zoomState:)])
//    {
//        [self.delegate TapImgViewdoubleTouch:self zoomState:self.isZoom];
//    }
    if ([self.delegate respondsToSelector:@selector(TapImgViewdoubleTouch:touchPoint:zoomState:)]) {
        [self.delegate TapImgViewdoubleTouch:self touchPoint:p zoomState:self.isZoom];
    }
}
-(void)handLong:(UILongPressGestureRecognizer *)longP
{}
@end

#pragma mark - ImgScrollView

@interface ImgScrollView ()<TapImgViewDelegate,UIScrollViewDelegate>
{
    //记录自己的位置,完整显示图片时大小
    CGRect scaleOriginRect;
    //图片的大小
    CGSize imgSize;
    //缩放前大小
    CGRect initRect;
}
@property (nonatomic,strong) TapImgView *imgView;
@end

@implementation ImgScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.bouncesZoom = YES;
        self.backgroundColor = [UIColor clearColor];
        self.minimumZoomScale = 1.0;
        self.userInteractionEnabled = YES;
        self.delegate = self;
        
        _imgView = [[TapImgView alloc] init];
        _imgView.delegate = self;
        _imgView.backgroundColor = [UIColor redColor];
        _imgView.clipsToBounds = YES;
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_imgView];
        
    }
    return self;
}

- (void)setContentWithFrame:(CGRect) rect
{
    _imgView.frame = rect;
    initRect = rect;
}

- (void)setAnimationRect:(BOOL)animal
{
    if(animal)
    {
        [UIView animateWithDuration:0.4 animations:^{
            _imgView.frame = scaleOriginRect;
        }];
    }
    else
    {
         _imgView.frame = scaleOriginRect;
    }
}

- (void)canceShowInitRect:(BOOL)animal
{
    if(animal)
    {
        [UIView animateWithDuration:0.4 animations:^{
            self.zoomScale = 1.0;
            _imgView.frame = initRect;
        }];
    }
    else
    {
        self.zoomScale = 1.0;
        _imgView.frame = initRect;
    }
}

- (void)setImage:(UIImage *) image
{
    if (image)
    {
        _imgView.image = image;
        imgSize = image.size;
        
        //判断首先缩放的值
        float scaleX = self.frame.size.width/imgSize.width;
        float scaleY = self.frame.size.height/imgSize.height;
        
        //倍数小的，先到边缘
        
        if (scaleX > scaleY)
        {
            //Y方向先到边缘
            float imgViewWidth = imgSize.width*scaleY;
            self.maximumZoomScale = self.frame.size.width/imgViewWidth;
            
            scaleOriginRect = (CGRect){self.frame.size.width/2-imgViewWidth/2,0,imgViewWidth,self.frame.size.height};
        }
        else
        {
            //X先到边缘
            float imgViewHeight = imgSize.height*scaleX;

            if(imgSize.height>imgSize.width)
            {
                self.maximumZoomScale = self.frame.size.height*1.5/imgViewHeight;//即使x先到边缘，是长方形的话也要放大超过屏幕
            }
            else
            {
                self.maximumZoomScale = self.frame.size.height/imgViewHeight;
            }
            
            scaleOriginRect = (CGRect){0,self.frame.size.height/2-imgViewHeight/2,self.frame.size.width,imgViewHeight};
        }
    }
}
#pragma mark - scroll delegate
- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imgView;
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    
    CGSize boundsSize = scrollView.bounds.size;
    CGRect imgFrame = _imgView.frame;
    CGSize contentSize = scrollView.contentSize;
    
    CGPoint centerPoint = CGPointMake(contentSize.width/2, contentSize.height/2);
    
    // center horizontally
    if (imgFrame.size.width <= boundsSize.width)
    {
        centerPoint.x = boundsSize.width/2;
    }
    
    // center vertically
    if (imgFrame.size.height <= boundsSize.height)
    {
        centerPoint.y = boundsSize.height/2;
    }
    
    _imgView.center = centerPoint;
}
#pragma mark TapImgView delegate
-(void)TapImgViewTapTouch:(TapImgView *)imgView
{    
    if([self.imgDelegate  respondsToSelector:@selector(ImgScrollViewTapTouch:)])
    {
        [self.imgDelegate ImgScrollViewTapTouch:self];
    }
}
-(void)TapImgViewdoubleTouch:(TapImgView *)imgView touchPoint:(CGPoint)pt zoomState:(BOOL)isZoom
{
    if(isZoom)
    {
        [self setZoomScale:self.maximumZoomScale animated:YES];
//        CGPoint cen = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
//        CGFloat xDis = (cen.x - pt.x);
//        CGFloat yDis = (cen.y - pt.y);
//        //float distance = sqrt((xDis*xDis) + (yDis*yDis));
//        
//        CGPoint pOffset = [self contentOffset];
//        pOffset.x = pOffset.x - xDis;
//        pOffset.y = pOffset.y - yDis;
//        [self setContentOffset:pOffset];
        
    }
    else
    {
        [self setZoomScale:1.0 animated:YES];
    }
}
@end
