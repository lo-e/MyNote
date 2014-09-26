//
//  StartViewController.m
//  PresentationLayer
//
//  Created by loe on 14-9-14.
//  Copyright (c) 2014年 hainan.university. All rights reserved.
//

#import "StartViewController.h"
#import "NoteManater.h"
#import "NoteCollectionView.h"
#import "NoteContainerView.h"
#import "NoteSupplementView.h"
#import "DetailViewController.h"
#import <CoreData/CoreData.h>
#import "NoteCollectionViewCell.h"
#import <AudioToolbox/AudioToolbox.h>

#define kAddViewHeight 40.f
typedef NS_ENUM(NSUInteger, LOENotePresentationMode) {
    LOENotePresentationModePresent,
    LOENotePresentationModeSearch,
    LOENotePresentationModeEdit
};

@interface StartViewController ()

@property (retain, nonatomic) NoteCollectionView *collectionView;
@property (assign, nonatomic) LOENotePresentationMode mode;
@property (retain, nonatomic) AddSupplementView *addView;
@property (retain, nonatomic) UISearchBar *searchBar;
@property (retain, nonatomic) NSMutableArray *noteData;
@property (retain, nonatomic) UIButton *editButton;
@property (retain, nonatomic) UIButton *searchButton;
@property (assign, nonatomic) BOOL isSearch;

@end

@implementation StartViewController

- (void)dealloc {
    
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.collectionView = nil;
    self.addView = nil;
    self.searchBar = nil;
    self.noteData = nil;
    self.editButton = nil;
    [super dealloc];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"MyNote";
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.addView];
    [self addSearchItem];
    self.mode = LOENotePresentationModePresent;
    
    //监听键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

- (void) viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    [self refreshData];
    
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {

    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self prepareForOrientation:toInterfaceOrientation];

}

- (void) refreshData {

    if ( _mode == LOENotePresentationModeSearch ) {
        [self searchBar:_searchBar textDidChange:_searchBar.text];
    }else {
        self.noteData = [[NoteManager sharedManager] findAll];
        [_collectionView reloadData];
    }
    
}

- (NoteCollectionView *) collectionView {

    if ( !_collectionView ) {
        CHTCollectionViewWaterfallLayout *chtLayout = [[CHTCollectionViewWaterfallLayout alloc] init];
        chtLayout.minimumColumnSpacing = 10;
        chtLayout.minimumInteritemSpacing =5;
        chtLayout.sectionInset = UIEdgeInsetsMake(5, 5, 2, 5);
        _collectionView = [[NoteCollectionView alloc] initWithFrame:CGRectMake(0, self.addView.bottom, self.view.width, self.view.height-self.navBar.height-self.addView.height) collectionViewLayout:chtLayout];
        [chtLayout release];
        
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        //注册cell
        [_collectionView registerClass:[NoteCollectionViewCell class]
            forCellWithReuseIdentifier:Note_Cell_Identifier];
    }
    return _collectionView;

}


- (AddSupplementView *) addView {

    if ( !_addView ) {
        _addView = [[AddSupplementView alloc] initWithFrame:CGRectMake(0, self.navBar.bottom, CGRectGetWidth(self.view.bounds), kAddViewHeight)];
        _addView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _addView.delegate = self;
        _addView.backgroundColor = [UIColor clearColor];
    }
    return _addView;
    
}

- (UISearchBar *) searchBar {

    if ( !_searchBar ) {
        CGFloat top;
        if ( self.navBar.height == 64 ) {
            top = 32;
        }else {
            top = 12;
        }
        CGFloat width;
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        if ( orientation == UIInterfaceOrientationPortrait ) {
            width = self.view.width*3.0/4.0;
        }else {
            width = self.view.width*4.0/5.0;
        }
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(self.view.width, top, width, 20)];
        _searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
        [_searchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"searchBar.png"]
                                         forState:UIControlStateNormal];
        _searchBar.placeholder = @"输入关键字";
        _searchBar.delegate = self;
        [self.navBar addSubview:_searchBar];
    }
    return _searchBar;

}

- (UIButton *) editButton {

    if ( !_editButton ) {
        _editButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        _editButton.frame = CGRectMake(0, 0, 30, 30);
        NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"完成" attributes:@{NSForegroundColorAttributeName:[UIColor redColor]}];
        [_editButton setAttributedTitle:title forState:UIControlStateNormal];
        _editButton.titleLabel.font = [UIFont systemFontOfSize:12];
        _editButton.hidden = YES;
        [_editButton addTarget:self action:@selector(doneEdit:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithCustomView:_editButton];
        self.navItem.leftBarButtonItem = editItem;
        [editItem release];
    }
    return _editButton;

}

- (void) setMode:(LOENotePresentationMode)mode {
    
    _mode = mode;
    if ( _mode == LOENotePresentationModeEdit ) {
        _searchButton.enabled = NO;
        self.editButton.hidden = NO;
    }else {
        self.noteData = [[NoteManager sharedManager] findAll];
        //切换模式后刷新collectionView
        [_collectionView reloadData];
    }
    [_collectionView reloadData];
    
}

//添加导航栏搜索Item
- (void) addSearchItem {

    _searchButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _searchButton.frame = CGRectMake(0, 0, 20, 16);
    [_searchButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    _searchButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [_searchButton setImage:[UIImage imageNamed:@"search.png"] forState:UIControlStateNormal];
    [_searchButton addTarget:self action:@selector(searchTap:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithCustomView:_searchButton];
    self.navItem.rightBarButtonItem = searchItem;
    [searchItem release];

}

- (void) longPressed:(UILongPressGestureRecognizer *)gesture {

    self.mode = LOENotePresentationModeEdit;
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);

}

- (void) doneEdit:(UIButton *)editButton {

    _searchButton.enabled = YES;
    self.editButton.hidden = YES;
    self.mode = LOENotePresentationModePresent;

}

- (void) searchTap:(UIButton *)button {
    
    if ( !_isSearch ) {
        _isSearch = YES;
        _editButton.hidden = YES;
        self.view.backgroundColor = [UIColor grayColor];
        //清除title
        self.navItem.titleView = nil;
        //更换mode
        self.mode = LOENotePresentationModeSearch;
        //隐藏addView
        [self hideAddView];
        //动画显示搜索栏
        [UIView animateWithDuration:0.3 animations:^{
            UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
            if ( orientation == UIInterfaceOrientationPortrait ) {
                self.searchBar.transform = CGAffineTransformTranslate(_searchBar.transform, -(_searchBar.width+50), 0);
            }else {
                self.searchBar.transform = CGAffineTransformTranslate(_searchBar.transform, -(_searchBar.width+60), 0);
            }
            
        } completion:^(BOOL finished) {
            //打开键盘
            [self.searchBar becomeFirstResponder];
            
        }];
        //显示’取消‘
        button.size = CGSizeMake(30, 30);
        [button setImage:nil forState:UIControlStateNormal];
        [button setTitle:@"取消" forState:UIControlStateNormal];
    }else {
        _isSearch = NO;
        self.view.backgroundColor = [UIColor colorWithRed:0.9 green:0.91 blue:0.9 alpha:1];
        //更换mode
        self.mode = LOENotePresentationModePresent;
        self.searchBar.text = @"";
        //收回键盘
        [self.searchBar resignFirstResponder];
        //显示title
        self.title = @"MyNote";
        //显示addView
        [self showAddView];
        //动画退出搜索栏
        [UIView animateWithDuration:0.6 animations:^{
            self.searchBar.alpha = 0.f;
        } completion:^(BOOL finished) {
            [self.searchBar removeFromSuperview];
            self.searchBar = nil;
        }];
        //显示搜索图标
        button.size = CGSizeMake(20, 16);
        [button setImage:[UIImage imageNamed:@"search.png"] forState:UIControlStateNormal];
        [button setTitle:nil forState:UIControlStateNormal];
    }

}

- (void) showAddView {

    [UIView animateWithDuration:0.6 animations:^{
        _addView.alpha = 1.f;
        //collectionView的top改变，height也需要改变，由键盘的位置而定
        _collectionView.top += _addView.height;
    }];
    
}

- (void) hideAddView {
    
    [UIView animateWithDuration:0.6 animations:^{
        _addView.alpha = 0.f;
        _collectionView.top -= _addView.height;
    }];
    

}

- (void) prepareForOrientation:(UIInterfaceOrientation)orientation {

    CHTCollectionViewWaterfallLayout *chtLayout = (CHTCollectionViewWaterfallLayout *)[_collectionView collectionViewLayout];
    if ( orientation == UIInterfaceOrientationPortrait ) {
        self.navBar.height = 64;
        self.collectionView.height = self.view.height-self.navBar.height-self.addView.height;
        chtLayout.columnCount = 2;
    }else {
        self.navBar.height = 44;
        self.collectionView.height = self.view.height-self.navBar.height-self.addView.height;
        chtLayout.columnCount = 3;
    }
    self.addView.top = self.navBar.bottom;
    if ( _isSearch ) {
        self.collectionView.top = self.navBar.bottom;
    }else {
        self.collectionView.top = self.addView.bottom;
    }
    
    
}

- (void) keyboardWillShow:(NSNotification *)notification {
    
    CGRect rect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat sub = rect.origin.y - _collectionView.bottom;
    if ( sub > 0 ) {
        _collectionView.height -= sub;
    }else {
        _collectionView.height += sub;
    }
    
}

- (void) keyboardWillHide:(NSNotification *)notification {
    
    CGFloat originHeight = self.view.height-self.navBar.height-kAddViewHeight;
    _collectionView.height = originHeight;
    
}

#pragma mark - UICollectionViewDataSource-------------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.noteData.count;

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    NoteCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:Note_Cell_Identifier forIndexPath:indexPath];
    ////展示模式或者搜索模式下搜索值为空
    if ( [self.noteData[indexPath.row] isKindOfClass:[Note class]] ) {
        cell.note = self.noteData[indexPath.row];
        cell.attributes = nil;
        if ( _mode == LOENotePresentationModePresent ) {
            [cell hideDelete];
            //添加长按手势，长按准备删除
            UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
            cell.gestureRecognizers = nil;
            [cell addGestureRecognizer:longPressGesture];
            [longPressGesture release];
        }else if ( _mode == LOENotePresentationModeEdit ) {
            [cell showDelete];
            cell.indexPath = indexPath;
            cell.gestureRecognizers = nil;
        }else {
            cell.gestureRecognizers = nil;
        }
    }else {
        //搜索模式
        NSDictionary *dic = self.noteData[indexPath.row];
        cell.note = [dic objectForKey:LOE_Note_Key];
        cell.range = [[dic objectForKey:LOE_Range_Key] rangeValue];
        cell.attributes = [NSDictionary dictionaryWithObject:[UIColor redColor] forKey:NSForegroundColorAttributeName];
    }
    [cell layoutSubviews];
    return cell;

}

#pragma mark - UICollectionViewDelegate---------------
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //编辑模式下，删除选中cell
    if ( _mode == LOENotePresentationModeEdit ) {
        Note *note = [[[NoteManager sharedManager] findAll] objectAtIndex:indexPath.row];
        [[NoteManager sharedManager] removeNote:note];
        self.noteData = [[NoteManager sharedManager] findAll];
        [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
        if ( self.noteData.count == 0 ) {
            [self doneEdit:nil];
        }
    }else {
        DetailViewController *detailVC = [[DetailViewController alloc] init];
        //添加新Note
        if ( indexPath.row == -1 ) {
            detailVC.currentIndex = -1;
        }else {
            //展示模式或者搜索模式下搜索值为空
            if ( [self.noteData[indexPath.row] isKindOfClass:[Note class]] ) {
                detailVC.currentIndex = (int)indexPath.row;
            }else {
                //搜索模式
                NSDictionary *dic = self.noteData[indexPath.row];
                detailVC.currentIndex = [[dic objectForKey:LOE_Index_Key] intValue];
            }
        }
        [self.navigationController pushViewController:detailVC animated:YES];
        [detailVC release];
    }
    
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout---------------
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    float height;
    float width;
    //由当前orientation决定width
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if ( orientation == UIInterfaceOrientationPortrait ) {
        width = (CGRectGetWidth(self.view.bounds)-20)/2.0;
    }else {
        width = (CGRectGetWidth(self.view.bounds)-20)/3.0;
    }
    //展示模式或者搜索模式下搜索值为空
    if ( [self.noteData[indexPath.row] isKindOfClass:[Note class]] ) {
        Note *note = self.noteData[indexPath.row];
        height = [NoteContainerView heightWithNote:note range:NSMakeRange(0, 0) attributes:nil width:width];
    }else {
        NSDictionary *dic = self.noteData[indexPath.row];
        Note *note = [dic objectForKey:LOE_Note_Key];
        NSRange range = [[dic objectForKey:LOE_Range_Key] rangeValue];
        height = [NoteContainerView heightWithNote:note
                                             range:range
                                        attributes:[NSDictionary dictionaryWithObject:[UIColor redColor] forKey:NSForegroundColorAttributeName]
                                             width:width];
    }
    return CGSizeMake(width, height);

}

#pragma mark - AddSupplementViewDelegate---------------
- (void)addSupplementViewDelegateTapped:(AddSupplementView *)addSupplementView {

    DetailViewController *detailVC = [[DetailViewController alloc] init];
    detailVC.currentIndex = -1;
    [self.navigationController pushViewController:detailVC animated:YES];
    [detailVC release];

}

#pragma mark - UISearchBarDelegate--------------
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    self.noteData = nil;
    NSMutableArray *notes = [[NoteManager sharedManager] findAll];
    if ( searchText.length == 0 ) {
        self.noteData = notes;
    }else {
        self.noteData = [NSMutableArray arrayWithCapacity:notes.count];
        for (int i = 0; i < notes.count; i ++) {
            Note *note = notes[i];
            NSRange range = [note.content rangeOfString:searchText];
            if ( range.length > 0 ) {
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:note,LOE_Note_Key,[NSValue valueWithRange:range],LOE_Range_Key,[NSNumber numberWithInt:i],LOE_Index_Key, nil];
                [self.noteData addObject:dic];
                
            }
        }
    }
    [_collectionView reloadData];
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {

    [_searchBar resignFirstResponder];

}

@end
