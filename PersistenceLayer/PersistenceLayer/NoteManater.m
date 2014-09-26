//
//  NoteManater.m
//  MyNote
//
//  Created by loe on 14-8-25.
//  Copyright (c) 2014年 hainan.university. All rights reserved.
//

#import "NoteManater.h"

@interface NoteManager ()

- (void) creatDatabaseIfNeeded;

@end

@implementation NoteManager
static NoteManager *sharedManager = nil;

- (void)dealloc
{
    [super dealloc];
}

+ (NoteManager *) sharedManager {

    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedManager = [[NoteManager alloc] init];
        [sharedManager creatDatabaseIfNeeded];
    });
    return sharedManager;

}

- (void) creatNote:(Note *)note {

    NSMutableArray *notes = [self findAll];
    [notes insertObject:note atIndex:0];
    
    [self archiveNotes:notes];

}

- (void) removeNote:(Note *)note {

    NSMutableArray *notes = [self findAll];
    //移除note
    for ( Note *theNote in notes ) {
        if ( [theNote.date isEqualToDate:note.date] ) {
            [notes removeObject:theNote];
            break;
        }
    }
    [self archiveNotes:notes];
    return;

}

- (void) modifyNote:(Note *)note withNote:(Note *)newNote {

    NSMutableArray *notes = [self findAll];
    //删除旧note，添加新note
    for ( Note *theNote in notes ) {
        if ( [theNote.date isEqualToDate:note.date] ) {
            [notes removeObject:theNote];
            [notes insertObject:newNote atIndex:0];
            break;
        }
    }
    [self archiveNotes:notes];
    return;

}
- (NSMutableArray *) findAll {

    NSString *path = [self databaseFilePath];
    NSMutableData *data = [[[NSMutableData alloc] initWithContentsOfFile:path] autorelease];
    NSKeyedUnarchiver *unarchiver = [[[NSKeyedUnarchiver alloc] initForReadingWithData:data] autorelease];
    NSMutableArray *notes = [unarchiver decodeObjectForKey:Archive_Notes_Key];
    return notes;

}

- (Note *) findByID:(Note *)note {

    NSMutableArray *nots = [self findAll];
    for ( Note *theNote in nots ) {
        if ( [theNote.date isEqualToDate:note.date] ) {
            return theNote;
        }
    }
    return nil;
    
}

//如果数据文件不存在，创建新的数据文件，初始化有两条note
- (void) creatDatabaseIfNeeded {

    NSString *path =  [self databaseFilePath];
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL isDirectory = NO;
    BOOL fileExist = [manager fileExistsAtPath:path isDirectory:&isDirectory];
    if ( !fileExist ) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy/MM/dd hh:mm:ss"];
        
        NSDate *date1 = [formatter dateFromString:@"2013/6/6 6:06:06"];
        Note *note1 = [[Note alloc] init];
        note1.date = date1;
        note1.content = @"欢迎使用MyNote";
        
        NSDate *date2 = [formatter dateFromString:@"2014/6/6 6:06:06"];
        Note *note2 = [[Note alloc] init];
        note2.date = date2;
        note2.content = @"记录你身边的美好";
        [formatter release];
        
        NSMutableArray *notes = [NSMutableArray array];
        [notes addObject:note1];
        [notes addObject:note2];
        [note1 release];
        [note2 release];
        
        [self archiveNotes:notes];
    }

}

//返回数据文件路径：documents/notes.plist
- (NSString *) databaseFilePath {

    NSString *path = NSHomeDirectory();
    path = [path stringByAppendingPathComponent:@"Documents/notes.plist"];
    return path;

}

//归档保存Notes到documents目录下
- (void) archiveNotes:(NSMutableArray *)notes {

    NSMutableData *archiveData = [NSMutableData data];
    NSKeyedArchiver *archiver = [[[NSKeyedArchiver alloc] initForWritingWithMutableData:archiveData] autorelease];
    [archiver encodeObject:notes forKey:Archive_Notes_Key];
    [archiver finishEncoding];
    
    NSString *path =  [self databaseFilePath];
    [archiveData writeToFile:path atomically:YES];

}

@end
