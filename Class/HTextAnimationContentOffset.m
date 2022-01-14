//
//  HTextAnimationContentOffset.m
//  Hodor
//
//  Created by zhangchutian on 15/6/5.
//  Copyright (c) 2015年 zhangchutian. All rights reserved.
//

#import "HTextAnimationContentOffset.h"

@implementation HTextAnimationContentOffset
- (void)recordAnimationStates
{
    NSAssert([self.animationView isKindOfClass:[UIScrollView class]], @"HTextAnimationContentOffset只能应用于UIScrollView");
    if (![self.animationView isKindOfClass:[UIScrollView class]]) return;

    self.orignalAnimationViewProperty = [NSValue valueWithCGPoint:[(UIScrollView *)self.animationView contentOffset]];
}
- (void)setAnimationEndStatesWithDistance:(CGFloat)distance
{
    if (!self.orignalAnimationViewProperty) return;
    NSAssert([self.animationView isKindOfClass:[UIScrollView class]], @"HTextAnimationContentOffset只能应用于UIScrollView");
    if (![self.animationView isKindOfClass:[UIScrollView class]]) return;
    CGPoint newOffset = [(NSValue *)self.orignalAnimationViewProperty CGPointValue];
    newOffset.y += distance;
    [(UIScrollView *)self.animationView setContentOffset:newOffset];
}
- (void)recoverAnimationStates
{
    if (!self.orignalAnimationViewProperty) return;
    NSAssert([self.animationView isKindOfClass:[UIScrollView class]], @"HTextAnimationContentOffset只能应用于UIScrollView");
    if (![self.animationView isKindOfClass:[UIScrollView class]]) return;
    [(UIScrollView *)self.animationView setContentOffset:[(NSValue *)self.orignalAnimationViewProperty CGPointValue]];
}
@end
