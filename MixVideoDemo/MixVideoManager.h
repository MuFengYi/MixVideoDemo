//
//  MixVideoManager.h
//  MixVideoDemo
//
//  Created by 易 彬锋 on 16/6/4.
//  Copyright © 2016年 bfy. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger , Mixtype){
    MixAudio,
    MixText,
    MixAnimation,
    MixBorder,
};


/**
 * 定义视频合成晚完成回调
 */
typedef void (^MixVideoCompleteBlock)(NSURL *url);

@interface MixVideoManager : NSObject

/**
 * @brief 单列模式
 */
+ (MixVideoManager*)ShareManager;

/**
 * @brief 视频编辑处理方法
 *
 * @param videoUrl 视频绝对路径
 * @param mediaUrl 音频绝对路径
 * @param videoRange 编辑视频范围
 * @param type 实现的编辑效果
 * @param completeblock 编辑完成的回调
 */
- (void)mixedVideo:(NSURL*)videoUrl withMediaUrl:(NSURL*)mediaUrl videoRang:(NSRange)videoRange mixType:(Mixtype)type completeBlock:(MixVideoCompleteBlock)completeblock;


@end
