//
//  MenuVC.m
//  HTextInput
//
//  Created by zhangchutian on 15/6/8.
//  Copyright (c) 2015年 zhangchutian. All rights reserved.
//

#import "MenuVC.h"
#import "TextFieldTest1.h"
#import "TextFieldTest2.h"
#import "TextViewTest1.h"
#import "HTextInput.h"

@interface MenuVC () <UITextViewDelegate>

@end
@implementation MenuVC
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.automaticallyAdjustsScrollViewInsets  = NO;
        self.title = @"MENU";
        __weak typeof(self) weakSelf = self;
        [self addMenu:@"MotherBoard" subTitle:@"auto creaded input view" callback:^(id sender, NSIndexPath *indexPath) {
            UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, weakSelf.view.frame.size.width, 100)];
            bg.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
            HTextView *textView = [[HTextView alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20, 100 - 20)];
            textView.layer.cornerRadius = 6;
            textView.clipsToBounds = YES;
            [bg addSubview:textView];

            HTextInputMotherBoard *superView = [HTextInputMotherBoard view];
            superView.inputAccessoryView = bg;
            superView.targetResponder = textView;

            HTextAnimationContentInsect *animation = [HTextAnimationContentInsect new];
            animation.animationView = weakSelf.tableView;


            superView.animations = @[animation];
            [superView show];
        }];

        [self addMenu:@"HTextField animation" subTitle:@"default animation on scrollView" callback:^(id sender, NSIndexPath *indexPath) {
            [weakSelf.navigationController pushViewController:[TextFieldTest1 new] animated:YES];
        }];
        [self addMenu:@"HTextField animation" subTitle:@"default animation on UIView" callback:^(id sender, NSIndexPath *indexPath) {
            [weakSelf.navigationController pushViewController:[TextFieldTest2 new] animated:YES];
        }];
        [self addMenu:@"HtextField max length" callback:^(id sender, NSIndexPath *indexPath) {
            HTextField *textField = [[HTextField alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
            textField.maxLength = 10;
            HTextInputMotherBoard *superView = [HTextInputMotherBoard view];
            superView.inputAccessoryView = textField;
            superView.targetResponder = textField;
            [superView show];
        }];
        [self addMenu:@"HtextField content insect" callback:^(id sender, NSIndexPath *indexPath) {
            HTextField *textField = [[HTextField alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
            textField.insect = UIEdgeInsetsMake(10, 30, 10, 30);
            HTextInputMotherBoard *superView = [HTextInputMotherBoard view];
            superView.inputAccessoryView = textField;
            superView.targetResponder = textField;

            HTextAnimationContentInsect *animation = [HTextAnimationContentInsect new];
            animation.animationView = weakSelf.tableView;

            superView.animations = @[animation];
            [superView show];
        }];
        [self addMenu:@"HTextView" subTitle:@"animation of a full screen textView" callback:^(id sender, id data) {
            [weakSelf.navigationController pushViewController:[TextViewTest1 new] animated:YES];
        }];
        [self addMenu:@"HTextView max length" callback:^(id sender, NSIndexPath *indexPath) {
            HTextView *textView = [[HTextView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
            textView.maxLength = 20;
            HTextInputMotherBoard *superView = [HTextInputMotherBoard view];
            superView.inputAccessoryView = textView;
            superView.targetResponder = textView;
            
            HTextAnimationContentInsect *animation = [HTextAnimationContentInsect new];
            animation.animationView = weakSelf.tableView;

            superView.animations = @[animation];
            [superView show];
        }];
        [self addMenu:@"HTextView content insect" callback:^(id sender, NSIndexPath *indexPath) {
            HTextView *textView = [[HTextView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
            textView.edgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
            HTextInputMotherBoard *superView = [HTextInputMotherBoard view];
            superView.inputAccessoryView = textView;
            superView.targetResponder = textView;
            
            HTextAnimationContentInsect *animation = [HTextAnimationContentInsect new];
            animation.animationView = weakSelf.tableView;
            superView.animations = @[animation];
            [superView show];
        }];
        [self addMenu:@"HTextView placeHolder" callback:^(id sender, NSIndexPath *indexPath) {
            HTextView *textView = [[HTextView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
            textView.placeholder = @"say something";
//            textView.placeHolderInsets = UIEdgeInsetsMake(10, 5, 0, 0);
            HTextInputMotherBoard *superView = [HTextInputMotherBoard view];
            superView.inputAccessoryView = textView;
            superView.targetResponder = textView;
            
            HTextAnimationContentInsect *animation = [HTextAnimationContentInsect new];
            animation.animationView = weakSelf.tableView;
            superView.animations = @[animation];
            [superView show];
        }];

        [self addMenu:@"animation focus" subTitle:@"set a focusView will let the focus view allways place at the to of keyboard" callback:^(id sender, NSIndexPath *indexPath) {
            HTextField *textField = [[HTextField alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
            HTextInputMotherBoard *superView = [HTextInputMotherBoard view];
            superView.inputAccessoryView = textField;
            superView.targetResponder = textField;

            HTextAnimation *animation = [HTextAnimationPosition new];
            animation.animationView = weakSelf.tableView;
            animation.focusView = [weakSelf.tableView cellForRowAtIndexPath:indexPath];
            superView.animations = @[animation];
            [superView show];
        }];

        [self addMenu:@"adjust animation distance" subTitle:@"10 more px" callback:^(id sender, NSIndexPath *indexPath) {
            HTextField *textField = [[HTextField alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
            HTextInputMotherBoard *superView = [HTextInputMotherBoard view];
            superView.inputAccessoryView = textField;
            superView.targetResponder = textField;

            HTextAnimation *animation = [HTextAnimationPosition new];
            animation.animationView = weakSelf.tableView;
            animation.focusView = [weakSelf.tableView cellForRowAtIndexPath:indexPath];
            [animation setAdjustDistanceCallback:^float(float distance){
                return distance + 10;
            }];
            superView.animations = @[animation];
            [superView show];
        }];

        [self.view addSubview:[self bottomInputBar]];
    }
    return self;
}
- (UIView *)bottomInputBar
{
    UIToolbar *back = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50)];
    back.autoresizingMask = UIViewAutoresizingFlexibleWidth;

    HTextField *textField = [[HTextField alloc] initWithFrame:CGRectMake(10, (back.frame.size.height - 30)/2, back.frame.size.width - 20, 30)];
    textField.font = [UIFont systemFontOfSize:16];
    textField.text = @"Im a input view allway in bottom";
    textField.layer.cornerRadius = 4;
    textField.backgroundColor = [UIColor whiteColor];
    textField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [back addSubview:textField];

    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    //inputbar animation
    HTextAnimationBottom *animation1 = [HTextAnimationBottom new];
    animation1.animationView = self.tableView;
    animation1.inputView = textField;
    //super view animation
    HTextAnimationPosition *animation2 = [HTextAnimationPosition new];
    animation2.animationView = back;
    animation2.inputView = textField;
    textField.animations = @[animation1, animation2];

    return back;
}
- (void)viewDidLoad
{
    UIImageView *bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg.jpg"]];
    bg.frame = self.view.bounds;
    bg.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    bg.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:bg];
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 50, 0);
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}
@end
