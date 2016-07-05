//
//  ViewController.m
//  TestDrawing
//
//  Created by liujing on 6/30/16.
//  Copyright © 2016 liujing. All rights reserved.
//

#import "ViewController.h"
#import "CustomView.h"
#import "DrawedImageView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    测试1:
//    CustomView *cv = [[CustomView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
    
    //因3x的图片会自动scale成原来的1/3，所以想要出现两个图片，此view需为130*2/3
//  测试2:  DrawedImageView *cv = [[DrawedImageView alloc]initWithFrame:CGRectMake(0, 0, 130*2/3, 130)];
     DrawedImageView *cv = [[DrawedImageView alloc]initWithFrame:CGRectMake(0, 0, 130, 130)];
  
    cv.center = self.view.center;
    cv.backgroundColor = [UIColor grayColor];
    [self.view addSubview:cv];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
