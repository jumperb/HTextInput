//
//  TextFieldTest2.m
//  HTextInput
//
//  Created by zhangchutian on 15/6/9.
//  Copyright (c) 2015年 zhangchutian. All rights reserved.
//

#import "TextFieldTest2.h"
#import "HTextInput.h"

@implementation TextFieldTest2
- (void)loadView
{
    [super loadView];
    UIImageView *bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg.jpg"]];
    bg.frame = self.view.bounds;
    bg.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    bg.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:bg];
    self.view.backgroundColor = [UIColor whiteColor];
    float y = 100;
    for (int i = 0; i < 5; i ++)
    {
        HTextField *textField = [[HTextField alloc] initWithFrame:CGRectMake(15, y, self.view.frame.size.width - 30, 44)];
        textField.backgroundColor = [self randomColor];
        textField.placeholder = @"HTextField";
        textField.borderStyle = UITextBorderStyleRoundedRect;
        [self.view addSubview:textField];
        y += 100;
        HTextView *textView = [[HTextView alloc] initWithFrame:CGRectMake(15, y, self.view.frame.size.width - 30, 44)];
        textView.backgroundColor = [self randomColor];
        textView.placeholder = @"HTextView";
        [self.view addSubview:textView];
        y += 100;
    }
}
- (UIColor *)randomColor
{
    return [UIColor colorWithRed:(arc4random()%256)*1.0/256 green:(arc4random()%256)*1.0/256 blue:(arc4random()%256)*1.0/256 alpha:1];
}
@end
