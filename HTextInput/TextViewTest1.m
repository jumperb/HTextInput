//
//  TextViewTest.m
//  HTextInput
//
//  Created by zhangchutian on 15/6/9.
//  Copyright (c) 2015年 zhangchutian. All rights reserved.
//

#import "TextViewTest1.h"
#import "HTextInput.h"

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
    UIImageView *bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg.jpg"]];
    bg.frame = self.view.bounds;
    bg.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    bg.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:bg];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"OK" style:UIBarButtonItemStylePlain target:self action:@selector(hideKeyboard)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    HTextView *textView = [[HTextView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
    textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;;
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
