//
//  FilterArray.m
//  GPU-Video-Edit
//
//  Created by xiaoke_mh on 16/4/14.
//  Copyright © 2016年 m-h. All rights reserved.
//

#import "FilterArray.h"

@implementation FilterArray
+(NSArray *)creatFilterArray{
    NSMutableArray * arr = [NSMutableArray arrayWithCapacity:0];
    
//    GPUImageOutput<GPUImageInput> * Filter1 = [[GPUImageBrightnessFilter alloc] init];
//    [(GPUImageBrightnessFilter *)Filter1 setBrightness:0.5];
//    NSString * title1 = @"亮度";
//    NSDictionary * dic1 = [NSDictionary dictionaryWithObjectsAndKeys:Filter1,@"filter",title1,@"name", nil];
//    [arr addObject:dic1];
    
//    GPUImageOutput<GPUImageInput> * Filter2 = [[GPUImageExposureFilter alloc] init];
//    [(GPUImageExposureFilter *)Filter2 setExposure:5];
//    NSString * title2 = @"曝光";
//    NSDictionary * dic2 = [NSDictionary dictionaryWithObjectsAndKeys:Filter2,@"filter",title2,@"name", nil];
//    [arr addObject:dic2];
    
//    GPUImageOutput<GPUImageInput> * Filter3 = [[GPUImageContrastFilter alloc] init];
//    [(GPUImageContrastFilter *)Filter3 setContrast:1.5];
//    NSString * title3 = @"对比度";
//    NSDictionary * dic3 = [NSDictionary dictionaryWithObjectsAndKeys:Filter3,@"filter",title3,@"name", nil];
//    [arr addObject:dic3];
    
//    GPUImageOutput<GPUImageInput> * Filter4 = [[GPUImageSaturationFilter alloc] init];
//    [(GPUImageSaturationFilter *)Filter4 setSaturation:1.5];
//    NSString * title4 = @"饱和度";
//    NSDictionary * dic4 = [NSDictionary dictionaryWithObjectsAndKeys:Filter4,@"filter",title4,@"name", nil];
//    [arr addObject:dic4];
    
    //    GPUImageOutput<GPUImageInput> * Filter5 = [[GPUImageGammaFilter alloc] init];
    //    [(GPUImageGammaFilter *)Filter5 setGamma:1.5];
    //    NSString * title5 = @"伽马线";
    //    NSDictionary * dic5 = [NSDictionary dictionaryWithObjectsAndKeys:Filter5,@"filter",title5,@"name", nil];
    
    GPUImageOutput<GPUImageInput> * Filter6 = [[GPUImageColorInvertFilter alloc] init];
    NSString * title6 = @"反色";
    NSDictionary * dic6 = [NSDictionary dictionaryWithObjectsAndKeys:Filter6,@"filter",title6,@"name", nil];
    [arr addObject:dic6];
    
    GPUImageOutput<GPUImageInput> * Filter7 = [[GPUImageSepiaFilter alloc] init];
    NSString * title7 = @"褐色怀旧";
    NSDictionary * dic7 = [NSDictionary dictionaryWithObjectsAndKeys:Filter7,@"filter",title7,@"name", nil];
    [arr addObject:dic7];
    
//    GPUImageOutput<GPUImageInput> * Filter8 = [[GPUImageGrayscaleFilter alloc] init];
//    NSString * title8 = @"灰度";
//    NSDictionary * dic8 = [NSDictionary dictionaryWithObjectsAndKeys:Filter8,@"filter",title8,@"name", nil];
//    [arr addObject:dic8];
    
    //    GPUImageOutput<GPUImageInput> * Filter9 = [[GPUImageHistogramGenerator alloc] init];
    //    NSString * title9 = @"色彩直方图？";
    //    NSDictionary * dic9 = [NSDictionary dictionaryWithObjectsAndKeys:Filter9,@"filter",title9,@"name", nil];
    GPUImageOutput<GPUImageInput> * Filter10 = [[GPUImageRGBFilter alloc] init];
    NSString * title10 = @"RGB";
    [(GPUImageRGBFilter *)Filter10 setRed:0.8];
    [(GPUImageRGBFilter *)Filter10 setGreen:0.3];
    [(GPUImageRGBFilter *)Filter10 setBlue:0.5];
    NSDictionary * dic10 = [NSDictionary dictionaryWithObjectsAndKeys:Filter10,@"filter",title10,@"name", nil];
    [arr addObject:dic10];
    
    GPUImageOutput<GPUImageInput> * Filter11 = [[GPUImageMonochromeFilter alloc] init];
    [(GPUImageMonochromeFilter *)Filter11 setColorRed:0.3 green:0.5 blue:0.8];
    NSString * title11 = @"单色";
    NSDictionary * dic11 = [NSDictionary dictionaryWithObjectsAndKeys:Filter11,@"filter",title11,@"name", nil];
    [arr addObject:dic11];
    
//    GPUImageOutput<GPUImageInput> * Filter12 = [[GPUImageBoxBlurFilter alloc] init];
////    [(GPUImageMonochromeFilter *)Filter11 setColorRed:0.3 green:0.5 blue:0.8];
//    NSString * title12 = @"单色";
//    NSDictionary * dic12 = [NSDictionary dictionaryWithObjectsAndKeys:Filter12,@"filter",title12,@"name", nil];
//    [arr addObject:dic12];
    
//    GPUImageOutput<GPUImageInput> * Filter13 = [[GPUImageSobelEdgeDetectionFilter alloc] init];
////    [(GPUImageSobelEdgeDetectionFilter *)Filter13 ];
//    NSString * title13 = @"漫画反色";
//    NSDictionary * dic13 = [NSDictionary dictionaryWithObjectsAndKeys:Filter13,@"filter",title13,@"name", nil];
//    [arr addObject:dic13];
    
//    GPUImageOutput<GPUImageInput> * Filter14 = [[GPUImageXYDerivativeFilter alloc] init];
//    //    [(GPUImageSobelEdgeDetectionFilter *)Filter13 ];
//    NSString * title14 = @"蓝绿边缘";
//    NSDictionary * dic14 = [NSDictionary dictionaryWithObjectsAndKeys:Filter14,@"filter",title14,@"name", nil];
//    [arr addObject:dic14];
    
    
    GPUImageOutput<GPUImageInput> * Filter15 = [[GPUImageSketchFilter alloc] init];
    //    [(GPUImageSobelEdgeDetectionFilter *)Filter13 ];
    NSString * title15 = @"素描";
    NSDictionary * dic15 = [NSDictionary dictionaryWithObjectsAndKeys:Filter15,@"filter",title15,@"name", nil];
    [arr addObject:dic15];
    
    GPUImageOutput<GPUImageInput> * Filter16 = [[GPUImageSmoothToonFilter alloc] init];
    //    [(GPUImageSobelEdgeDetectionFilter *)Filter13 ];
    NSString * title16 = @"卡通";
    NSDictionary * dic16 = [NSDictionary dictionaryWithObjectsAndKeys:Filter16,@"filter",title16,@"name", nil];
    [arr addObject:dic16];
    
    
    GPUImageOutput<GPUImageInput> * Filter17 = [[GPUImageColorPackingFilter alloc] init];
    //    [(GPUImageSobelEdgeDetectionFilter *)Filter13 ];
    NSString * title17 = @"监控";
    NSDictionary * dic17 = [NSDictionary dictionaryWithObjectsAndKeys:Filter17,@"filter",title17,@"name", nil];
    [arr addObject:dic17];
    
    
//    GPUImageOutput<GPUImageInput> * Filter18 = [[GPUImageVignetteFilter alloc] init];
//    //    [(GPUImageSobelEdgeDetectionFilter *)Filter13 ];
//    NSString * title18 = @"晕影";
//    NSDictionary * dic18 = [NSDictionary dictionaryWithObjectsAndKeys:Filter18,@"filter",title18,@"name", nil];
//    [arr addObject:dic18];
    
    
    GPUImageOutput<GPUImageInput> * Filter19 = [[GPUImageSwirlFilter alloc] init];
    [(GPUImageSwirlFilter *)Filter19 setRadius:1.0];
    [(GPUImageSwirlFilter*)Filter19 setAngle:0.3];
    NSString * title19 = @"漩涡";
    NSDictionary * dic19 = [NSDictionary dictionaryWithObjectsAndKeys:Filter19,@"filter",title19,@"name", nil];
    [arr addObject:dic19];
    
    GPUImageOutput<GPUImageInput> * Filter20 = [[GPUImageBulgeDistortionFilter alloc] init];
    [(GPUImageBulgeDistortionFilter *)Filter20 setRadius:0.5];//0-1
    [(GPUImageBulgeDistortionFilter*)Filter20 setScale:0.5];//-1.0----1.0
    NSString * title20 = @"鱼眼";
    NSDictionary * dic20 = [NSDictionary dictionaryWithObjectsAndKeys:Filter20,@"filter",title20,@"name", nil];
    [arr addObject:dic20];
    
    
    GPUImageOutput<GPUImageInput> * Filter21 = [[GPUImagePinchDistortionFilter alloc] init];
//    [(GPUImagePinchDistortionFilter *)Filter21 setRadius:0.5];
//    [(GPUImagePinchDistortionFilter*)Filter21 setScale:0.5];
    NSString * title21 = @"凹面镜";
    NSDictionary * dic21 = [NSDictionary dictionaryWithObjectsAndKeys:Filter21,@"filter",title21,@"name", nil];
    [arr addObject:dic21];
    
    
    GPUImageOutput<GPUImageInput> * Filter22 = [[GPUImageStretchDistortionFilter alloc] init];
    //    [(GPUImageStretchDistortionFilter *)Filter21 setRadius:0.5];
    //    [(GPUImageStretchDistortionFilter*)Filter21 setScale:0.5];
    NSString * title22 = @"凹面镜";
    NSDictionary * dic22 = [NSDictionary dictionaryWithObjectsAndKeys:Filter22,@"filter",title22,@"name", nil];
    [arr addObject:dic22];
    
    
    GPUImageOutput<GPUImageInput> * Filter23 = [[GPUImageGlassSphereFilter alloc] init];
    NSString * title23 = @"水晶球";
    NSDictionary * dic23 = [NSDictionary dictionaryWithObjectsAndKeys:Filter23,@"filter",title23,@"name", nil];
    [arr addObject:dic23];

    
    GPUImageOutput<GPUImageInput> * Filter24 = [[GPUImageSphereRefractionFilter alloc] init];
    NSString * title24 = @"水晶球反";
    NSDictionary * dic24 = [NSDictionary dictionaryWithObjectsAndKeys:Filter24,@"filter",title24,@"name", nil];
    [arr addObject:dic24];
    
    
    GPUImageOutput<GPUImageInput> * Filter25 = [[GPUImageEmbossFilter alloc] init];
    NSString * title25 = @"浮雕";
    NSDictionary * dic25 = [NSDictionary dictionaryWithObjectsAndKeys:Filter25,@"filter",title25,@"name", nil];
    [arr addObject:dic25];
    
    return arr;
}
@end
