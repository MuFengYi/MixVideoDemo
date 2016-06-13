//
//  FilterChooseView.h
//  GPU-Video-Edit
//
//  Created by xiaoke_mh on 16/4/13.
//  Copyright © 2016年 m-h. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPUImage.h"

typedef void(^callBackFilter)(GPUImageOutput<GPUImageInput> * filter);

@interface FilterChooseView : UIView

@property(nonatomic,copy) callBackFilter backback;


@end




@interface FilterChooseCell : UICollectionViewCell
@property(nonatomic,strong)UIImageView * iconImg;
@property(nonatomic,strong)UILabel * nameLab;
@end