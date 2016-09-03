//
//  HTextInputMotherBoard.m
//  HTextInput
//
//  Created by zhangchutian on 15/5/27.
//  Copyright (c) 2015年 zhangchutian. All rights reserved.
//

#import "HTextInputMotherBoard.h"
#import "HTextField.h"
#import "HTextView.h"
#import "HCommon.h"

@interface HTextInputMotherBoard ()
@property (nonatomic) UITextField *triger;
@end

@implementation HTextInputMotherBoard

+ (HTextInputMotherBoard *)view
{
    UIView *window = [UIApplication sharedApplication].windows[0];
    HTextInputMotherBoard *superView = [[HTextInputMotherBoard alloc] initWithFrame:window.bounds];
    [window addSubview:superView];
    return superView;
}
+ (HTextInputMotherBoard *)currentMotherBoard
{
    UIView *window = [UIApplication sharedApplication].windows[0];
    for (UIView *view in window.subviews)
    {
        if ([view isKindOfClass:[HTextInputMotherBoard class]])
        {
            return (HTextInputMotherBoard *)view;
        }
    }
    return nil;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchDown];
        _triger = [[UITextField alloc] initWithFrame:CGRectMake(0, self.height, self.width, 44)];
        ALWAYS_BW(_triger);
        [self addSubview:_triger];
    }
    return self;
}
- (void)dealloc
{
    for (HTextAnimation *animation in self.animations)
    {
        [animation removeKeyboardObserver];
    }
}
- (void)setTargetResponder:(UIResponder<HTextInputRecver> *)targetResponder
{
    _targetResponder = targetResponder;
    if ([targetResponder isKindOfClass:[HTextField class]])
    {
        [(HTextField *)targetResponder setMotherBoard:self];
    }
    else if ([targetResponder isKindOfClass:[HTextView class]])
    {
        [(HTextView *)targetResponder setMotherBoard:self];
    }
}
- (void)show
{
    NSAssert(self.superview, @"need add to window");
    NSAssert(self.width > 1 && self.height > 1, @"is you size correct?");
    if (_animations)
    {
        for (HTextAnimation *animation in self.animations)
        {
            if (animation.isAnimating) return;
            [animation addkeyBoardObserver];
            animation.inputView = _triger;
            __weak typeof(self) weakSelf = self;
            __weak typeof(animation) weakAnimation = animation;
            [animation setKeyboardDidShow:^(id data){
                if ([weakSelf.triger isFirstResponder])
                {
                    if (weakSelf.didShow) weakSelf.didShow(weakSelf, weakSelf.targetResponder);
                    [weakSelf.targetResponder becomeFirstResponder];
                    weakAnimation.inputView = weakSelf.targetResponder;
                }
            }];
        }
    }
    else
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.didShow) self.didShow(self, self.targetResponder);
            [self.targetResponder becomeFirstResponder];
        });
    }
    [self.targetResponder setInputView:nil];
    [_triger becomeFirstResponder];
}
- (void)dismiss
{
    for (HTextAnimation *animation in self.animations)
    {
        if (animation.isAnimating) return;
    }
    if (_willDismiss) _willDismiss(self, _targetResponder);
    if ([_triger isFirstResponder])
    {
        [_triger resignFirstResponder];
    }
    else if ([self.targetResponder isFirstResponder])
    {
        [self.targetResponder resignFirstResponder];
    }


    if (self.didResignResponder)
    {
        self.didResignResponder(self, _targetResponder);
    }
    [self removeFromSuperview];
}


#pragma mark - UIKeyInput

- (BOOL)hasText
{
    return YES;
}
- (void)insertText:(NSString *)text
{

}
- (void)deleteBackward
{
    
}


@end
