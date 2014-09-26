//
//  AddSupplementView.h
//  PresentationLayer
//
//  Created by loe on 14-9-17.
//  Copyright (c) 2014年 hainan.university. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AddSupplementView;

@protocol AddSupplementViewDelegate <NSObject>

@optional
- (void)addSupplementViewDelegateTapped:(AddSupplementView *)addSupplementView;

@end

@interface AddSupplementView : UICollectionReusableView

@property (nonatomic, assign) id<AddSupplementViewDelegate> delegate;

@end
