//
//  NoteCollectionView.h
//  PresentationLayer
//
//  Created by loe on 14-9-17.
//  Copyright (c) 2014年 hainan.university. All rights reserved.
//

#import "BaseCollectionView.h"
@class NoteCollectionView;

@protocol NoteCollectionViewDelegate <NSObject>

- (void)noteCollectionView:(NoteCollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface NoteCollectionView : BaseCollectionView

@property (nonatomic, assign) id<NoteCollectionViewDelegate> noteDelegate;

@end
