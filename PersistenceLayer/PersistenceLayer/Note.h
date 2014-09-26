//
//  Note.h
//  MyNote
//
//  Created by loe on 14-8-25.
//  Copyright (c) 2014年 hainan.university. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Note : NSObject<NSCoding>

@property (retain, nonatomic) NSDate *date;
@property (copy, nonatomic) NSString *content;

- (id) initWithContent:(NSString *)content andDate:(NSDate *)date;

@end
