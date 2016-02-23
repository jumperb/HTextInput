//
//  HTextSupport.h
//  HTextInput
//
//  Created by zhangchutian on 15/6/9.
//  Copyright (c) 2015年 zhangchutian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HTextSupport : NSObject
+ (UIScrollView *)anyScrollViewAsSuperView:(UIView *)view;
+ (UIView *)animationSuperView:(UIView *)view;
@end
