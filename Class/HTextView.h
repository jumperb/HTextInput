//
//  HTextView.h
//  HTextInput
//
//  Created by camera360 on 15/6/8.
//  Copyright (c) 2015年 zhangchutian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTextAnimation.h"
@interface HTextView : UITextView

@property (nonatomic) CGFloat maxLength;
@property (nonatomic) UIEdgeInsets edgeInsets;
@property (nonatomic) NSString *placeholder;
@property (nonatomic) UIEdgeInsets placeHolderInsets;
//if you did not set animations, there is a default animation according to view type
@property (nonatomic) NSArray *animations;

#pragma mark - protected
@property (nonatomic, weak) UIView *motherBoard;

@property (nonatomic, strong) HTAAdjustDistanceBlock adjustDistanceCallback;

@property (nonatomic, strong) callback returnPressed;
@end
