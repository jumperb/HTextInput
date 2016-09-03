//
//  HTextAnimation.h
//  Baby360
//
//  Created by zhangchutian on 15/6/5.
//  Copyright (c) 2015年 zhangchutian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTextInputProtocals.h"
#import "HCommonBlock.h"

typedef float (^HTAAdjustDistanceBlock)(float distance);

@interface HTextAnimation : NSObject

//which view do the animation
@property (nonatomic, weak) UIView *animationView;
//what view is on focus when keyborad is showing, the focus view's bottom is allways visiable
@property (nonatomic, weak) UIView *focusView;
//if focus view is over top of the keyboard , should it animate down? default is NO
@property (nonatomic) BOOL alwaysAnimation;
//animation duration
@property (nonatomic) float duration;
//input object
@property (nonatomic, weak) UIResponder<HTextInputRecver> *inputView;
//called when keyboard did show
@property (nonatomic, strong) simple_callback keyboardDidShow;
//called when keyboard did dismiss
@property (nonatomic, strong) simple_callback keyboardDidDismiss;
//called when keyboard will change, include show, dismiss, frame change, return the keyboard height is block
@property (nonatomic, strong) simple_callback animationWillBegin;
//called when keyboard did change, include show, dismiss, frame change, return the keyboard height is block
@property (nonatomic, strong) simple_callback animationDidEnd;
//you can adjust the animation distance in this callback
@property (nonatomic, strong) HTAAdjustDistanceBlock adjustDistanceCallback;
//indecate the keyboard dismiss animation finish
@property (nonatomic, assign) BOOL isKeyboardHiddenFinish;


#pragma mark - protected
- (void)addkeyBoardObserver;
- (void)removeKeyboardObserver;

@property (nonatomic) BOOL isAnimating;

@property (nonatomic) id orignalAnimationViewProperty;
@property (nonatomic) id orignalAnimationViewProperty2;
@property (nonatomic) NSNumber *orignalFocusPositionY;

//record current states
- (void)recordAnimationStates;
//set to target states
- (void)setAnimationEndStatesWithDistance:(CGFloat)distance;
//recover to orignal states
- (void)recoverAnimationStates;
@end


@interface HSwipeGestureRecognizer : UISwipeGestureRecognizer
@property (nonatomic) id userInfo;
@end
