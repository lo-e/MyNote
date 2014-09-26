//
//  NoteCollectionViewCell.m
//  PresentationLayer
//
//  Created by loe on 14-9-14.
//  Copyright (c) 2014年 hainan.university. All rights reserved.
//

#import "NoteCollectionViewCell.h"
#import "Note.h"
#import "NoteContainerView.h"

@interface NoteCollectionViewCell ()

@property (nonatomic, retain)NoteContainerView *containerView;
@property (nonatomic, retain)UIImageView *deleteView;

@end

@implementation NoteCollectionViewCell

- (void)dealloc
{
    self.note = nil;
    self.containerView = nil;
    self.attributes = nil;
    self.deleteView = nil;
    self.indexPath = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.containerView];
    }
    return self;
}

- (NoteContainerView *)containerView {
    
    if ( !_containerView ) {
        _containerView = [[NoteContainerView alloc] initWithNote:_note radius:6];
    }
    return _containerView;
    
}

- (void) showDelete {

    if ( !_deleteView ) {
        _deleteView = [[UIImageView alloc] initWithFrame:CGRectMake((self.width-20)/2.f, (self.height-20)/2.f, 20, 20)];
        [_deleteView setImage:[UIImage imageNamed:@"delete.png"]];
        [self addSubview:_deleteView];
    }
    _deleteView.hidden = NO;

}

- (void) hideDelete {

    _deleteView.hidden = YES;

}

- (void)layoutSubviews {
    
    _containerView.frame = self.bounds;
    _containerView.note = _note;
    _containerView.range = _range;
    _containerView.attributes = _attributes;
    [_containerView setNeedsLayout];

}

@end
