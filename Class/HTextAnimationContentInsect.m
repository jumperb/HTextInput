//
//  HTextAnimationContentInsect.m
//  Baby360
//
//  Created by zhangchutian on 15/6/5.
//  Copyright (c) 2015年 zhangchutian. All rights reserved.
//

#import "HTextAnimationContentInsect.h"
#import <Hodor/UIView+ext.h>

@implementation HTextAnimationContentInsect

- (void)setAlwaysAnimation:(BOOL)alwaysAnimation
{
    [super setAlwaysAnimation:YES];
}

- (void)setFocusView:(UIView *)focusView
{

}
- (void)recordAnimationStates
{

    NSAssert([self.animationView isKindOfClass:[UIScrollView class]], @"HTextAnimationContentInsect只能应用于UIScrollView");
    if (![self.animationView isKindOfClass:[UIScrollView class]]) return;

    self.orignalAnimationViewProperty = [NSValue valueWithUIEdgeInsets:[(UIScrollView *)self.animationView contentInset]];
}
- (void)setAnimationEndStatesWithDistance:(CGFloat)distance
{
    if (!self.orignalAnimationViewProperty) return;
    NSAssert([self.animationView isKindOfClass:[UIScrollView class]], @"HTextAnimationContentInsect只能应用于UIScrollView");
    if (![self.animationView isKindOfClass:[UIScrollView class]]) return;

    UIEdgeInsets newEdge = [(NSValue *)self.orignalAnimationViewProperty UIEdgeInsetsValue];
    newEdge.bottom = distance - ([UIScreen mainScreen].bounds.size.height - ((UIScrollView *)self.animationView).ymax);
    [(UIScrollView *)self.animationView setContentInset:newEdge];
}
- (void)recoverAnimationStates
{
    if (!self.orignalAnimationViewProperty) return;
    NSAssert([self.animationView isKindOfClass:[UIScrollView class]], @"HTextAnimationContentInsect只能应用于UIScrollView");
    if (![self.animationView isKindOfClass:[UIScrollView class]]) return;

    [(UIScrollView *)self.animationView setContentInset:[(NSValue *)self.orignalAnimationViewProperty UIEdgeInsetsValue]];
}
@end
