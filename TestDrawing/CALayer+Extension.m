//
//  CALayer+Extension.m
//  TestDrawing
//
//  Created by liujing on 7/7/16.
//  Copyright © 2016 liujing. All rights reserved.
//

#import "CALayer+Extension.h"
#import <objc/runtime.h>

void MethodSwizzle(Class c,SEL origSEL,SEL overrideSEL)
{
    Method origMethod = class_getInstanceMethod(c, origSEL);
    Method overrideMethod= class_getInstanceMethod(c, overrideSEL);
    if(class_addMethod(c, origSEL, method_getImplementation(overrideMethod),method_getTypeEncoding(overrideMethod)))
    {
        class_replaceMethod(c,overrideSEL, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    }
    else{
        method_exchangeImplementations(origMethod,overrideMethod);
    }
    
}

@implementation CALayer (Extension)
- (void)override_drawInContext: (CGContextRef)ctx
{
    NSString *className =NSStringFromClass([self class]);
    NSLog(@"%@类即将调用override_drawInContext方法",className);
    // 调用旧的实现。因为它们已经被替换了
    [self override_drawInContext: ctx];
    
    
}

+ (void)load
{
    MethodSwizzle(self,@selector(drawInContext:),@selector(override_drawInContext:));
}
@end
