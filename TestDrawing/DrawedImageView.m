//
//  DrawedImageView.m
//  TestDrawing
//
//  Created by liujing on 6/30/16.
//  Copyright © 2016 liujing. All rights reserved.
//

#import "DrawedImageView.h"

@implementation DrawedImageView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

#pragma mark - UIKit- UIImage绘制 － 可以通过drawAtPoint对图片进行平移 剪切,drawInRect进行缩放。UIImage无法分割图片
//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//    
//    UIImage* mars = [UIImage imageNamed:@"Statement"];
//    CGSize sz = [mars size];//3x的图片size为原来的px/3
//    
//    UIGraphicsBeginImageContextWithOptions(CGSizeMake(sz.width*2, sz.width*2), NO, 0);
////    [mars drawAsPatternInRect:CGRectMake(-10, 10, sz.width*1.5, sz.height+100)];//图片平铺在Rect里，超出画布部分不显示
//    
//    [mars drawInRect:CGRectMake(0,0,sz.width*2,sz.height*2)];//图片拉伸压缩到指定区域，超出画布部分不显示
//    [mars drawInRect:CGRectMake(sz.width/2.0, sz.height/2.0, sz.width, sz.height) blendMode:kCGBlendModeMultiply alpha:1.0];
//
////    [mars drawAtPoint:CGPointMake(sz.width,0)];//把图片绘制到指定位置，即pointx,pointy移动到指定位置
////    [mars drawAtPoint:CGPointMake(0,sz.width*1.5)];//超出画布的部分图片不显示
//   
//    UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    UIImageView* iv = [[UIImageView alloc] initWithImage:im];
//    [self addSubview:iv];
//}


#pragma mark - CoreGraphics- CGContextDrawImage绘制，CGImage可以分隔图片
//-(void)drawRect:(CGRect)rect{
//   
//    UIImage* mars = [UIImage imageNamed:@"Statement2"];
//    CGSize sz = [mars size];
//    
//    CGImageRef marsLeft = CGImageCreateWithImageInRect([mars CGImage],CGRectMake(0,0,sz.width/2.0,sz.height));
//    CGImageRef marsRight = CGImageCreateWithImageInRect([mars CGImage],CGRectMake(sz.width/2.0,0,sz.width/2.0,sz.height));
//    
//    UIGraphicsBeginImageContextWithOptions(CGSizeMake(sz.width*1.5, sz.height), NO, 0);//画布
//    CGContextRef con = UIGraphicsGetCurrentContext();//通过core graphics绘图，拿到当前上下文
//
//    CGContextDrawImage(con, CGRectMake(0,0,sz.width/2.0,sz.height), marsLeft);
//    CGContextDrawImage(con, CGRectMake(sz.width,0,sz.width/2.0,sz.height), marsRight);
//    
//    UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
//
//    UIGraphicsEndImageContext();
//    
//    // 记得释放内存，ARC在这里无效
//    CGImageRelease(marsLeft);
//    CGImageRelease(marsRight);
//    
//    UIImageView* iv = [[UIImageView alloc] initWithImage:im];
//    [self addSubview:iv];
//}

#pragma mark - UIImage绘制 － 解决了CGContextDrawImage绘制的倒置问题和缩放问题
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    UIImage* mars = [UIImage imageNamed:@"Statement2"];
    CGSize sz = [mars size];//除以scale之后的 eg:@2x 除以2
    
    CGImageRef marsCG = [mars CGImage];
    CGSize szCG = CGSizeMake(CGImageGetWidth(marsCG), CGImageGetHeight(marsCG));//图片真实尺寸，未除以scale之前
    
    CGImageRef marsLeft = CGImageCreateWithImageInRect(marsCG, CGRectMake(0,0,szCG.width/2.0,szCG.height));//左半边图片
    CGImageRef marsRight = CGImageCreateWithImageInRect(marsCG, CGRectMake(szCG.width/2.0,0,szCG.width/2.0,szCG.height));//右半边图片
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(sz.width*1.5, sz.height), NO, 0);//画布宽为图片尺寸/scale之后＊1.5

    // UIImage绘图时会自动修复倒置问题
    [[UIImage imageWithCGImage:marsLeft scale:[mars scale] orientation:UIImageOrientationUp] drawAtPoint:CGPointMake(0,0)];//从(0,0)开始
    [[UIImage imageWithCGImage:marsRight scale:[mars scale] orientation:UIImageOrientationUp] drawAtPoint:CGPointMake(sz.width,0)];//从sz.width开始
    
    UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //需手动释放
    CGImageRelease(marsLeft);
    CGImageRelease(marsRight);
   
    UIImageView* iv = [[UIImageView alloc] initWithImage:im];
    [self addSubview:iv];
}

#pragma mark ------------------------------------图像处理CIImage－－－－－－－－－－－－－－－－－－－－－－
//-(void)drawRect:(CGRect)rect
//{
//    UIImage* moi = [UIImage imageNamed:@"Statement2"];
//    CIImage* moi2 = [[CIImage alloc] initWithCGImage:moi.CGImage];
//    
//    CIFilter* grad = [CIFilter filterWithName:@"CIRadialGradient"];
//    CIVector* center = [CIVector vectorWithX:moi.size.width / 2.0 Y:moi.size.height / 2.0];
//    // 使用setValue：forKey：方法设置滤镜属性
//    [grad setValue:center forKey:@"inputCenter"];
//    
//    // 在指定滤镜名时提供所有滤镜键值对
//    CIFilter* dark = [CIFilter filterWithName:@"CIDarkenBlendMode" keysAndValues:@"inputImage", grad.outputImage, @"inputBackgroundImage", moi2, nil];
////    CIContext用来渲染CIImage，将作用在CIImage上的滤镜链应用到原始的图片数据中
//    CIContext* c = [CIContext contextWithOptions:nil];
//    //render the ciimage into a cgimageref
//    CGImageRef moi3 = [c createCGImage:dark.outputImage fromRect:moi2.extent];//由CIFilter的outputImage即CIImage创建CGImageRef,范围为CIImage的extent大小
//    //create a uiimage from the cgimage
//    UIImage* moi4 = [UIImage imageWithCGImage:moi3 scale:moi.scale orientation:moi.imageOrientation];//由CGImageRef创建UIImage
//    CGImageRelease(moi3);
//    
//    UIImageView* iv = [[UIImageView alloc] initWithImage:moi4];
//    [self addSubview:iv];
//}

@end
