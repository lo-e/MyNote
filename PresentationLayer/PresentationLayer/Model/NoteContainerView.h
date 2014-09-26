//
//  NoteContainerView.h
//  PresentationLayer
//
//  Created by loe on 14-9-14.
//  Copyright (c) 2014年 hainan.university. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Note;

@interface NoteContainerView : UIView

@property (nonatomic, retain) Note *note;
@property (nonatomic, assign) NSRange range;
@property (nonatomic, assign) NSDictionary *attributes;
@property (nonatomic, assign) float radius;
- (id) initWithNote:(Note *)note radius:(float)radius;
+ (float) heightWithNote:(Note *)note range:(NSRange)range attributes:(NSDictionary *)attribues width:(float)width;

@end
