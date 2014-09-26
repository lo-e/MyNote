//
//  Note.m
//  MyNote
//
//  Created by loe on 14-8-25.
//  Copyright (c) 2014年 hainan.university. All rights reserved.
//

#import "Note.h"

@implementation Note

- (void)dealloc
{
    self.content = nil;
    self.date = nil;
    [super dealloc];
}

- (id) initWithContent:(NSString *)content andDate:(NSDate *)date {

    if ( self = [super init] ) {
        self.date = date;
        self.content = content;
    }
    return self;

}

#pragma mark - NSCopy-------------
- (void)encodeWithCoder:(NSCoder *)aCoder {

    [aCoder encodeObject:_date forKey:@"date"];
    [aCoder encodeObject:_content forKey:@"content"];

}

- (id)initWithCoder:(NSCoder *)aDecoder {

    if ( self = [super init] ) {
        self.date = [aDecoder decodeObjectForKey:@"date"];
        self.content = [aDecoder decodeObjectForKey:@"content"];
    }
    return self;

}

@end
