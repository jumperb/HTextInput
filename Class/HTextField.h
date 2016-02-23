//
//  HTextField.h
//  HTextInput
//
//  Created by camera360 on 15/6/8.
//  Copyright (c) 2015年 zhangchutian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTextAnimation.h"

@interface HTextField : UITextField
@property (nonatomic, assign) CGFloat maxLength;
@property (nonatomic, assign) UIEdgeInsets insect;
//if you did not set animations, there is a default animation according to view type
@property (nonatomic, strong) NSArray *animations;

#pragma mark - protected
@property (nonatomic, weak) UIView *motherBoard;


@property (nonatomic, strong) HTAAdjustDistanceBlock adjustDistanceCallback;

@property (nonatomic, strong) callback returnPressed;
@end
