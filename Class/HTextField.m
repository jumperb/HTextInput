//
//  HTextField.m
//  HTextInput
//
//  Created by camera360 on 15/6/8.
//  Copyright (c) 2015年 zhangchutian. All rights reserved.
//

#import "HTextField.h"
#import "HTextAnimationContentInsect.h"
#import "HTextAnimationPosition.h"
#import "HTextSupport.h"

@interface HTextFieldDelegateObj : NSObject <UITextFieldDelegate>

@property (nonatomic, assign) CGFloat maxLength;
@property (nonatomic, weak) id<UITextFieldDelegate> outerDelegate;

@end

@interface HTextField () <UIGestureRecognizerDelegate>

@property (nonatomic, assign) CGFloat heightKeyboard;
@property (nonatomic, assign) CGPoint contentOffset;
@property (nonatomic, strong) HTextFieldDelegateObj *delegateObj;

@end

@implementation HTextField

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initTextFiled];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initTextFiled];
    }
    return self;
}

- (void)initTextFiled
{
    self.backgroundColor = [UIColor whiteColor];
    self.maxLength = 0;
    self.insect = UIEdgeInsetsMake(0, 10, 0, 10);
    self.delegateObj = [HTextFieldDelegateObj new];
    self.delegate = self.delegateObj;
    self.returnKeyType = UIReturnKeyDone;
    [self addTarget:self action:@selector(resignFirstResponder) forControlEvents:UIControlEventEditingDidEndOnExit];
}

- (void)dealloc
{
    for (HTextAnimation *animation in self.animations)
    {
        [animation removeKeyboardObserver];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - max length
- (void)setMaxLength:(CGFloat)maxLength
{
    _maxLength = maxLength;
    self.delegateObj.maxLength = maxLength;
}
- (void)setDelegate:(id<UITextFieldDelegate>)delegate
{
    id<UITextFieldDelegate> mainDelegate = self.delegateObj;
    [super setDelegate:mainDelegate];
    if(delegate != mainDelegate)
    {
        self.delegateObj.outerDelegate = delegate;
    }
}
#pragma mark - text insect

- (CGRect)textRectForBounds:(CGRect)bounds
{
    return UIEdgeInsetsInsetRect(bounds, _insect);
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return UIEdgeInsetsInsetRect(bounds, _insect);
}
- (void)setInsect:(UIEdgeInsets)insect
{
    _insect = insect;
    [self setNeedsDisplay];
}

#pragma mark - about animation
- (void)layoutSubviews
{
    [super layoutSubviews];
    if (_motherBoard)
    {
        self.animations = nil;
    }
    else if (!self.animations)
    {
        self.animations = @[[self defaultAnimation]];
    }
}
- (BOOL)becomeFirstResponder
{
    for (HTextAnimation *animation in self.animations)
    {
        [animation addkeyBoardObserver];
    }
    return [super becomeFirstResponder];
}
- (HTextAnimation *)defaultAnimation
{
    HTextAnimation *animation = nil;
    UIView *superView = [HTextSupport anyScrollViewAsSuperView:self];
    if (superView)
    {
        [(UIScrollView *)superView setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
        animation = [HTextAnimationContentInsect new];
    }
    else
    {
        superView = [HTextSupport animationSuperView:self];
        __weak typeof(superView) weakSuperView = superView;
        animation = [HTextAnimationPosition new];
        __weak typeof(self) weakSelf = self;
        [animation setKeyboardDidShow:^(id data){
            //给superView添加手势
            HSwipeGestureRecognizer *ges = [[HSwipeGestureRecognizer alloc] initWithTarget:weakSelf action:@selector(resignFirstResponder)];
            ges.delegate = weakSelf;
            ges.direction = UISwipeGestureRecognizerDirectionDown|UISwipeGestureRecognizerDirectionUp;
            [weakSuperView addGestureRecognizer:ges];
        }];
        [animation setKeyboardDidDismiss:^(id data){
            //移除手势
            for (UIGestureRecognizer *ges in weakSuperView.gestureRecognizers)
            {
                if ([ges isKindOfClass:[HSwipeGestureRecognizer class]])
                {
                    [weakSuperView removeGestureRecognizer:ges];
                }
            }
        }];
    }
    animation.animationView = superView;
    animation.focusView = self;
    animation.inputView = self;
    animation.adjustDistanceCallback = self.adjustDistanceCallback;
    return animation;
}


@end



#pragma mark - delegate transfer
@implementation HTextFieldDelegateObj

- (instancetype)init
{
    self = [super init];
    if (self) {
        _maxLength = 0;
    }
    return self;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.outerDelegate && [self.outerDelegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)])
    {
        BOOL outerResult = [self.outerDelegate textField:textField shouldChangeCharactersInRange:range replacementString:string];
        if (!outerResult) return NO;
    }
    if (_maxLength == 0) return YES;
    NSInteger existedLength = textField.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = string.length;
    if (existedLength - selectedLength + replaceLength > _maxLength) {
        return NO;
    }
    NSString *tmpText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (tmpText.length > _maxLength)
    {
        textField.text = [tmpText substringToIndex:_maxLength];
        return NO;
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (self.outerDelegate && [self.outerDelegate respondsToSelector:@selector(textFieldDidBeginEditing:)])
    {
        [self.outerDelegate textFieldDidBeginEditing:textField];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.outerDelegate && [self.outerDelegate respondsToSelector:@selector(textFieldDidEndEditing:)])
    {
        [self.outerDelegate textFieldDidEndEditing:textField];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (self.outerDelegate && [self.outerDelegate respondsToSelector:@selector(textFieldShouldBeginEditing:)])
    {
        return [self.outerDelegate textFieldShouldBeginEditing:textField];
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if (self.outerDelegate && [self.outerDelegate respondsToSelector:@selector(textFieldShouldClear:)])
    {
        return [self.outerDelegate textFieldShouldClear:textField];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (self.outerDelegate && [self.outerDelegate respondsToSelector:@selector(textFieldShouldEndEditing:)])
    {
        return [self.outerDelegate textFieldShouldEndEditing:textField];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.outerDelegate && [self.outerDelegate respondsToSelector:@selector(textFieldShouldReturn:)])
    {
        return [self.outerDelegate textFieldShouldReturn:textField];
    }
    if ([textField isKindOfClass:[HTextField class]])
    {
        if (((HTextField *)textField).returnPressed) ((HTextField *)textField).returnPressed(textField, textField.text);
    }
    return YES;
}

#pragma mark - gesture delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    UIView *view = touch.view;
    if([view isKindOfClass:[UIControl class]])
    {
        UIControl *control = (UIControl *)view;
        if(control.userInteractionEnabled == NO) return YES;
        if(control.alpha < 0.0001) return YES;
        if(!control.enabled) return YES;
        return NO;
    }
    return YES;
}
@end