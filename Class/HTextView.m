//
//  HTextView.m
//  HTextInput
//
//  Created by camera360 on 15/6/8.
//  Copyright (c) 2015年 zhangchutian. All rights reserved.
//

#import "HTextView.h"
#import "HTextSupport.h"
#import "HTextAnimationContentInsect.h"
#import "HTextAnimationContentOffset.h"
#import "HTextAnimationPosition.h"
#import "HTextAnimationFrame.h"
#import <Hodor/UIView+ext.h>

@interface HTextViewDelegateObj : NSObject <UITextViewDelegate>

@property (nonatomic) CGFloat maxLength;
@property (nonatomic) CGFloat lineSpacing;
@property (nonatomic, weak) id<UITextViewDelegate> outerDelegate;
@property (nonatomic) BOOL enableReturn;
@end

@interface HTextView () <UIGestureRecognizerDelegate>
@property (nonatomic) UILabel *holderLabel;
@property (nonatomic) HTextViewDelegateObj *delegateObj;
@end

@implementation HTextView


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initTextView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initTextView];
    }
    return self;
}

- (void)initTextView
{
    self.backgroundColor = [UIColor whiteColor];
    self.decelerationRate = UIScrollViewDecelerationRateFast;
    self.font = [UIFont systemFontOfSize:16];
    self.textColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1];
    self.layoutManager.allowsNonContiguousLayout = NO;
    self.maxLength = 0;
    self.delegateObj = [HTextViewDelegateObj new];
    self.delegate = self.delegateObj;
    self.placeHolderInsets = UIEdgeInsetsZero;
    self.placeholderColor = [UIColor lightGrayColor];
    [self setEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    self.enableReturn = YES;
    self.delegateObj.enableReturn = self.enableReturn;
}

- (void)dealloc
{
    for (HTextAnimation *animation in self.animations)
    {
        [animation removeKeyboardObserver];
    }
}
- (void)setEnableReturn:(BOOL)enableReturn
{
    _enableReturn = enableReturn;
    self.delegateObj.enableReturn = enableReturn;
}
- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    if (_placeholder.length > 0)
    {
        if (!_holderLabel)
        {
            CGRect frame = CGRectMake(self.textContainerInset.left + 5, self.textContainerInset.top,
                                      self.width - self.textContainerInset.left - self.textContainerInset.right,
                                      self.font.lineHeight);
            if (!UIEdgeInsetsEqualToEdgeInsets(_placeHolderInsets, UIEdgeInsetsZero))
            {
                frame = CGRectMake(_placeHolderInsets.left, _placeHolderInsets.top, self.width - _placeHolderInsets.left - _placeHolderInsets.right, self.font.lineHeight);
            }
            self.holderLabel = [[UILabel alloc] initWithFrame:frame];
            _holderLabel.textColor = self.placeholderColor;
            _holderLabel.font = self.font;
            [self addSubview:_holderLabel];
        }
        _holderLabel.text = _placeholder;
    }
    else
    {
        [_holderLabel removeFromSuperview];
        _holderLabel = nil;
    }
}
- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    self.holderLabel.font = font;
    if (UIEdgeInsetsEqualToEdgeInsets(_placeHolderInsets, UIEdgeInsetsZero))
    {
        self.holderLabel.frame = CGRectMake(self.textContainerInset.left + 5, self.textContainerInset.top,
                                        self.width - self.textContainerInset.left - self.textContainerInset.right,
                                        font.lineHeight);
    }
}
- (void)setText:(NSString *)text
{
    [super setText:text];
    [self.delegate textViewDidChange:self];
}
- (void)setMaxLength:(CGFloat)maxLength
{
    _maxLength = maxLength;
    self.delegateObj.maxLength = maxLength;
}

- (void)setEdgeInsets:(UIEdgeInsets)edgeInsets
{
    self.textContainerInset = edgeInsets;
    if (UIEdgeInsetsEqualToEdgeInsets(_placeHolderInsets, UIEdgeInsetsZero))
    {
        self.holderLabel.frame = CGRectMake(edgeInsets.left + 5, edgeInsets.top, self.width - _placeHolderInsets.left - _placeHolderInsets.right, self.holderLabel.height);
    }
}
- (void)setPlaceHolderInsets:(UIEdgeInsets)placeHolderInsets
{
    _placeHolderInsets = placeHolderInsets;
    if (_holderLabel) self.holderLabel.frame = CGRectMake(placeHolderInsets.left, placeHolderInsets.top, self.width - placeHolderInsets.left - placeHolderInsets.right, self.holderLabel.height);
}
- (void)setDelegate:(id<UITextViewDelegate>)delegate
{
    id<UITextViewDelegate> mainDelegate = self.delegateObj;
    [super setDelegate:mainDelegate];
    if(delegate != mainDelegate)
    {
        self.delegateObj.outerDelegate = delegate;
    }
}
#pragma mark - about animation
- (void)layoutSubviews
{
    //ios7+ UITextView will do serveral times layout when dismiss keyboard, but exist some bug

    for (HTextAnimation *animation in self.animations)
    {
        if (!animation.isKeyboardHiddenFinish) return;
    }

    [super layoutSubviews];

    if (_motherBoard)
    {
        //because motherboard has animations
        self.animations = nil;
    }
    else if (!self.animations)
    {
        self.animations = [self defaultAnimations];
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
- (NSArray *)defaultAnimations
{
    UIView *superView = nil;
    if (self.height > [UIScreen mainScreen].bounds.size.height/2)
    {
        superView = self;
        HTextAnimation *animation1 = [HTextAnimationFrame new];
        animation1.animationView = superView;
        animation1.inputView = self;
        animation1.adjustDistanceCallback = self.adjustDistanceCallback;
        return @[animation1];
    }
    else
    {
        superView = [HTextSupport anyScrollViewAsSuperView:self];
        if (superView)
        {
            [(UIScrollView *)superView setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
            HTextAnimation *animation1 = [HTextAnimationContentInsect new];
            animation1.animationView = superView;
            animation1.focusView = self;
            animation1.inputView = self;
            animation1.adjustDistanceCallback = self.adjustDistanceCallback;

            HTextAnimation *animation2 = [HTextAnimationContentOffset new];
            animation2.animationView = superView;
            animation2.focusView = self;
            animation2.inputView = self;
            animation2.adjustDistanceCallback = self.adjustDistanceCallback;
            return @[animation1,animation2];
        }
        else
        {
            superView = [HTextSupport animationSuperView:self];
            __weak typeof(superView) weakSuperView = superView;
            HTextAnimation *animation = [HTextAnimationPosition new];
            __weak typeof(self) weakSelf = self;
            [animation setKeyboardDidShow:^(id data){
                //给superView添加手势
                HSwipeGestureRecognizer *ges = [[HSwipeGestureRecognizer alloc] initWithTarget:weakSelf action:@selector(resignFirstResponder)];
                ges.delegate = weakSelf;
                ges.direction = UISwipeGestureRecognizerDirectionDown|UISwipeGestureRecognizerDirectionUp;
                [weakSuperView addGestureRecognizer:ges];
            }];
            [animation setKeyboardDidDismiss:^(id data){
                //remove gestures
                for (UIGestureRecognizer *ges in weakSuperView.gestureRecognizers)
                {
                    if ([ges isKindOfClass:[HSwipeGestureRecognizer class]])
                    {
                        [weakSuperView removeGestureRecognizer:ges];
                    }
                }
            }];
            animation.adjustDistanceCallback = self.adjustDistanceCallback;
            animation.animationView = superView;
            animation.focusView = self;
            animation.inputView = self;
            return @[animation];
        }
    }

}

@end

#pragma mark - delegate transger
@implementation HTextViewDelegateObj

- (instancetype)init
{
    self = [super init];
    if (self) {
        _maxLength = 0;
        _lineSpacing = 0;
        _outerDelegate = nil;
    }
    return self;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([textView isKindOfClass:[HTextView class]])
    {
        if ([text isEqualToString:@"\n"])
        {
            if (((HTextView *)textView).returnPressed) ((HTextView *)textView).returnPressed(textView, textView.text);
            return self.enableReturn;
        }
    }

    if (self.outerDelegate && [self.outerDelegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)])
    {
        BOOL outerResult = [self.outerDelegate textView:textView shouldChangeTextInRange:range replacementText:text];
        if (!outerResult) return NO;
    }
    if (_maxLength == 0) return YES;
    NSInteger existedLength = textView.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = text.length;


    if ([text isEqualToString:@""])
    {
        return YES;
    }

    if (existedLength - selectedLength + replaceLength > _maxLength) {
        return NO;
    }
    NSString *tmpText = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (tmpText.length > _maxLength)
    {
        textView.text = [tmpText substringToIndex:_maxLength];
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (self.outerDelegate && [self.outerDelegate respondsToSelector:@selector(textViewDidChange:)])
    {
        [self.outerDelegate textViewDidChange:textView];
    }
    //hide holderLabel according to the content
    HTextView *textV = (HTextView *)textView;
    textV.holderLabel.hidden = textView.text.length > 0 ? YES : NO;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange
{
    if (self.outerDelegate && [self.outerDelegate respondsToSelector:@selector(textView:shouldInteractWithTextAttachment:inRange:)])
    {
        return [self.outerDelegate textView:textView shouldInteractWithTextAttachment:textAttachment
                                    inRange:characterRange];
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    if (self.outerDelegate && [self.outerDelegate respondsToSelector:@selector(textView:shouldInteractWithURL:inRange:)])
    {
        return [self.outerDelegate textView:textView
                      shouldInteractWithURL:URL
                                    inRange:characterRange];
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (self.outerDelegate && [self.outerDelegate respondsToSelector:@selector(textViewDidBeginEditing:)])
    {
        [self.outerDelegate textViewDidBeginEditing:textView];
    }
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
    [textView scrollRangeToVisible:textView.selectedRange];

    if (self.outerDelegate && [self.outerDelegate respondsToSelector:@selector(textViewDidChangeSelection:)])
    {
        [self.outerDelegate textViewDidChangeSelection:textView];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (self.outerDelegate && [textView respondsToSelector:@selector(textViewDidEndEditing:)])
    {
        [self.outerDelegate textViewDidEndEditing:textView];
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (self.outerDelegate && [self.outerDelegate respondsToSelector:@selector(textViewShouldBeginEditing:)])
    {
        return [self.outerDelegate textViewShouldBeginEditing:textView];
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if (self.outerDelegate && [self.outerDelegate respondsToSelector:@selector(textViewShouldEndEditing:)])
    {
        return [self.outerDelegate textViewShouldEndEditing:textView];
    }
    return YES;
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.outerDelegate && [scrollView respondsToSelector:@selector(scrollViewDidScroll:)])
    {
        [self.outerDelegate scrollViewDidScroll:scrollView];
    }
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    if (self.outerDelegate && [scrollView respondsToSelector:@selector(scrollViewDidZoom:)])
    {
        [self.outerDelegate scrollViewDidZoom:scrollView];
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.outerDelegate && [scrollView respondsToSelector:@selector(scrollViewWillBeginDragging:)])
    {
        [self.outerDelegate scrollViewWillBeginDragging:scrollView];
    }
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (self.outerDelegate && [scrollView respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)])
    {
        [self.outerDelegate scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.outerDelegate && [scrollView respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)])
    {
        [self.outerDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if (self.outerDelegate && [scrollView respondsToSelector:@selector(scrollViewWillBeginDecelerating:)])
    {
        [self.outerDelegate scrollViewWillBeginDecelerating:scrollView];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.outerDelegate && [scrollView respondsToSelector:@selector(scrollViewDidEndDecelerating:)])
    {
        [self.outerDelegate scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (self.outerDelegate && [scrollView respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)])
    {
        [self.outerDelegate scrollViewDidEndScrollingAnimation:scrollView];
    }
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if (self.outerDelegate && [scrollView respondsToSelector:@selector(viewForZoomingInScrollView:)])
    {
        return [self.outerDelegate viewForZoomingInScrollView:scrollView];
    }
    else return nil;
}
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
    if (self.outerDelegate && [scrollView respondsToSelector:@selector(scrollViewWillBeginZooming:withView:)])
    {
        [self.outerDelegate scrollViewWillBeginZooming:scrollView withView:view];
    }
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    if (self.outerDelegate && [scrollView respondsToSelector:@selector(scrollViewDidEndZooming:withView:atScale:)])
    {
        [self.outerDelegate scrollViewDidEndZooming:scrollView withView:view atScale:scale];
    }
}
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    if (self.outerDelegate && [scrollView respondsToSelector:@selector(scrollViewShouldScrollToTop:)])
    {
        return [self.outerDelegate scrollViewShouldScrollToTop:scrollView];
    }
    return NO;
}
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    if (self.outerDelegate && [scrollView respondsToSelector:@selector(scrollViewDidScrollToTop:)])
    {
        [self.outerDelegate scrollViewDidScrollToTop:scrollView];
    }
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
