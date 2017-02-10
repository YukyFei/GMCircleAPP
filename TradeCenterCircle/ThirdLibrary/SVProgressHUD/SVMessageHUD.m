//
//  SVMessageHUD.m
//  CompanyFactory
//
//  Created by 91aiche on 14-5-28.
//  Copyright (c) 2014年 AmorYin. All rights reserved.
//

#import "SVMessageHUD.h"
#import <QuartzCore/QuartzCore.h>

@interface SVMessageHUD ()

@property (nonatomic, readwrite) SVMessageHUDMaskType maskType;
@property (nonatomic, strong) NSTimer *fadeOutTimer;
@property (nonatomic, strong) UILabel *stringLabel;
@property (nonatomic, strong) UIImageView *imageView;

- (void)showInView:(UIView*)view status:(NSString*)string afterDelay:(NSTimeInterval)seconds posY:(CGFloat)posY maskType:(SVMessageHUDMaskType)hudMaskType;
- (void)setStatus:(NSString*)string;

- (void)dismiss;
- (void)dismissWithStatus:(NSString*)string error:(BOOL)error;
- (void)dismissWithStatus:(NSString*)string error:(BOOL)error afterDelay:(NSTimeInterval)seconds;

- (void)memoryWarning:(NSNotification*)notification;

@end


@implementation SVMessageHUD

@synthesize maskType, fadeOutTimer, stringLabel, imageView;

static SVMessageHUD *sharedView = nil;

+ (SVMessageHUD*)sharedView {
	if(sharedView == nil)
		sharedView = [[SVMessageHUD alloc] initWithFrame:CGRectZero];
	
	return sharedView;
}

+ (void)setStatus:(NSString *)string {
	[[SVMessageHUD sharedView] setStatus:string];
}


#pragma mark - Show Methods

+ (void)show {
	[SVMessageHUD showInView:nil status:nil];
}


+ (void)showInView:(UIView*)view {
	[SVMessageHUD showInView:view status:nil];
}


+ (void)showInView:(UIView*)view status:(NSString*)string {
	[SVMessageHUD showInView:view status:string afterDelay:-1];
}


+ (void)showInView:(UIView*)view status:(NSString*)string afterDelay:(NSTimeInterval)seconds {
	[SVMessageHUD showInView:view status:string afterDelay:seconds posY:-1];
}

+ (void)showInView:(UIView*)view status:(NSString*)string afterDelay:(NSTimeInterval)seconds posY:(CGFloat)posY {
    [SVMessageHUD showInView:view status:string afterDelay:seconds posY:posY maskType:SVMessageHUDMaskTypeNone];
}


+ (void)showInView:(UIView*)view status:(NSString*)string afterDelay:(NSTimeInterval)seconds posY:(CGFloat)posY maskType:(SVMessageHUDMaskType)hudMaskType {
	
    BOOL addingToWindow = NO;
    
    if(!view) {
        //UIWindow* keyWindow = [UIApplication sharedApplication].keyWindow;
        NSArray *windows = [[UIApplication sharedApplication] windows];
		UIWindow* keyWindow = [windows objectAtIndex:[windows count]-1];
        
        addingToWindow = YES;
        
        if ([keyWindow respondsToSelector:@selector(rootViewController)]) {
            //Use the rootViewController to reflect the device orientation
            view = keyWindow.rootViewController.view;
        }
        
        if(view == nil)
            view = keyWindow;
    }
	if(posY == -1) {
		posY = floor(CGRectGetHeight(view.bounds)/2);
        
        if(addingToWindow)
            posY -= floor(CGRectGetHeight(view.bounds)/18); // move slightly towards the top
    }
    
	[[SVMessageHUD sharedView] showInView:view status:string afterDelay:seconds posY:posY maskType:hudMaskType];
}


#pragma mark - Dismiss Methods

+ (void)dismiss {
	[[SVMessageHUD sharedView] dismiss];
}

+ (void)dismissWithSuccess:(NSString*)successString {
	[[SVMessageHUD sharedView] dismissWithStatus:successString error:NO];
}

+ (void)dismissWithSuccess:(NSString *)successString afterDelay:(NSTimeInterval)seconds {
    [[SVMessageHUD sharedView] dismissWithStatus:successString error:NO afterDelay:seconds];
}

+ (void)dismissWithError:(NSString*)errorString {
	[[SVMessageHUD sharedView] dismissWithStatus:errorString error:YES];
}

+ (void)dismissWithError:(NSString *)errorString afterDelay:(NSTimeInterval)seconds {
    [[SVMessageHUD sharedView] dismissWithStatus:errorString error:YES afterDelay:seconds];
}


#pragma mark - Instance Methods

- (void)dealloc {
	
	if(self.fadeOutTimer != nil)
		[self.fadeOutTimer invalidate], self.fadeOutTimer = nil;
	
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithFrame:(CGRect)frame {
	
    if ((self = [super initWithFrame:frame])) {
        
		self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor clearColor];
		self.alpha = 0;
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(memoryWarning:)
                                                     name:UIApplicationDidReceiveMemoryWarningNotification
                                                   object:nil];
        
        _hudView = [[UIView alloc] initWithFrame:CGRectZero];
        _hudView.layer.cornerRadius = 10;
		_hudView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        _hudView.autoresizingMask = (UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin |
                                     UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin);
        
        [self addSubview:_hudView];
    }
	
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    switch (self.maskType) {
            
        case SVMessageHUDMaskTypeBlack: {
            [[UIColor colorWithWhite:0 alpha:0.5] set];
            CGContextFillRect(context, self.bounds);
            break;
        }
            
        case SVMessageHUDMaskTypeGradient: {
            
            size_t locationsCount = 2;
            CGFloat locations[2] = {0.0f, 1.0f};
            CGFloat colors[8] = {0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.75f};
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, locations, locationsCount);
            CGColorSpaceRelease(colorSpace);
            
            CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
            float radius = MIN(self.bounds.size.width , self.bounds.size.height) ;
            CGContextDrawRadialGradient (context, gradient, center, 0, center, radius, kCGGradientDrawsAfterEndLocation);
            CGGradientRelease(gradient);
            
            break;
        }
    }
}

- (void)setStatus:(NSString *)string {
	
    CGFloat hudWidth = 100;
    
	CGFloat stringWidth = [string sizeWithFont:self.stringLabel.font].width+28;
	
	if(stringWidth > hudWidth)
		hudWidth = ceil(stringWidth/2)*2;
	
	_hudView.bounds = CGRectMake(0, 0, hudWidth, 100);
	
	self.imageView.center = CGPointMake(CGRectGetWidth(_hudView.bounds)/2, 30);
	
	self.stringLabel.hidden = NO;
	self.stringLabel.text = string;
	self.stringLabel.frame = CGRectMake(0, 46, CGRectGetWidth(_hudView.bounds)-60, 40);
	
	if(self.imageView.hidden)
		self.stringLabel.center = CGPointMake(ceil(CGRectGetWidth(_hudView.bounds)/2)+0.5, ceil(_hudView.bounds.size.height/2)+0.5);
    else
        self.stringLabel.center = CGPointMake(ceil(CGRectGetWidth(_hudView.bounds)/2)+0.5, ceil(_hudView.bounds.size.height)-30+0.5);
}


- (void)showInView:(UIView*)view status:(NSString*)string afterDelay:(NSTimeInterval)seconds posY:(CGFloat)posY maskType:(SVMessageHUDMaskType)hudMaskType {
	
	if(self.fadeOutTimer != nil)
		[self.fadeOutTimer invalidate], self.fadeOutTimer = nil;
	
	if(seconds!=-1)
		self.fadeOutTimer = [NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:@selector(dismiss) userInfo:nil repeats:NO];
	
	self.imageView.hidden = YES;
    self.maskType = hudMaskType;
	
	[self setStatus:string];
    
    if(self.maskType != SVMessageHUDMaskTypeNone)
        self.userInteractionEnabled = YES;
    else
        self.userInteractionEnabled = NO;
    
	if(![sharedView isDescendantOfView:view]) {
		self.alpha = 0;
		[view addSubview:sharedView];
	}
    
    self.frame = [UIApplication sharedApplication].keyWindow.frame;
	
	if(sharedView.layer.opacity != 1) {
		
        _hudView.center = CGPointMake(CGRectGetWidth(self.superview.bounds)/2, posY-40);
		_hudView.layer.transform = CATransform3DScale(CATransform3DMakeTranslation(0, 0, 0), 1.3, 1.3, 1);
		
		[UIView animateWithDuration:0.15
							  delay:0
							options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut
						 animations:^{
							 _hudView.layer.transform = CATransform3DScale(CATransform3DMakeTranslation(0, 0, 0), 1, 1, 1);
                             self.alpha = 1;
						 }
						 completion:NULL];
	}
    
    [self setNeedsDisplay];
}


- (void)dismiss {
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	[UIView animateWithDuration:0.15
						  delay:0
						options:UIViewAnimationCurveEaseIn | UIViewAnimationOptionAllowUserInteraction
					 animations:^{
						 _hudView.layer.transform = CATransform3DScale(CATransform3DMakeTranslation(0, 0, 0), 0.8, 0.8, 1.0);
						 self.alpha = 0;
					 }
					 completion:^(BOOL finished){
                         if(self.alpha == 0) {
                             [self removeFromSuperview];
                         }
                     }];
}


- (void)dismissWithStatus:(NSString*)string error:(BOOL)error {
	[self dismissWithStatus:string error:error afterDelay:1.0];
}


- (void)dismissWithStatus:(NSString *)string error:(BOOL)error afterDelay:(NSTimeInterval)seconds {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	if(error)
		self.imageView.image = [UIImage imageNamed:@"SVProgressHUD.bundle/error.png"];
	else
		self.imageView.image = [UIImage imageNamed:@"SVProgressHUD.bundle/success.png"];
	
	self.imageView.hidden = NO;
	
	[self setStatus:string];
    
    if(self.fadeOutTimer != nil)
        [self.fadeOutTimer invalidate], self.fadeOutTimer = nil;
	
	self.fadeOutTimer = [NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:@selector(dismiss) userInfo:nil repeats:NO];
}

#pragma mark - Getters

- (UILabel *)stringLabel {
    
    if (stringLabel == nil) {
        stringLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		stringLabel.textColor = [UIColor whiteColor];
		stringLabel.backgroundColor = [UIColor clearColor];
		stringLabel.adjustsFontSizeToFitWidth = YES;
        stringLabel.numberOfLines = 0;
		stringLabel.textAlignment = NSTextAlignmentCenter;
		stringLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
		stringLabel.font = [UIFont boldSystemFontOfSize:16];
		stringLabel.shadowColor = [UIColor blackColor];
		stringLabel.shadowOffset = CGSizeMake(0, -1);
		[_hudView addSubview:stringLabel];
    }
    
    return stringLabel;
}

- (UIImageView *)imageView {
    
    if (imageView == nil) {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
		[_hudView addSubview:imageView];
    }
    
    return imageView;
}

#pragma mark - MemoryWarning

- (void)memoryWarning:(NSNotification *)notification {
	
    if (sharedView.superview == nil) {
        [sharedView removeFromSuperview];
        sharedView = nil;
    }
}

@end
