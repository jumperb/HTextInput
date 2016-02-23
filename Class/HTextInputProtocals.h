//
//  HTextInputProtocals.h
//  Baby360
//
//  Created by zhangchutian on 15/5/29.
//  Copyright (c) 2015年 zhangchutian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol HTextInputRecver <UITextInput>
- (void)setInputAccessoryView:(UIView *)inputAccessoryView;
- (void)setInputView:(UIView *)inputView;
@end

@interface UITextField (HTextInputRecver) <HTextInputRecver>
@end

@interface UITextView (HTextInputRecver) <HTextInputRecver>
@end