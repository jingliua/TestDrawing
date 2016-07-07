//
//  YRView.m
//  TestDrawing
//
//  Created by liujing on 7/7/16.
//  Copyright © 2016 liujing. All rights reserved.
//

/*可以看出当一个view被addsubview到其他view上时
1.先隐式地把此view的layer的CALayerDelegate设置成此view
2.调用此view的self.layer的drawInContext方法
3.由于drawLayer方法的注释 If defined, called by the default implementation of -drawInContext:
说明了drawInContext里if([self.delegate responseToSelector:@selector(drawLayer:inContext:)])时就执行drawLayer:inContext:方法，这里我们因为实现了drawLayer:inContext:所以会执行
4.[super drawLayer:layer inContext:ctx]会让系统自动调用此view的drawRect:方法
至此self.layer画出来了
5.在self.layer上再加一个子layer，当调用[layer setNeedsDisplay];时会自动调用此layer的drawInContext方法。drawInContext方法不能手动调用，只能通过这个方法让系统自动调用*/

#import "YRView.h"
#import "YRLayer.h"

@implementation YRView

-(instancetype)initWithFrame:(CGRect)frame{
    NSLog(@"initWithFrame:");
    if (self=[super initWithFrame:frame]) {
        YRLayer *layer=[[YRLayer alloc]init];
        layer.bounds=CGRectMake(0, 0, 185, 185);
        layer.position=CGPointMake(160,284);
        layer.backgroundColor=[UIColor colorWithRed:0 green:146/255.0 blue:1.0 alpha:1.0].CGColor;
        
        //显示图层
        [layer setNeedsDisplay];
        NSLog(@"before addsublayer");
        [self.layer addSublayer:layer];
    }
    return self;
}



-(void)drawRect:(CGRect)rect{
    NSLog(@"2-drawRect:");
    NSLog(@"drawRect里的CGContext:%@",UIGraphicsGetCurrentContext());//得到的当前图形上下文正是drawLayer中传递过来的
    [super drawRect:rect];
    
}



#pragma mark - CALayer delegate
-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx{
    
    NSLog(@"1-drawLayer:inContext:");
    NSLog(@"drawLayer里的CGContext:%@",ctx);
   [super drawLayer:layer inContext:ctx];// 如果去掉此句就不会执行drawRect!!!!!!!!
}

@end
