//
//  TextFieldTest1.m
//  HTextInput
//
//  Created by zhangchutian on 15/6/9.
//  Copyright (c) 2015年 zhangchutian. All rights reserved.
//

#import "TextFieldTest1.h"
#import "HTextField.h"
#import "HTextView.h"
#import <HCommon.h>

@implementation TextFieldTest1
- (void)loadView
{
    [super loadView];
    UIImageView *bg = [[UIImageView alloc] initWithImage:img(@"bg.jpg")];
    bg.frame = self.view.bounds;
    ALWAYS_FULL(bg);
    bg.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:bg];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.contentSize = CGSizeMake(self.view.width, self.view.height * 2);
    ALWAYS_FULL(_scrollView);
    [self.view addSubview:_scrollView];
    float y = 100;
    for (int i = 0; i < 3; i ++)
    {
        HTextField *textField = [[HTextField alloc] initWithFrame:CGRectMake(15, y, self.view.width - 30, 44)];
        textField.backgroundColor = [UIColor random];
        textField.placeholder = @"HTextField";
        textField.borderStyle = UITextBorderStyleRoundedRect;
        [_scrollView addSubview:textField];
        y += 100;
        HTextView *textView = [[HTextView alloc] initWithFrame:CGRectMake(15, y, self.view.width - 30, 44)];
        textView.backgroundColor = [UIColor random];
        textView.placeholder = @"HTextView";
        [_scrollView addSubview:textView];
        y += 100;
    }
}
@end
