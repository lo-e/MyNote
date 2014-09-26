//
//  NoteSupplementView.h
//  PresentationLayer
//
//  Created by loe on 14-9-14.
//  Copyright (c) 2014年 hainan.university. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"
@class Note;

typedef NS_ENUM(NSUInteger, NoteSupplementMode) {
    NoteSupplementModeAddNote,
    NoteSupplementModePresentNote,
};

@interface NoteSupplementView : UICollectionReusableView<UITextViewDelegate>

@property (nonatomic, retain)   Note                        *note;
@property (nonatomic, retain)   UITextView                  *contentTextView;
@property (nonatomic, assign)   NoteSupplementMode          mode;

@end
