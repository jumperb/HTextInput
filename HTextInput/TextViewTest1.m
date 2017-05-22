//
//  TextViewTest.m
//  HTextInput
//
//  Created by zhangchutian on 15/6/9.
//  Copyright (c) 2015年 zhangchutian. All rights reserved.
//

#import "TextViewTest1.h"
#import "HTextView.h"
#import "HCommon.h"

@interface TextViewTest1 ()
@property (nonatomic) UITextView *textView;
@end

@implementation TextViewTest1
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}
- (void)loadView
{
    [super loadView];
    UIImageView *bg = [[UIImageView alloc] initWithImage:img(@"bg.jpg")];
    bg.frame = self.view.bounds;
    ALWAYS_FULL(bg);
    bg.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:bg];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"OK" style:UIBarButtonItemStylePlain target:self action:@selector(hideKeyboard)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    HTextView *textView = [[HTextView alloc] initWithFrame:CGRectMake(0, 64, self.view.h_width, self.view.h_height - 64)];
    ALWAYS_FULL(textView);
    _textView = textView;
    _textView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    textView.font = [UIFont systemFontOfSize:18];
    textView.text = ({
        NSMutableString *str = [NSMutableString new];
        for (int row = 0; row < 40; row ++)
        {
            for (int i = 0; i < 30; i ++)
            {
                [str appendFormat:@"%c", 'a' + arc4random()%('z' - 'A')];
            }
            [str appendString:@"\n"];
        }
        str;
    });
    [self.view addSubview:textView];
}

- (void)hideKeyboard
{
    [_textView resignFirstResponder];
}
@end
