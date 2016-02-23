//
//  HTextInputMotherBoard.h
//  HTextInput
//
//  Created by zhangchutian on 15/5/27.
//  Copyright (c) 2015年 zhangchutian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTextInputProtocals.h"
#import "HTextAnimation.h"

@interface HTextInputMotherBoard : UIButton

//get motherboard object, it has been added to window
+ (HTextInputMotherBoard *)view;
+ (HTextInputMotherBoard *)currentMotherBoard;

//inputAccessoryView: you could set a textfield or textView, or you can set a custom view contain a inputView
@property (nonatomic, readwrite) UIView *inputAccessoryView;
//the real responder to get the keyboard focuse ，usually it is UITextField or UITextView
@property (nonatomic, strong) UIResponder<HTextInputRecver> *targetResponder;
//called when show animation finish, return the inputAccessoryView
@property (nonatomic, strong) callback didShow;
//消失回调data返回nextResponder
//called when dismiss animation finish, retuen the nextResponder
@property (nonatomic, strong) callback willDismiss;
//called when resign responder
@property (nonatomic, strong) callback didResignResponder;
//animations
@property (nonatomic, strong) NSArray *animations;


- (void)show;
- (void)dismiss;
@end

