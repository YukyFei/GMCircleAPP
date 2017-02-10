//
//  FlowerHeaderBtnView.m
//  TradeCenterCircle
//
//  Created by 李阳 on 16/8/15.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "FlowerHeaderBtnView.h"
#import "FlowerCollectionViewCell.h"


CGFloat cellWidth,cellHei,cellfont ;

@interface FlowerHeaderBtnView ()<
UICollectionViewDataSource,
UICollectionViewDelegate
>


@end

@implementation FlowerHeaderBtnView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        [self initial];
        self.backgroundColor = [UIColor whiteColor] ;
    }
    return self;
}
- (void)initial {
    self.delegate = self;
    self.dataSource = self;
    
    //注册自定义cell      与下面标志一致
    //
    [self registerClass:[FlowerCollectionViewCell  class] forCellWithReuseIdentifier:@"FlowerCell"] ;
    if (SCREENWIDTH == 320) {
        cellWidth = 80 ;
        cellHei = 30 ;
        cellfont = 15 ;
    }else if (SCREENWIDTH == 375){
        cellfont = 16 ;
        cellHei = 30 ;
        cellWidth = 80 ;
    }else if (SCREENWIDTH >375){
        
        cellWidth = 100 ;
        cellHei = 35 ;
        cellfont = 17 ;
    }
}

//2.每组返回多少Item
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataShops.count ;
}
//3.返回网格视图
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    FlowerCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FlowerCell" forIndexPath:indexPath] ;
    cell.headerBtnLab.text = [self.dataShops[indexPath.row] valueForKey:@"Cat_name"];
    cell.headerBtnLab.font = [UIFont systemFontOfSize:cellfont] ;
    cell.layer.borderColor = [UIColor colorWithHexString:@"#`"].CGColor ;
    cell.layer.borderWidth = 1.0f ;
    cell.tag = indexPath.row+100 ;
    if (indexPath.row ==0) {
        cell.headerBtnLab.textColor = [UIColor colorWithHexString:@"a6873b"] ;
    }
    return cell ;
    
}

//1.设置每个Item的大小,默认是50*50
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return  CGSizeMake(cellWidth ,VIEW_H(self)) ;
    
}
////设置每个分组距上下左右的距离
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{  //距上左下右的距离
    CGFloat X = (SCREENWIDTH - self.dataShops.count * cellWidth)/2/self.dataShops.count ;
    return UIEdgeInsetsMake(0, X, 0, X) ;
}
//设置行间距
- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    CGFloat X = (SCREENWIDTH - self.dataShops.count * cellWidth)/2/self.dataShops.count ;
    return  2*X ;
}


#pragma  -mark 协议方法
//点击跳转的协议方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    for (FlowerCollectionViewCell * cell in self.subviews) {
    //
    //        FlowerCollectionViewCell * cell = [self viewWithTag:self.dataShops]
    //        if (cell.tag == indexPath.row+100) {
    //           cell.headerBtnLab.textColor = [UIColor colorWithHexString:@"a6873b"] ;
    //        }else{
    //
    //        }
    //    }
    
    for (int i=0; i<self.dataShops.count; i++) {
        FlowerCollectionViewCell * cell = (FlowerCollectionViewCell *)[self viewWithTag:100+i] ;
        if (cell.tag == indexPath.row+100) {
            cell.headerBtnLab.textColor = [UIColor colorWithHexString:@"a6873b"] ;
        }else{
            cell.headerBtnLab.textColor = [UIColor colorWithHexString:@"#666666"] ;
        }
    }
    
    
    [_flowerDelegate flowerView:self didIndexCellClick:indexPath.row] ;
    
}


- (void)setDataShops:(NSMutableArray *)dataShops {
    [self reloadData];
    
    if (dataShops.count ==0) {
        [_dataShops removeAllObjects];
    }
    _dataShops = dataShops;
    
    [self reloadData];
}




@end
