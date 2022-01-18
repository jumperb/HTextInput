//
//  HTextAnimation.m
//  Hodor
//
//  Created by zhangchutian on 15/6/5.
//  Copyright (c) 2015年 zhangchutian. All rights reserved.
//

#import "HTextAnimation.h"

@interface HTextAnimation ()
@property (nonatomic) BOOL didAddObserver;
@property (nonatomic) BOOL recorded;
@property (nonatomic) BOOL isDismissing;
@end

@implementation HTextAnimation

- (instancetype)init
{
    self = [super init];
    if (self) {
        _duration = -1.0;
        _orignalFocusPositionY = nil;
        _orignalAnimationViewProperty = nil;
        _orignalAnimationViewProperty2 = nil;
        _isKeyboardHiddenFinish = YES;
    }
    return self;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (UIView *)animationView
{
    if (_animationView)
    {
        return _animationView;
    }
    else
    {
        return [(UIWindow *)[UIApplication sharedApplication].windows[0] rootViewController].view;
    }
}

- (void)recordAnimationStates
{
    NSAssert(NO, @"need imp");
}
- (void)setAnimationEndStatesWithDistance:(CGFloat)distance
{
    NSAssert(NO, @"need imp");
}
- (void)recoverAnimationStates
{
    NSAssert(NO, @"need imp");
}


- (void)doAnimationWithKeyboardHeight:(float)keyboardHeight duration:(float)animationDuration opt:(NSInteger)opt record:(BOOL)record
{
    UIWindow *window = [UIApplication sharedApplication].windows[0];
    //1.compute animation distance
    float animationDistance = keyboardHeight;
    BOOL didAddAdjust = NO;
    if (animationDistance > 0)
    {
        if (_focusView)
        {
            if (!_orignalFocusPositionY)
            {
                //conpute the postion of focusView on Window
                float maxy = _focusView.frame.size.height;
                if ([_focusView isKindOfClass:[UIScrollView class]])
                {
                    maxy += [(UIScrollView *)_focusView contentOffset].y;
                }
                CGPoint p = [_focusView convertPoint:CGPointMake(0, maxy) toView:window];
                _orignalFocusPositionY = [NSNumber numberWithFloat:p.y];
            }
            animationDistance = _orignalFocusPositionY.floatValue - (window.frame.size.height - keyboardHeight);
            if (keyboardHeight > 0 && _adjustDistanceCallback)
            {
                animationDistance = _adjustDistanceCallback(animationDistance);
            }
            didAddAdjust = YES;
            //is need move down?
            if (animationDistance < 0 && keyboardHeight > 0)
            {
                if (!_alwaysAnimation) return;
            }
        }
    }
    if (!didAddAdjust && keyboardHeight > 0 && _adjustDistanceCallback)
    {
        animationDistance = _adjustDistanceCallback(animationDistance);
    }
    //2.record
    if (record)
    {
        [self recordAnimationStates];
    }
    //3.do animation
    if (_duration > 0) animationDuration = _duration;
    if (keyboardHeight > 0)
    {
        if (_animationWillBegin) _animationWillBegin(@(keyboardHeight));
        if (animationDuration > 0.00001)
        {
            [UIView animateWithDuration:animationDuration delay:0 options:opt animations:^{
                [self setAnimationEndStatesWithDistance:animationDistance];
            } completion:^(BOOL finished) {
                if (_animationDidEnd) _animationDidEnd(@(keyboardHeight));
            }];
        }
        else
        {
            [self setAnimationEndStatesWithDistance:animationDistance];
            if (_animationDidEnd) _animationDidEnd(@(keyboardHeight));
        }
    }
    else
    {
        [self resetAnimationViewWithDuration:animationDuration opt:opt];
    }
}
- (void)resetAnimationViewWithDuration:(float)animationDuration opt:(NSInteger)opt
{
    if (_animationWillBegin) _animationWillBegin(@(0));
    if (_duration > 0) animationDuration = _duration;
    if (animationDuration > 0.00001)
    {
        [UIView animateWithDuration:animationDuration delay:0 options:opt animations:^{
            [self recoverAnimationStates];
        } completion:^(BOOL finished) {
            if (_animationDidEnd) _animationDidEnd(@(0));
        }];
    }
    else
    {
        [self recoverAnimationStates];
        if (_animationDidEnd) _animationDidEnd(@(0));
    }
}

#pragma mark HTextAnimation protocal
- (void)addkeyBoardObserver
{
    if (!_didAddObserver)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHidden:) name:UIKeyboardDidHideNotification object:nil];
        _didAddObserver = YES;
    }
}
- (void)removeKeyboardObserver
{
    _didAddObserver = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - keyboard notifications
- (void)keyboardDidShow:(NSNotification *)noti
{
    if (![_inputView isFirstResponder]) return;
    if (self.keyboardDidShow) self.keyboardDidShow(self);
    self.isAnimating = NO;
}
- (void)keyboardDidHidden:(NSNotification *)noti
{
    self.isAnimating = NO;
    self.recorded = NO;
    self.orignalAnimationViewProperty = nil;
    self.orignalAnimationViewProperty2 = nil;
    self.orignalFocusPositionY = nil;
    self.isKeyboardHiddenFinish = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isKeyboardHiddenFinish = YES;
        if (self.keyboardDidDismiss) self.keyboardDidDismiss(self);
    });
    [self removeKeyboardObserver];
}

- (void)keyboardWillChangeFrame:(NSNotification *)noti
{
    if (_isAnimating) return;
    //if this delegate is trigered by show or dismiss, ignore
//    if (![_inputView isFirstResponder]) return;
    CGFloat animatedDuration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    NSInteger animationCurve = [noti.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    animationCurve = (animationCurve << 16);
    CGRect keyboardFrame = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardHeight = [UIScreen mainScreen].bounds.size.height - keyboardFrame.origin.y;
    [self doAnimationWithKeyboardHeight:keyboardHeight duration:animatedDuration opt:animationCurve record:!self.recorded];
    if (!self.recorded) self.recorded = YES;
}
@end


@implementation HSwipeGestureRecognizer
@end
