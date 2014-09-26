//
//  AddNoteCollectionViewCell.m
//  PresentationLayer
//
//  Created by loe on 14-9-17.
//  Copyright (c) 2014年 hainan.university. All rights reserved.
//

#import "AddNoteCollectionViewCell.h"

@interface AddNoteCollectionViewCell ()

@property (nonatomic, retain) UIImageView *imageView;

@end

@implementation AddNoteCollectionViewCell

- (void)dealloc
{
    self.imageView = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight
                         radius:CGSizeMake(LOE_NoteItem_radius, LOE_NoteItem_radius)];
        [self addSubview:self.imageView];
    }
    return self;
}

- (UIImageView *) imageView {

    if ( !_imageView ) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds)/2-15, CGRectGetHeight(self.bounds)/2-15, 30, 30)];
        _imageView.image = [UIImage imageNamed:@"write.png"];
    }
    return _imageView;

}

@end
