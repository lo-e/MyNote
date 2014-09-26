//
//  NoteCollectionView.m
//  PresentationLayer
//
//  Created by loe on 14-9-17.
//  Copyright (c) 2014年 hainan.university. All rights reserved.
//

#import "NoteCollectionView.h"

@implementation NoteCollectionView

- (id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
//        self.backgroundColor = [UIColor colorWithRed:0.9 green:0.91 blue:0.9 alpha:1];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void) awakeFromNib {

//    self.backgroundColor = [UIColor colorWithRed:0.9 green:0.91 blue:0.9 alpha:1];

}

@end
