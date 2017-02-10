//
//  FlowerCollectionViewCell.m
//  TradeCenterCircle
//
//  Created by 李阳 on 16/8/15.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "FlowerCollectionViewCell.h"

@implementation FlowerCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}



- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"FlowerCollectionViewCell" owner:self options:nil].lastObject;
    }
    
    return self;
}

@end
