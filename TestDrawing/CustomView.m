//
//  CustomView.m
//  TestDrawing
//
//  Created by liujing on 6/30/16.
//  Copyright © 2016 liujing. All rights reserved.
//

#import "CustomView.h"

@implementation CustomView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
#pragma mark - 1.drawRect-直接利用UIKit提供的绘图方法
//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//    NSLog(@"2-drawRect:");
//    NSLog(@"CGContext:%@",UIGraphicsGetCurrentContext());//得到的当前图形上下文正是drawLayer中传递的
//    //得到这个矩形（Rect）的内切椭圆
//    //根据测试看出来stroke在Rect范围外，填充内容在Rect范围内
//    UIBezierPath* p = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0,0,100,200)];
////    UIBezierPath* p = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0,0,100,200) cornerRadius:100];
//    p.lineWidth = 18;
//    [[UIColor blueColor] setStroke];
//    [[UIColor redColor]setFill];
//    [p stroke];
//    [p fill];
//}


#pragma mark - 2.drawRect-利用Core Graphics实现绘图方法，可通过UIGraphicsGetCurrentContext获得当前上下文
//-(void)drawRect:(CGRect)rect {
//    NSLog(@"2-drawRect:");
//    CGContextRef con = UIGraphicsGetCurrentContext();
//     NSLog(@"CGContext:%@",con);//得到的当前图形上下文正是drawLayer中传递的
//    
//    CGContextSetLineWidth(con,18);
////    CGContextSetStrokeColorWithColor(con, [UIColor redColor].CGColor);//红色
//    CGContextSetRGBStrokeColor(con, 1, 1, 0, 1);//与上面方法等价 黄色
//    CGContextAddEllipseInRect(con, CGRectMake(0,0,100,200));//画椭圆
////    CGContextSetFillColorWithColor(con, [UIColor greenColor].CGColor);//绿色
//    CGContextSetRGBFillColor(con, 0, 0, 1, 1);//与上面方法等价 蓝色
//    
//    //kCGPathFill填充非零绕数规则,kCGPathEOFill表示用奇偶规则,kCGPathStroke路径,kCGPathFillStroke路径填充,kCGPathEOFillStroke表示描线，不是填充
//    
////    CGContextStrokePath(con);//对应CGContextDrawPath(con,kCGPathStroke);只画边框没有填充（无填充和有填充但填充没设置颜色默认黑色是不一样的）
////    CGContextFillPath(con);//对应CGContextDrawPath(con,kCGPathFill);只填充无边框
//    CGContextDrawPath(con,kCGPathFillStroke);//既有填充又有边框
//}

//-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx{
//   
//    NSLog(@"1-drawLayer:inContext:");
//    NSLog(@"CGContext:%@",ctx);
//    [super drawLayer:layer inContext:ctx];
//    
//}

#pragma mark - 3.drawLayer:inContext-利用UIKit提供的绘图方法,需将该context转为当前上下文。[super drawLayer:inContext:]会触发drawRect方法，若drawRect未实现，drawLayer也不会被调用。
//-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx{
//   [super drawLayer:layer inContext:ctx];
//    NSLog(@"1-drawLayer:inContext:");
//    NSLog(@"CGContext:%@",ctx);
//    UIGraphicsPushContext(ctx);//必加
//    UIBezierPath* p = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0,0,100,100)];
//    [[UIColor blueColor] setFill];
//    [p fill];
//    UIGraphicsPopContext();
//   
//    
//}

#pragma mark - 4.drawLayer:inContext-利用Core Graphics提供的绘图方法，ctx直接引用
////CALayerDelegate
//-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx{
//    [super drawLayer:layer inContext:ctx];
//    NSLog(@"1-drawLayer:inContext:");
//    NSLog(@"CGContext:%@",ctx);
//    CGContextAddEllipseInRect(ctx, CGRectMake(0,0,100,100));
//    CGContextSetFillColorWithColor(ctx, [UIColor blueColor].CGColor);
//    CGContextFillPath(ctx);
//}

#pragma mark - 5.UIGraphicsBeginImageContextWithOptions绘图方法 －drawRect- UIKit实现
//-(void)drawRect:(CGRect)rect
//{
//    UIGraphicsBeginImageContextWithOptions(CGSizeMake(100,100), NO, 0);
//    UIBezierPath* p = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0,0,100,100)];
//    [[UIColor purpleColor] setFill];
//    [p fill];
//    UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    [self addSubview:[[UIImageView alloc]initWithImage:im]];
//}

#pragma mark - 6.UIGraphicsBeginImageContextWithOptions绘图方法 －drawRect- Core Graphics实现
-(void)drawRect:(CGRect)rect
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(100,100), NO, 0);
    CGContextRef con = UIGraphicsGetCurrentContext();
    CGContextAddEllipseInRect(con, CGRectMake(0,0,100,100));
    CGContextSetFillColorWithColor(con, [UIColor blueColor].CGColor);
    CGContextFillPath(con);
    UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self addSubview:[[UIImageView alloc]initWithImage:im]];
}
#pragma mark - 7.UIGraphicsBeginImageContextWithOptions绘图方法 －drawLayer:inContext- UIKit实现
#pragma mark - 8.UIGraphicsBeginImageContextWithOptions绘图方法 －drawLayer:inContext- Core Graphics实现
#pragma mark - 9.如果self.layer add了一个子layer，并调用[sublayer setNeedsDisplay];则会触发CALayer的drawInContext方法
@end
