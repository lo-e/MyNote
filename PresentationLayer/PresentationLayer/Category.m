//
//  Category.m
//  Weibo
//
//  Created by loe on 14-7-30.
//  Copyright (c) 2014年 hainan.university. All rights reserved.
//

#import "Category.h"

@implementation UIView (FramGeometry)

- (CGPoint) origin {

    CGPoint origin = self.frame.origin;
    return origin;

}

- (void) setOrigin:(CGPoint)origin {

    CGRect newFrame = self.frame;
    newFrame.origin = origin;
    self.frame = newFrame;

}

- (CGSize) size {

    CGSize size = self.frame.size;
    return size;

}

- (void) setSize:(CGSize)size {

    CGRect newFrame = self.frame;
    newFrame.size = size;
    self.frame = newFrame;

}

- (CGFloat) height {

    CGFloat height = self.frame.size.height;
    return height;

}

- (void) setHeight:(CGFloat)height {

    CGRect newFrame = self.frame;
    newFrame.size.height = height;
    self.frame = newFrame;
    
}

- (CGFloat) width {
    
    CGFloat width = self.frame.size.width;
    return width;
    
}

- (void) setWidth:(CGFloat)width {
    
    CGRect newFrame = self.frame;
    newFrame.size.width = width;
    self.frame = newFrame;
    
}

- (CGFloat) top {
    
    CGFloat top = self.frame.origin.y;
    return top;
    
}

- (void) setTop:(CGFloat)top {
    
    CGRect newFrame = self.frame;
    newFrame.origin.y = top;
    self.frame = newFrame;
    
}

- (CGFloat) bottom {

    CGFloat bottom = self.frame.origin.y + self.height;
    return bottom;

}

- (void) setBottom:(CGFloat)bottom {

    CGRect newFrame = self.frame;
    newFrame.origin.y = bottom - self.height;
    self.frame = newFrame;

}

- (CGFloat) left {
    
    CGFloat left = self.frame.origin.x;
    return left;
    
}

- (void) setLeft:(CGFloat)left {

    CGRect newFrame = self.frame;
    newFrame.origin.x = left;
    self.frame = newFrame;

}

- (CGFloat) right {

    CGFloat right = self.frame.origin.x + self.width;
    return right;

}

- (void) setRight:(CGFloat)right {

    CGRect newFrame = self.frame;
    newFrame.origin.x = right - self.width;
    self.frame = newFrame;

}

@end

@implementation UIView (respond)

- (UIViewController *)viewController {

    UIResponder *responder = [self nextResponder];
    while ( ![responder isKindOfClass:[UIViewController class]] ) {
        responder = [responder nextResponder];
    }
    return (UIViewController *)responder;

}

@end

@implementation UIView (shape)

- (void)setRoundedCorners:(UIRectCorner)coners radius:(CGSize)radiuses {
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:coners cornerRadii:radiuses];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = bezierPath.CGPath;
    self.layer.mask = maskLayer;
    
}

@end

#pragma mark - For_Project-------------
@implementation NSString (note)

+ (NSString *) stringWithDate:(NSDate *)date {
    
    NSDate *now = [NSDate date];
    NSString *string = nil;
    NSInteger timeInterVal = [now timeIntervalSinceDate:date];
    if ( timeInterVal <= 60 ) {
        string = [NSString stringWithFormat:@"刚刚"];
    }else if ( timeInterVal <= 60*60) {
        string = [NSString stringWithFormat:@"%ld分钟前",timeInterVal/60];
    }else if ( timeInterVal <= 60*60*24 ) {
        string = [NSString stringWithFormat:@"%ld小时前",timeInterVal/3600];
    }else if ( timeInterVal <= 60*60*48 ) {
        string = @"昨天";
    }else if ( timeInterVal <= 60*60*72 ) {
        string = @"前天";
    }else {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd/yyyy"];
        string = [dateFormatter stringFromDate:date];
        [dateFormatter release];
    }
    return string;
    
}

@end