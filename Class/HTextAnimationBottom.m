//
//  HTextAnimationBottom.m
//  Baby360
//
//  Created by zhangchutian on 15/6/5.
//  Copyright (c) 2015年 zhangchutian. All rights reserved.
//

#import "HTextAnimationBottom.h"
#import <Hodor/UIView+ext.h>

@implementation HTextAnimationBottom

- (void)setAlwaysAnimation:(BOOL)alwaysAnimation
{
    [super setAlwaysAnimation:YES];
}

- (void)setFocusView:(UIView *)focusView
{

}
- (void)recordAnimationStates
{
    NSAssert([self.animationView isKindOfClass:[UIScrollView class]], @"HTextAnimationBottom只能应用于UIScrollView");
    if (![self.animationView isKindOfClass:[UIScrollView class]]) return;

    self.orignalAnimationViewProperty = [NSValue valueWithUIEdgeInsets:[(UIScrollView *)self.animationView contentInset]];
}
- (void)setAnimationEndStatesWithDistance:(CGFloat)distance
{
    if (!self.orignalAnimationViewProperty) return;
    NSAssert([self.animationView isKindOfClass:[UIScrollView class]], @"HTextAnimationBottom只能应用于UIScrollView");
    if (![self.animationView isKindOfClass:[UIScrollView class]]) return;

    UIScrollView *scrollView = (UIScrollView *)self.animationView;

    UIEdgeInsets newEdge = [(NSValue *)self.orignalAnimationViewProperty UIEdgeInsetsValue];
    newEdge.bottom = distance - ([UIScreen mainScreen].bounds.size.height - scrollView.ymax);
    [(UIScrollView *)self.animationView setContentInset:newEdge];
    [self scrollToBottom:scrollView edge:newEdge];
}
- (void)recoverAnimationStates
{
    if (!self.orignalAnimationViewProperty) return;
    NSAssert([self.animationView isKindOfClass:[UIScrollView class]], @"HTextAnimationBottom只能应用于UIScrollView");
    if (![self.animationView isKindOfClass:[UIScrollView class]]) return;

    UIScrollView *scrollView = (UIScrollView *)self.animationView;
    UIEdgeInsets oldEdge = [(NSValue *)self.orignalAnimationViewProperty UIEdgeInsetsValue];
    [scrollView setContentInset:oldEdge];
    [self scrollToBottom:scrollView edge:oldEdge];
}
- (void)scrollToBottom:(UIScrollView *)scrollView edge:(UIEdgeInsets)targetEdge
{
    float visiableHeight = scrollView.frame.size.height - targetEdge.bottom;
    if (scrollView.contentSize.height + targetEdge.top <= visiableHeight) return;
    [scrollView setContentOffset:CGPointMake(0, scrollView.contentSize.height - visiableHeight) animated:YES];
}
@end
