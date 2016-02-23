//
//  HTextSupport.m
//  HTextInput
//
//  Created by zhangchutian on 15/6/9.
//  Copyright (c) 2015年 zhangchutian. All rights reserved.
//

#import "HTextSupport.h"

@implementation HTextSupport
+ (UIScrollView *)anyScrollViewAsSuperView:(UIView *)view
{
    UIView *superView = view.superview;
    while (superView && ![superView isKindOfClass:[UIWindow class]])
    {
        if ([superView isKindOfClass:[UIScrollView class]])
        {
            return (UIScrollView *)superView;
        }
        superView = superView.superview;
    }
    return nil;
}
+ (UIView *)animationSuperView:(UIView *)view
{
    UIWindow *window = [view window];
    UIViewController *VC = window.rootViewController;
    if ([VC isKindOfClass:[UINavigationController class]])
    {
        UIView *topView = [(UINavigationController *)VC topViewController].view;
        UIView *superView = view.superview;
        while (superView &&![superView isKindOfClass:[UIWindow class]])
        {
            if (superView == topView)
            {
                return topView;
            }
            superView = superView.superview;
        }
    }
    return window;
}
@end
