

#import "GGCMTView.h"
#import "UIView+Frame.h"

#define SCROLLVIEWCONTENTSIZE 3


@interface GGCMTView()<UIScrollViewDelegate>

@property(nonatomic,weak)UIScrollView * scollVeiw;
@property(nonatomic,assign)NSInteger currentPage;
@property(nonatomic,strong)NSTimer * timer;

@property(nonatomic,weak)UIView * preView;
@property(nonatomic,weak)UIView * curView;
@property(nonatomic,weak)UIView * nextView;

@property(nonatomic,weak) UIPageControl * pagecontrol ;

@property(nonatomic,assign)BOOL isRegisterNib;
@property(nonatomic,strong)NSMutableDictionary * nibDictionary;

@property(nonatomic,strong)UITapGestureRecognizer * preTgr;
@property(nonatomic,strong)UITapGestureRecognizer * curTgr;
@property(nonatomic,strong)UITapGestureRecognizer * nextTgr;


@property(nonatomic,strong)NSMutableSet * usedPool;
@property(nonatomic,strong)NSMutableSet * reusefulPool;

@property(nonatomic,assign)BOOL isInScrolling;
@property(nonatomic,assign)BOOL isNeedContine;


@end


@implementation GGCMTView

#pragma mark - public Method


- (void)prepareScroll{
    [self loadCellData];
}

- (void)continueScroll{
    [self startScroll];
}
- (void)setData{
    [self loadCellData];
}

- (void)pauseScroll{
    [self stopScroll];
}

- (void)startScroll{
    
    if ([self.dataSource numberOfPageInCmtView:self] == 0) {
        return;
    }
    if (self.isInScrolling) {
        return;
    }
    NSLog(@"定时器开启了");
    [self setUpTimer];
}

- (void)stopScroll{
    [self destroyTimer];
}

- (void)registerNib:(UINib *)nib forCMTViewCellReuseIdentifier:(NSString *)identifier{
    
    self.isRegisterNib = YES;
    [self.nibDictionary setValue:nib forKey:identifier];
}

- (instancetype)initWithFrame:(CGRect)frame andCMTViewStyle:(CMTViewStyle)cmtViewStyle{
    if (self = [super initWithFrame:frame]) {
        _cmtViewStyle = cmtViewStyle;
        [self initAllService];
    }
    return self;
}

- (__kindof UITableViewCell *)dequeueReusableCMTViewCellWithIdentifier:(NSString *)identifier{
    UITableViewCell * resultCell = nil;
    
    for (UITableViewCell * cell  in self.reusefulPool) {
        
        if ([cell.reuseIdentifier isEqualToString:identifier]) {
            resultCell = cell;
            break;
        }
    }
    
    if (resultCell) {
        [self.reusefulPool removeObject:resultCell];
        return resultCell;
    }
    
    if (self.isRegisterNib) {
        UINib * nib = [self.nibDictionary valueForKey:identifier];
        resultCell = [[nib instantiateWithOwner:nil options:nil]lastObject];
        if(!resultCell.reuseIdentifier)
            [resultCell setValue:identifier forKey:@"reuseIdentifier"];
    }
    return resultCell;
}

- (void)setEnableUserScroll:(BOOL)enableUserScroll{
    self.scollVeiw.scrollEnabled = enableUserScroll;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //init
        [self initAllService];
    }
    return self;
}


#pragma mark - private Method

- (UITapGestureRecognizer *)preTgr{
    if (!_preTgr) {
        _preTgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didCellSelectedByDelegate)];
    }
    return _preTgr;
}

- (UITapGestureRecognizer *)curTgr{
    if (!_curTgr) {
        _curTgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didCellSelectedByDelegate)];
    }
    return _curTgr;
}

- (UITapGestureRecognizer *)nextTgr{
    if (!_nextTgr) {
        _nextTgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didCellSelectedByDelegate)];
    }
    return _nextTgr;
}

- (NSMutableDictionary *)nibDictionary{
    if (!_nibDictionary) {
        _nibDictionary = [NSMutableDictionary dictionary];
    }
    return _nibDictionary;
}

- (NSMutableSet *)reusefulPool{
    if (!_reusefulPool) {
        _reusefulPool = [NSMutableSet set];
    }
    return _reusefulPool;
}

- (NSMutableSet *)usedPool{
    if (!_usedPool) {
        _usedPool = [NSMutableSet set];
    }
    return _usedPool;
}

- (void)initAllService{
    [self createFocusScrollView];
    [self creatScrollViewContentView];
    [self setupScrollViewContentViewFrame];
    
    
}

- (void)createFocusScrollView
{
    UIScrollView * scrollView = [[UIScrollView alloc] init];
    scrollView.frame = CGRectMake(0, 0, self.width, self.height);
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    scrollView.scrollEnabled = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.userInteractionEnabled = YES;
    scrollView.delegate = self;
    [self addSubview:scrollView];
    self.scollVeiw = scrollView;
}

- (void)creatScrollViewContentView{
    UIView * preView = [[UIView alloc]init];
    [self.scollVeiw addSubview:preView];
    self.preView = preView;
    
    UIView * curView = [[UIView alloc]init];
    [self.scollVeiw addSubview:curView];
    self.curView = curView;
    
    UIView * nextView = [[UIView alloc]init];
    [self.scollVeiw addSubview:nextView];
    self.nextView = nextView;
    
}

- (void)setupScrollViewContentViewFrame{
    switch (self.cmtViewStyle) {
        case CMTViewHorizontalStyle:
            [self setupScrollViewHorizontalContentViewFrame];
            break;
        case CMTViewVerticalStyle:
            [self setupScrollViewVerticalContentViewFrame];
            break;
        default:
            break;
    }
}

- (void)setupScrollViewHorizontalContentViewFrame{
    self.scollVeiw.contentSize = CGSizeMake(self.width * SCROLLVIEWCONTENTSIZE, 0);
    self.preView.frame = CGRectMake(0, 0, self.width, self.height);
    self.curView.frame = CGRectMake(self.width, 0, self.width, self.height);
    self.nextView.frame = CGRectMake(self.width * 2, 0, self.width, self.height);
}

- (void)setupScrollViewVerticalContentViewFrame{
    self.scollVeiw.contentSize = CGSizeMake(0, self.height * SCROLLVIEWCONTENTSIZE);
    self.preView.frame = CGRectMake(0, 0, self.width, self.height);
    self.curView.frame = CGRectMake(0, self.height, self.width, self.height);
    self.nextView.frame = CGRectMake(0, self.height * 2, self.width, self.height);
    
}

- (void)setUpTimer
{
    if (self.timeInterval <= 0.5f) {
        self.timeInterval = 4.0f;
    }
    NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval target:self selector:@selector(timeTick) userInfo:nil repeats:YES];
    self.timer = timer;
    self.isInScrolling = YES;
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)loadCellData
{
//    NSLog(@"reusefulPool ============    %@",self.reusefulPool);
    if([self.dataSource numberOfPageInCmtView:self] <= 0){
        return;
    }
    [self.preView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.curView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.nextView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (_currentPage < 0 || _currentPage > [self.dataSource numberOfPageInCmtView:self]) {
        _currentPage = 0;
    }
    
    NSInteger preIndex = _currentPage-1;
    if (preIndex < 0) {
        preIndex = [self.dataSource numberOfPageInCmtView:self] - 1;
    }
    UITableViewCell * preCell = [self.dataSource cmtView:self cellForIndex:preIndex];
    preCell.frame = CGRectMake(0, 0, self.width, self.height);
    [self.preView addSubview:preCell];
    
    NSInteger curIndex = _currentPage;
    
    UITableViewCell * curCell = [self.dataSource cmtView:self cellForIndex:curIndex];
    [curCell.contentView addGestureRecognizer:self.curTgr];
    curCell.frame = CGRectMake(0, 0, self.width, self.height);
    [self.curView addSubview:curCell];
    
    
    NSInteger nextIndex = _currentPage + 1;
    if (nextIndex >= [self.dataSource numberOfPageInCmtView:self]) {
        nextIndex = 0;
    }
    UITableViewCell * nextCell = [self.dataSource cmtView:self cellForIndex:nextIndex];
    nextCell.frame = CGRectMake(0, 0, self.width, self.height);
    [self.nextView addSubview:nextCell];
    
    //把刚刚用的所有的cell回收到缓冲池
    [self.reusefulPool addObjectsFromArray:[self.usedPool allObjects]];
    //把正在使用的cell从使用区移除
    [self.usedPool removeAllObjects];
    //把当前正在使用的cell放入使用区
    [self.usedPool addObject:preCell];
    [self.usedPool addObject:curCell];
    [self.usedPool addObject:nextCell];
    
    switch (self.cmtViewStyle) {
        case CMTViewHorizontalStyle:
            [self.scollVeiw setContentOffset:CGPointMake(self.width, 0)];
            break;
        case CMTViewVerticalStyle:
            [self.scollVeiw setContentOffset:CGPointMake(0, self.height)];
            break;
        default:
            break;
    }
}

- (void)destroyTimer{
    self.isInScrolling = NO;
    [self.timer invalidate];
    self.timer = nil;
    NSLog(@"定时器干掉了");
}

- (void)timeTick
{
    if ([self.dataSource numberOfPageInCmtView:self] <= 0) {
        [self stopScroll];
    }
    [UIView animateWithDuration:0.5f animations:^{
        [self timeTickAnimationAction];
    } completion:^(BOOL finished) {
        if(finished){
            [self setClockwiseDragCurrentPage];
            [self loadCellData];
        }
    }];
}

- (void)timeTickAnimationAction{
    switch (self.cmtViewStyle) {
        case CMTViewHorizontalStyle:
            [self.scollVeiw setContentOffset:CGPointMake(self.width * 2, 0)];
            break;
        case CMTViewVerticalStyle:
            [self.scollVeiw setContentOffset:CGPointMake(0, self.height*2)];
            break;
        default:
            break;
    }
    
}

- (void)didCellSelectedByDelegate{
    if ([self.delegate respondsToSelector:@selector(cmtView:didSelectIndex:)]) {
        [self.delegate cmtView:self didSelectIndex:self.currentPage];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.isInScrolling) {
        self.isNeedContine = YES;
    }
    [self pauseScroll];
}



- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int index = 0;
    switch (self.cmtViewStyle) {
        case CMTViewHorizontalStyle:
            index = scrollView.contentOffset.x/self.width;
            break;
        case CMTViewVerticalStyle:
            index = scrollView.contentOffset.y/self.height;
            break;
        default:
            break;
    }
    if(index == 0)
        [self setCounterClockwiseDragCurrentPage];
    if(index == 2)
        [self setClockwiseDragCurrentPage];
    [self setData];
    if (self.isNeedContine) {
        self.isNeedContine = NO;
        [self setUpTimer];
    }
}

- (void)setClockwiseDragCurrentPage{
    _currentPage = _currentPage+1<[self.dataSource numberOfPageInCmtView:self]?_currentPage+1:0;
}

- (void)setCounterClockwiseDragCurrentPage{
    _currentPage = _currentPage-1<0?[self.dataSource numberOfPageInCmtView:self] - 1:_currentPage-1;
}



@end



