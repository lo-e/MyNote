//
//  NoteManater.h
//  MyNote
//
//  Created by loe on 14-8-25.
//  Copyright (c) 2014年 hainan.university. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Note.h"

@interface NoteManager : NSObject

+ (NoteManager *) sharedManager;
- (void) creatNote:(Note *)note;
- (void) removeNote:(Note *)note;
- (void) modifyNote:(Note *)note withNote:(Note *)newNote;
- (NSMutableArray *) findAll;
- (Note *) findByID:(Note *)note;

@end
