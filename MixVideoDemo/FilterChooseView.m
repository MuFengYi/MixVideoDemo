//
//  FilterChooseView.m
//  GPU-Video-Edit
//
//  Created by xiaoke_mh on 16/4/13.
//  Copyright © 2016年 m-h. All rights reserved.
//

#import "FilterChooseView.h"
#import "FilterArray.h"
@interface FilterChooseView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
}
@property(nonatomic,strong)UICollectionView * collectionview;
@property(nonatomic,copy)NSArray * filterArr;
@end

@implementation FilterChooseView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _filterArr = [FilterArray creatFilterArray];
        [self addSubview:self.collectionview];
    }
    return self;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _filterArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FilterChooseCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
//    NSLog(@"%ld",(long)indexPath.row);
    cell.nameLab.text = [_filterArr[indexPath.row] objectForKey:@"name"];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_backback) {
        GPUImageOutput<GPUImageInput> * pixellateFilter = (GPUImageOutput<GPUImageInput> *)[_filterArr[indexPath.row] objectForKey:@"filter"];
        _backback(pixellateFilter);
    }
//    [collectionView reloadItemsAtIndexPaths:@[indexPath]];
//    NSLog(@"dian");
}
-(UICollectionView *)collectionview
{
    if (!_collectionview) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setItemSize:CGSizeMake(80, self.bounds.size.height)];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal]; //控制滑动分页用
        flowLayout.minimumInteritemSpacing =0;
        
        _collectionview = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        _collectionview.bounces = NO;
        _collectionview.showsHorizontalScrollIndicator = NO;
        [_collectionview registerClass:[FilterChooseCell class] forCellWithReuseIdentifier:@"cellid"];
        _collectionview.backgroundColor = [UIColor clearColor];
        
        _collectionview.delegate = self;
        _collectionview.dataSource = self;
        _collectionview.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        _collectionview.autoresizesSubviews = YES;
    }
    return _collectionview;
}
@end








@interface FilterChooseCell ()

@end
@implementation FilterChooseCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        _iconImg.clipsToBounds = YES;
        _iconImg.backgroundColor = [UIColor redColor];
        _iconImg.layer.cornerRadius = 40;
        _iconImg.layer.masksToBounds = YES;
        [self.contentView addSubview:_iconImg];
        
        _nameLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, 80, 15)];
        _nameLab.backgroundColor = [UIColor orangeColor];
        _nameLab.text = @"plplplp";
        _nameLab.textColor = [UIColor whiteColor];
        _nameLab.textAlignment = NSTextAlignmentCenter;
        _nameLab.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_nameLab];
    }
    return self;
}


@end

