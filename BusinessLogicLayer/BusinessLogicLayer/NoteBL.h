//
//  NoteBL.h
//  MyNote
//
//  Created by loe on 14-8-25.
//  Copyright (c) 2014年 hainan.university. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Note;

@interface NoteBL : NSObject

- (NSArray *) createNote:(Note *)note;
- (NSArray *) removeNote:(Note *)note;
- (NSArray *) findAll;

@end
