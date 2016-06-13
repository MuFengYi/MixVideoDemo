//
//  MixVideoManager.m
//  MixVideoDemo
//
//  Created by 易 彬锋 on 16/6/4.
//  Copyright © 2016年 bfy. All rights reserved.
//

#import "MixVideoManager.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#define MIXEDVIDEONAME @"MixedVideo.mov"

@implementation MixVideoManager
+ (MixVideoManager*)ShareManager
{
    static    MixVideoManager *mixVideoManager    =   nil;
    static    dispatch_once_t   once_t;
    dispatch_once(&once_t, ^{
        mixVideoManager =   [[MixVideoManager alloc]init];
    });
    return mixVideoManager;
}

- (void)mixedVideo:(NSURL*)videoUrl withMediaUrl:(NSURL*)mediaUrl videoRang:(NSRange)videoRange mixType:(Mixtype)type completeBlock:(MixVideoCompleteBlock)completeblock
{
    //AVURLAsset此类主要用于获取媒体信息，包括视频、声音等
    AVURLAsset* audioAsset = [[AVURLAsset alloc] initWithURL:mediaUrl options:nil];
    AVURLAsset* videoAsset = [[AVURLAsset alloc] initWithURL:videoUrl options:nil];
    
    //创建AVMutableComposition对象来添加视频音频资源的AVMutableCompositionTrack
    AVMutableComposition* mixComposition = [AVMutableComposition composition];
    
    //CMTimeRangeMake(start, duration),start起始时间，duration时长，都是CMTime类型
    //CMTimeMake(int64_t value, int32_t timescale)，返回CMTime，value视频的一个总帧数，timescale是指每秒视频播放的帧数，视频播放速率，（value / timescale）才是视频实际的秒数时长，timescale一般情况下不改变，截取视频长度通过改变value的值
    //CMTimeMakeWithSeconds(Float64 seconds, int32_t preferredTimeScale)，返回CMTime，seconds截取时长（单位秒），preferredTimeScale每秒帧数
    
    //开始位置startTime
    CMTime startTime = CMTimeMakeWithSeconds(videoRange.location, videoAsset.duration.timescale);
    //截取长度videoDuration
    CMTime videoDuration = CMTimeMakeWithSeconds(videoRange.length, videoAsset.duration.timescale);
    
    CMTimeRange videoTimeRange = CMTimeRangeMake(startTime, videoDuration);
    
    //视频采集compositionVideoTrack
    AVMutableCompositionTrack *compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    #warning 避免数组越界 tracksWithMediaType 找不到对应的文件时候返回空数组
    //TimeRange截取的范围长度
    //ofTrack来源
    //atTime插放在视频的时间位置
    [compositionVideoTrack insertTimeRange:videoTimeRange ofTrack:([videoAsset tracksWithMediaType:AVMediaTypeVideo].count>0) ? [videoAsset tracksWithMediaType:AVMediaTypeVideo].firstObject : nil atTime:kCMTimeZero error:nil];
    

     //视频声音采集(也可不执行这段代码不采集视频音轨，合并后的视频文件将没有视频原来的声音)
     
     AVMutableCompositionTrack *compositionVoiceTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
     
     [compositionVoiceTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration) ofTrack:([videoAsset tracksWithMediaType:AVMediaTypeAudio].count>0)?[videoAsset tracksWithMediaType:AVMediaTypeAudio].firstObject:nil atTime:kCMTimeZero error:nil];
    
    
    AVMutableVideoComposition *mainCompositionInst;
    if (type==MixAudio) {
        //声音长度截取范围==视频长度
        CMTimeRange audioTimeRange = CMTimeRangeMake(kCMTimeZero, videoDuration);
        //音频采集compositionCommentaryTrack
        AVMutableCompositionTrack *compositionAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        
        [compositionAudioTrack insertTimeRange:audioTimeRange ofTrack:([audioAsset tracksWithMediaType:AVMediaTypeAudio].count > 0) ? [audioAsset tracksWithMediaType:AVMediaTypeAudio].firstObject : nil atTime:kCMTimeZero error:nil];
    }else {
        
        //添加除音乐的其他效果
        // 3.1 - Create AVMutableVideoCompositionInstruction
        AVMutableVideoCompositionInstruction *mainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        mainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, videoAsset.duration);
        
        // 3.2 - Create an AVMutableVideoCompositionLayerInstruction for the video track and fix the orientation.
        AVMutableVideoCompositionLayerInstruction *videolayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:compositionVideoTrack];
        AVAssetTrack *videoAssetTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
        
        UIImageOrientation videoAssetOrientation_  = UIImageOrientationUp;
        BOOL isVideoAssetPortrait_  = NO;
        CGAffineTransform videoTransform = videoAssetTrack.preferredTransform;
        if (videoTransform.a == 0 && videoTransform.b == 1.0 && videoTransform.c == -1.0 && videoTransform.d == 0) {
            videoAssetOrientation_ = UIImageOrientationRight;
            isVideoAssetPortrait_ = YES;
        }
        if (videoTransform.a == 0 && videoTransform.b == -1.0 && videoTransform.c == 1.0 && videoTransform.d == 0) {
            videoAssetOrientation_ =  UIImageOrientationLeft;
            isVideoAssetPortrait_ = YES;
        }
        if (videoTransform.a == 1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == 1.0) {
            videoAssetOrientation_ =  UIImageOrientationUp;
        }
        if (videoTransform.a == -1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == -1.0) {
            videoAssetOrientation_ = UIImageOrientationDown;
        }
        
        [videolayerInstruction setTransform:videoAssetTrack.preferredTransform atTime:kCMTimeZero];
        [videolayerInstruction setOpacity:0.0 atTime:videoAsset.duration];
        
        // 3.3 - Add instructions
        mainInstruction.layerInstructions = [NSArray arrayWithObjects:videolayerInstruction,nil];
        
       mainCompositionInst = [AVMutableVideoComposition videoComposition];
        
        CGSize naturalSize;
        if(isVideoAssetPortrait_){
            naturalSize = CGSizeMake(videoAssetTrack.naturalSize.height, videoAssetTrack.naturalSize.width);
        } else {
            naturalSize = videoAssetTrack.naturalSize;
        }
        
        float renderWidth, renderHeight;
        renderWidth = naturalSize.width;
        renderHeight = naturalSize.height;
        mainCompositionInst.renderSize = CGSizeMake(renderWidth, renderHeight);
        mainCompositionInst.instructions = [NSArray arrayWithObject:mainInstruction];
        mainCompositionInst.frameDuration = CMTimeMake(1, 30);
        
        if (type==MixText) {
            // 1 - Set up the text layer
            CATextLayer *subtitle1Text = [[CATextLayer alloc] init];
            [subtitle1Text setFont:@"Helvetica-Bold"];
            [subtitle1Text setFontSize:36];
            [subtitle1Text setFrame:CGRectMake(0, 0, naturalSize.width, 100)];
            [subtitle1Text setString:@"MuFeng..........."];
            [subtitle1Text setAlignmentMode:kCAAlignmentCenter];
            [subtitle1Text setForegroundColor:[[UIColor whiteColor] CGColor]];
            
            // 2 - The usual overlay
            CALayer *overlayLayer = [CALayer layer];
            [overlayLayer addSublayer:subtitle1Text];
            overlayLayer.frame = CGRectMake(0, 0, naturalSize.width, naturalSize.height);
            [overlayLayer setMasksToBounds:YES];
            
            
            CALayer *parentLayer = [CALayer layer];
            CALayer *videoLayer = [CALayer layer];
            parentLayer.frame = CGRectMake(0, 0, naturalSize.width, naturalSize.height);
            videoLayer.frame = CGRectMake(0, 0, naturalSize.width, naturalSize.height);
            [parentLayer addSublayer:videoLayer];
            [parentLayer addSublayer:overlayLayer];
            
            mainCompositionInst.animationTool = [AVVideoCompositionCoreAnimationTool
                                                 videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
            
            
        }else if (type==MixAnimation)
        {
            // 1
            UIImage *animationImage = [UIImage imageNamed:@"start.png"];;
            CALayer *overlayLayer1 = [CALayer layer];
            [overlayLayer1 setContents:(id)[animationImage CGImage]];
            overlayLayer1.frame = CGRectMake(naturalSize.width/2-64, naturalSize.height/2 + 200, 128, 128);
            [overlayLayer1 setMasksToBounds:YES];
            
            CALayer *overlayLayer2 = [CALayer layer];
            [overlayLayer2 setContents:(id)[animationImage CGImage]];
            overlayLayer2.frame = CGRectMake(naturalSize.width/2-64, naturalSize.height/2 - 200, 128, 128);
            [overlayLayer2 setMasksToBounds:YES];
            
            // 2 - Rotate
           
            CABasicAnimation *animation =
            [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
            animation.duration=2.0;
            animation.repeatCount=5;
            animation.autoreverses=YES;
            // rotate from 0 to 360
            animation.fromValue=[NSNumber numberWithFloat:0.0];
            animation.toValue=[NSNumber numberWithFloat:(2.0 * M_PI)];
            animation.beginTime = AVCoreAnimationBeginTimeAtZero;
            [overlayLayer1 addAnimation:animation forKey:@"rotation"];
            
            animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
            animation.duration=2.0;
            animation.repeatCount=5;
            animation.autoreverses=YES;
            // rotate from 0 to 360
            animation.fromValue=[NSNumber numberWithFloat:0.0];
            animation.toValue=[NSNumber numberWithFloat:(2.0 * M_PI)];
            animation.beginTime = AVCoreAnimationBeginTimeAtZero;
            [overlayLayer2 addAnimation:animation forKey:@"rotation"];
            
            
            
            // 5
            CALayer *parentLayer = [CALayer layer];
            CALayer *videoLayer = [CALayer layer];
            parentLayer.frame = CGRectMake(0, 0, naturalSize.width, naturalSize.height);
            videoLayer.frame = CGRectMake(0, 0, naturalSize.width, naturalSize.height);
            [parentLayer addSublayer:videoLayer];
//            [parentLayer addSublayer:overlayLayer1];
            [parentLayer addSublayer:overlayLayer2];
            
            mainCompositionInst.animationTool = [AVVideoCompositionCoreAnimationTool
                                         videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
            
        }else if(type==MixBorder){
            
            UIImage *borderImage  =   [self imageWithCorlor:[UIColor blueColor] withSize:CGRectMake(0, 0, naturalSize.width, naturalSize.height)];
            CALayer *backgroundLayer = [CALayer layer];
            [backgroundLayer setContents:(id)[borderImage CGImage]];
            backgroundLayer.frame = CGRectMake(0, 0, naturalSize.width, naturalSize.height);
            [backgroundLayer setMasksToBounds:YES];
            
            CALayer *videoLayer = [CALayer layer];
            videoLayer.frame = CGRectMake(5, 5,
                                          naturalSize.width-10, naturalSize.height-10);
            CALayer *parentLayer = [CALayer layer];
            parentLayer.frame = CGRectMake(0, 0, naturalSize.width, naturalSize.height);
            [parentLayer addSublayer:backgroundLayer];
            [parentLayer addSublayer:videoLayer];
            
            mainCompositionInst.animationTool = [AVVideoCompositionCoreAnimationTool
                                         videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
            
            
            
        }

        
       
    }
    
    //AVAssetExportSession用于合并文件，导出合并后文件，presetName文件的输出类型
    AVAssetExportSession *assetExportSession = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
    
    NSString *outPutPath = [NSTemporaryDirectory() stringByAppendingPathComponent:MIXEDVIDEONAME];
    //混合后的视频输出路径
    NSURL *outPutUrl = [NSURL fileURLWithPath:outPutPath];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:outPutPath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:outPutPath error:nil];
    }
    
  
    
    if (type!=MixAudio) {
        
        assetExportSession.videoComposition =   mainCompositionInst;
    }
    
    //输出视频格式 AVFileTypeMPEG4 AVFileTypeQuickTimeMovie...
    assetExportSession.outputFileType = AVFileTypeQuickTimeMovie;
    //    NSArray *fileTypes = assetExportSession.
    
    assetExportSession.outputURL = outPutUrl;
    //输出文件是否网络优化
    assetExportSession.shouldOptimizeForNetworkUse = YES;
    
    
    [assetExportSession exportAsynchronouslyWithCompletionHandler:^{
        
        switch (assetExportSession.status) {
            case AVAssetExportSessionStatusCompleted:
                
                completeblock(outPutUrl);
                
                [self writeVideoToPhotoLibrary:[NSURL fileURLWithPath:outPutPath]];
                
                break;
            case AVAssetExportSessionStatusFailed:
                NSLog(@"Failed:%@",assetExportSession.error);
                break;
            case AVAssetExportSessionStatusCancelled:
                NSLog(@"Canceled:%@",assetExportSession.error);
                break;
            default:
                break;
        }
    }];
    
}

- (void)animationRippleEffect:(CALayer *)view
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:10.f];
    [animation setFillMode:kCAFillModeForwards];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [animation setType:@"rippleEffect"];
    [view addAnimation:animation forKey:nil];
}

-(UIImage*)imageWithCorlor:(UIColor*)color withSize:(CGRect)size{
    
    UIGraphicsBeginImageContextWithOptions(size.size, NO, 0);
    [color setFill];
    UIRectFill(size);
    UIImage *image  =   UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  image;
}

-(void)writeVideoToPhotoLibrary:(NSURL*)url{
    
    ALAssetsLibrary *libary =   [[ALAssetsLibrary alloc]init];
    
    [libary writeVideoAtPathToSavedPhotosAlbum:url completionBlock:^(NSURL *assetUrl,NSError *error){
        if (error) {
            NSLog(@"error=%@",error);

        }
    }];
    
}



@end
