//
//  StartViewController.h
//  PresentationLayer
//
//  Created by loe on 14-9-14.
//  Copyright (c) 2014年 hainan.university. All rights reserved.
//

#import "BaseViewController.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "AddSupplementView.h"

@interface StartViewController : BaseViewController<UICollectionViewDataSource,UICollectionViewDelegate,CHTCollectionViewDelegateWaterfallLayout,AddSupplementViewDelegate,UISearchBarDelegate>

@end
