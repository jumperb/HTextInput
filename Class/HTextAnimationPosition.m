//
//  HTextAnimationPosition.m
//  Baby360
//
//  Created by zhangchutian on 15/6/5.
//  Copyright (c) 2015年 zhangchutian. All rights reserved.
//

#import "HTextAnimationPosition.h"
#import <Hodor/UIView+ext.h>

@implementation HTextAnimationPosition
- (void)recordAnimationStates
{
    self.orignalAnimationViewProperty = [NSValue valueWithCGRect:self.animationView.frame];
    self.orignalAnimationViewProperty2 = @(self.animationView.ymax);
}
- (void)setAnimationEndStatesWithDistance:(CGFloat)distance
{
    if (!self.orignalAnimationViewProperty || !self.orignalAnimationViewProperty2) return;
    CGRect newFrame = [(NSValue *)self.orignalAnimationViewProperty CGRectValue];
    newFrame.origin.y -= distance - ([UIScreen mainScreen].bounds.size.height -  [self.orignalAnimationViewProperty2 floatValue]);
    self.animationView.frame = newFrame;
}
- (void)recoverAnimationStates
{
    if (!self.orignalAnimationViewProperty || !self.orignalAnimationViewProperty2) return;
    self.animationView.frame = [(NSValue *)self.orignalAnimationViewProperty CGRectValue];
}
@end
