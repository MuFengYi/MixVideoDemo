//
//  ViewController.m
//  MixVideoDemo
//
//  Created by 易 彬锋 on 16/6/4.
//  Copyright © 2016年 bfy. All rights reserved.
//

#import "ViewController.h"
#import "MixVideoManager.h"
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>

#define VIDEOURL     [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"MixVideo" ofType:@"mp4"]]
#define AUDIOURL     [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"sample" ofType:@"mp3"]]
@interface ViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    
    UIImagePickerController *_imagePickerController;

}
@property (nonatomic,strong)    NSURL *videoUrl;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //视频合成 加label 水印 特效 加背景音乐
    
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    _imagePickerController.allowsEditing = YES;
    
}
- (IBAction)chooseVideo:(id)sender {
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"选择图片来源" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self selectImageFromCamera];
        
    }];
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self selectImageFromAlbum];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertVc addAction:cameraAction];
    [alertVc addAction:photoAction];
    [alertVc addAction:cancelAction];
    [self presentViewController:alertVc animated:YES completion:nil];
}


#pragma mark 从摄像头获取图片或视频
- (void)selectImageFromCamera
{
    //NSLog(@"相机");
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    //录制视频时长，默认10s
    _imagePickerController.videoMaximumDuration = 15;
    //相机类型（拍照、录像...）
    _imagePickerController.mediaTypes = @[(NSString *)kUTTypeMovie,(NSString *)kUTTypeImage];
    //视频上传质量
    _imagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
    //设置摄像头模式（拍照，录制视频）
    _imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
    [self presentViewController:_imagePickerController animated:YES completion:nil];
}

#pragma mark 从相册获取图片或视频
- (void)selectImageFromAlbum
{
    //NSLog(@"相册");
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:_imagePickerController animated:YES completion:nil];
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        
    }else{
        //如果是视频
        NSURL *url = info[UIImagePickerControllerMediaURL];
        //播放视频
        
           _videoUrl = url;
        //保存视频至相册（异步线程）
        NSString *urlStr = [url path];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(urlStr)) {
                
                UISaveVideoAtPathToSavedPhotosAlbum(urlStr, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
            }
        });
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 图片保存完毕的回调
- (void) image: (UIImage *) image didFinishSavingWithError:(NSError *) error contextInfo: (void *)contextIn {
    
}

#pragma mark 视频保存完毕的回调
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextIn {
    if (error) {
        NSLog(@"保存视频过程中发生错误，错误信息:%@",error.localizedDescription);
    }else{
        NSLog(@"视频保存成功.");
    }
}

- (IBAction)MixedAction:(UIButton*)sender {
    
    if (!_videoUrl) {
        
        _videoUrl   =   VIDEOURL;
    }
    
    __weak typeof(self) weakSelf    = self;
    switch (sender.tag) {
        case 0:
        {
            [[MixVideoManager ShareManager] mixedVideo:_videoUrl withMediaUrl:AUDIOURL  videoRang:NSMakeRange(0, 10) mixType:MixAudio completeBlock:^(NSURL *url){
                
                weakSelf.videoUrl   =   url;
                NSLog(@"给视频添加音乐完成");

               
            }];
            
        }
             break;
        case 1:
        {
            [[MixVideoManager ShareManager] mixedVideo:_videoUrl withMediaUrl:AUDIOURL  videoRang:NSMakeRange(0, 10) mixType:MixText completeBlock:^(NSURL *url){
                
                weakSelf.videoUrl   =   url;
                NSLog(@"给视频添加文本完成");
                
            }];
        }
            break;
        case 2:{
            [[MixVideoManager ShareManager] mixedVideo:_videoUrl withMediaUrl:AUDIOURL videoRang:NSMakeRange(0,10) mixType:MixAnimation completeBlock:^(NSURL *url){
                weakSelf.videoUrl   =   url;
                NSLog(@"给视频添加特效完成");
            }];
        }
            break;
        case 3:{
            [[MixVideoManager ShareManager] mixedVideo:_videoUrl withMediaUrl:AUDIOURL videoRang:NSMakeRange(0,10) mixType:MixBorder completeBlock:^(NSURL *url){
                weakSelf.videoUrl   =   url;
                NSLog(@"给视频添加边框完成");
            }];
        }
            break;
        default:
            break;
    }

}
@end
