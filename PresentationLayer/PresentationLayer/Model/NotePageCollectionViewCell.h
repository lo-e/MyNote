//
//  NotePageCollectionViewCell.h
//  PresentationLayer
//
//  Created by loe on 14-9-17.
//  Copyright (c) 2014年 hainan.university. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHTCollectionViewWaterfallLayout.h"
#import "DetailViewController.h"

@interface NotePageCollectionViewCell : UICollectionViewCell<UICollectionViewDataSource,UICollectionViewDelegate,CHTCollectionViewDelegateWaterfallLayout,LOEScrollToTopDelegate>

@property (nonatomic, assign) int noteIndex;

@end
