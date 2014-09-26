//
//  NoteBL.m
//  MyNote
//
//  Created by loe on 14-8-25.
//  Copyright (c) 2014年 hainan.university. All rights reserved.
//

#import "NoteBL.h"
#import "NoteManater.h"

@implementation NoteBL

- (NSArray *) createNote:(Note *)note {

    NoteManager *manager = [NoteManager sharedManager];
    [manager creatNote:note];
    return [manager findAll];

}

- (NSArray *) removeNote:(Note *)note {

    NoteManager *manager = [NoteManager sharedManager];
    [manager removeNote:note];
    return [manager findAll];

}

- (NSArray *) findAll {

    NoteManager *manager = [NoteManager sharedManager];
    return [manager findAll];

}

@end
