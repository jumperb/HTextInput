//
//  TextFieldTest2.m
//  HTextInput
//
//  Created by zhangchutian on 15/6/9.
//  Copyright (c) 2015年 zhangchutian. All rights reserved.
//

#import "TextFieldTest2.h"
#import "HTextField.h"
#import "HTextView.h"
#import "HCommon.h"

@implementation TextFieldTest2
- (void)loadView
{
    [super loadView];
    UIImageView *bg = [[UIImageView alloc] initWithImage:img(@"bg.jpg")];
    bg.frame = self.view.bounds;
    ALWAYS_FULL(bg);
    bg.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:bg];
    self.view.backgroundColor = [UIColor whiteColor];
    float y = 100;
    for (int i = 0; i < 5; i ++)
    {
        HTextField *textField = [[HTextField alloc] initWithFrame:CGRectMake(15, y, self.view.h_width - 30, 44)];
        textField.backgroundColor = [UIColor random];
        textField.placeholder = @"HTextField";
        textField.borderStyle = UITextBorderStyleRoundedRect;
        [self.view addSubview:textField];
        y += 100;
        HTextView *textView = [[HTextView alloc] initWithFrame:CGRectMake(15, y, self.view.h_width - 30, 44)];
        textView.backgroundColor = [UIColor random];
        textView.placeholder = @"HTextView";
        [self.view addSubview:textView];
        y += 100;
    }
}
@end
