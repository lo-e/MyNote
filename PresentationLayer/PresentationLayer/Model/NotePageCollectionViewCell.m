//
//  NotePageCollectionViewCell.m
//  PresentationLayer
//
//  Created by loe on 14-9-17.
//  Copyright (c) 2014年 hainan.university. All rights reserved.
//

#import "NotePageCollectionViewCell.h"
#import "NoteCollectionView.h"
#import "NoteCollectionViewCell.h"
#import "NoteManater.h"
#import "AddNoteCollectionViewCell.h"
#import "NoteSupplementView.h"
#import "NoteContainerView.h"
#import "DetailViewController.h"

@interface NotePageCollectionViewCell ()

@property (nonatomic, retain) NoteCollectionView *collectionView;

@end

@implementation NotePageCollectionViewCell

- (void)dealloc
{
    self.collectionView = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.collectionView];
    }
    return self;
}

- (void) setNoteIndex:(int)noteIndex {

    _noteIndex = noteIndex;
    if ( _collectionView ) {
        [_collectionView reloadData];
    }
}

- (NoteCollectionView *) collectionView {

    if ( !_collectionView ) {
        CHTCollectionViewWaterfallLayout *chtLayout = [[CHTCollectionViewWaterfallLayout alloc] init];
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        if ( orientation == UIInterfaceOrientationPortrait ) {
            chtLayout.columnCount = 2;
        }else {
            chtLayout.columnCount = 3;
        }
        chtLayout.minimumColumnSpacing = 10;
        chtLayout.minimumInteritemSpacing =10;
        chtLayout.sectionInset = UIEdgeInsetsMake(10, 5, 2, 5);
        chtLayout.headerHeight = 280.f;
        _collectionView = [[NoteCollectionView alloc] initWithFrame:self.bounds collectionViewLayout:chtLayout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [chtLayout release];
        
        //注册cell
        [_collectionView registerClass:[NoteCollectionViewCell class]
            forCellWithReuseIdentifier:Note_Cell_Identifier];
        [_collectionView registerClass:[AddNoteCollectionViewCell class]
            forCellWithReuseIdentifier:Note_AddCell_Identifier];
        //注册sectionHeader
        [_collectionView registerClass:[NoteSupplementView class]
            forSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader
                   withReuseIdentifier:Note_SectionHeader_Identifier];
    }
    return _collectionView;

}


#pragma mark - UICollectionViewDataSource-------------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [[NoteManager sharedManager] findAll].count + 1;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ( indexPath.row == 0 ) {
        AddNoteCollectionViewCell *addCell = [collectionView dequeueReusableCellWithReuseIdentifier:Note_AddCell_Identifier forIndexPath:indexPath];
        return addCell;
    }
    NoteCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:Note_Cell_Identifier forIndexPath:indexPath];
    cell.note = [[[NoteManager sharedManager] findAll] objectAtIndex:indexPath.row - 1];
    return cell;
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ( kind == CHTCollectionElementKindSectionHeader) {
        NoteSupplementView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader withReuseIdentifier:Note_SectionHeader_Identifier forIndexPath:indexPath];
        //委托处理保存被编辑或新建的Note
        DetailViewController *detailVC = (DetailViewController *)self.viewController;
        detailVC.saveDelegate = headerView;
        if ( _noteIndex == -1 ) {
            headerView.mode = NoteSupplementModeAddNote;
        }else {
            headerView.mode = NoteSupplementModePresentNote;
            headerView.note = [[[NoteManager sharedManager] findAll] objectAtIndex:_noteIndex];
        }
        [headerView setNeedsLayout];
        return headerView;
    }else {
        return nil;
    }
    
}

#pragma mark - UICollectionViewDelegate---------------
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //跳转到Note
    DetailViewController *detailVC = (DetailViewController *)collectionView.viewController;
    detailVC.currentIndex = (int)indexPath.row-1;
    [detailVC scrollToCurrentIndex];
    
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout---------------
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //由当前orientation决定width
    float width;
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if ( orientation == UIInterfaceOrientationPortrait ) {
        width = (CGRectGetWidth(self.bounds)-20)/2.0;
    }else {
        width = (CGRectGetWidth(self.bounds)-20)/3.0;
    }
    if ( indexPath.row == 0 ) {
        return CGSizeMake(width, width/3);
    }
    Note *note = [[[NoteManager sharedManager] findAll] objectAtIndex:indexPath.row - 1];
    float height = [NoteContainerView heightWithNote:note range:NSMakeRange(0, 0) attributes:nil width:width];
    return CGSizeMake(width, height);
    
}

#pragma mark - LOEScrollToTopDelegate-----------------
- (void) scrollerToTop {
    
    [_collectionView scrollRectToVisible:CGRectMake(0, 0, CGRectGetWidth(_collectionView.bounds), 20) animated:YES];
    
}

@end
