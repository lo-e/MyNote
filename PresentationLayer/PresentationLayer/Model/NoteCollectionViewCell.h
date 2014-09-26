//
//  NoteCollectionViewCell.h
//  PresentationLayer
//
//  Created by loe on 14-9-14.
//  Copyright (c) 2014年 hainan.university. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Note;
@class NoteCollectionViewCell;

@interface NoteCollectionViewCell : UICollectionViewCell

@property (nonatomic, retain) Note                                      *note;
@property (nonatomic, assign) NSRange                                   range;
@property (nonatomic, retain) NSDictionary                              *attributes;
@property (nonatomic, retain) NSIndexPath                               *indexPath;

- (void) showDelete;
- (void) hideDelete;

@end
