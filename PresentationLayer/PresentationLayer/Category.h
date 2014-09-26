//
//  Category.h
//  Weibo
//  -----------自定义的类别集合------------
//  Created by loe on 14-7-30.
//  Copyright (c) 2014年 hainan.university. All rights reserved.
//

#import <Foundation/Foundation.h>

//有关视图frame各种属性的快捷访问
@interface UIView (FramGeometry)

@property CGPoint origin;
@property CGSize size;

@property CGFloat height;
@property CGFloat width;

@property CGFloat top;
@property CGFloat left;

@property CGFloat bottom;
@property CGFloat right;

@end

//视图所在的视图控制器
@interface UIView (respond)

- (UIViewController *)viewController;

@end

//视图形状
@interface UIView (shape)

- (void)setRoundedCorners:(UIRectCorner)coners radius:(CGSize)radiuses;

@end

#pragma mark - For_Project-------------
@interface NSString (note)

+ (NSString *) stringWithDate:(NSDate *)date;

@end
