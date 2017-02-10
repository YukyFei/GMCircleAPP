
#import <UIKit/UIKit.h>

typedef enum
{
    CMTViewHorizontalStyle,
    CMTViewVerticalStyle,
}CMTViewStyle;



@class GGCMTView;
@protocol cmtViewDataSource <NSObject>
@required
- (NSInteger)numberOfPageInCmtView:(GGCMTView *)cmtView;
- (__kindof UITableViewCell *)cmtView:(GGCMTView *)cmtView cellForIndex:(NSInteger)index;

@end

@protocol cmtViewDelegate <NSObject>
@optional
- (void)cmtView:(GGCMTView *)cmtView didSelectIndex:(NSInteger)index;
@end



@interface GGCMTView : UIView
@property(nonatomic,weak)id<cmtViewDelegate>delegate;
@property(nonatomic,weak)id<cmtViewDataSource>dataSource;
@property(nonatomic,assign,readonly)CMTViewStyle  cmtViewStyle;
@property(nonatomic,assign)double  timeInterval;
@property(nonatomic,assign)BOOL  enableUserScroll;

@property (nonatomic,strong) UIPageControl * pageControl ;

- (instancetype)initWithFrame:(CGRect)frame andCMTViewStyle:(CMTViewStyle)cmtViewStyle;
- (__kindof UITableViewCell *)dequeueReusableCMTViewCellWithIdentifier:(NSString *)identifier;
- (void)registerNib:(UINib *)nib forCMTViewCellReuseIdentifier:(NSString *)identifier;

- (void)prepareScroll;
- (void)startScroll;
- (void)stopScroll;
- (void)pauseScroll;
- (void)continueScroll;


@end
