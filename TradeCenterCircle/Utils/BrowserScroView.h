//
//  BrowserScroView.h
//  weGame
//
//  Created by zy-iOS on 14/11/20.
//  Copyright (c) 2014年 BlueRain. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BrowserScroView;
@protocol BrowserScroViewDelegate <NSObject>
@optional
-(void)browserScroView:(BrowserScroView *)scroView isSelected:(BOOL)isSelected tag:(NSInteger)tag;
-(void)browserScroView:(BrowserScroView *)scroView didSend:(NSArray *)arr;

@end

@interface BrowserScroView : UIView
@property (nonatomic,strong) NSMutableArray *arrs;
@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,assign) BOOL showLimit;
@property (nonatomic,strong) NSMutableArray *selectedTag;
@property (nonatomic,assign) NSInteger maxNumberOfSelected;
@property (nonatomic,weak) id<BrowserScroViewDelegate> delegate;

-(void)show;
@end
