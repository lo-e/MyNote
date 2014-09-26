//
//  DetailViewController.h
//  PresentationLayer
//
//  Created by loe on 14-9-17.
//  Copyright (c) 2014年 hainan.university. All rights reserved.
//

#import "BaseViewController.h"
#import "CHTCollectionViewWaterfallLayout.h"

@interface DetailViewController : BaseViewController<UICollectionViewDataSource,UICollectionViewDelegate,CHTCollectionViewDelegateWaterfallLayout>

@property (nonatomic, assign) int currentIndex;
- (void) beginEditNewNote;
- (void) cancelEditNewNote;

@end
