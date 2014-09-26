//
//  PersistenceLayerTests.m
//  PersistenceLayerTests
//
//  Created by loe on 14-8-29.
//  Copyright (c) 2014年 hainan.university. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Note.h"
#import "NoteManater.h"

@interface PersistenceLayerTests : XCTestCase

@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NoteManager *noteManager;
@property (nonatomic, strong) NSString *theContent;
@property (nonatomic, strong) NSDate *theDate;

@end

@implementation PersistenceLayerTests

- (void)dealloc
{
    self.dateFormatter = nil;
    self.noteManager = nil;
    self.theContent = nil;
    self.theDate = nil;
    [super dealloc];
}

- (void)setUp
{
    
    [super setUp];
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyyy/MM/dd hh:mm:ss"];
    self.dateFormatter = dateFormatter;
    self.noteManager = [NoteManager sharedManager];
    self.theDate = [dateFormatter dateFromString:@"2014-09-06 06:06:06"];
    self.theContent = @"正在测试数据持久层";

}

- (void)tearDown
{
    self.dateFormatter = nil;
    self.noteManager = nil;
    [super tearDown];
}

- (void) testCreate {
    
    Note *theNote = [[Note alloc] init];
    theNote.date = self.theDate;
    theNote.content = self.theContent;
    [self.noteManager creatNote:theNote];
    XCTAssertNil(nil, @"hh");
    
}

@end
