//
//  DetailViewController.m
//  PresentationLayer
//
//  Created by loe on 14-9-17.
//  Copyright (c) 2014年 hainan.university. All rights reserved.
//

#import "DetailViewController.h"
#import "NoteManater.h"
#import "NoteSupplementView.h"
#import "DTNavigationController.h"
#import "NoteCollectionView.h"
#import "NoteCollectionViewCell.h"
#import "AddNoteCollectionViewCell.h"
#import "NoteContainerView.h"

#define kCollectionViewHeight 200
@interface DetailViewController ()

@property (nonatomic, retain) UICollectionView *collectionView;
@property (nonatomic, retain) NoteSupplementView *noteView;
@property (nonatomic, retain) UIButton *saveButton;

@end

@implementation DetailViewController

- (void)dealloc
{
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.collectionView = nil;
    self.noteView = nil;
    self.saveButton = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"This Note";
    [self.view addSubview:self.noteView];
    if ( UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation) ) {
        [self.view addSubview:self.collectionView];
    }
    //平移导航返回
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panToBack:)];
    [self.view addGestureRecognizer:pan];
    [pan release];
    
    //监听键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NoteSupplementView *) noteView {

    if ( !_noteView ) {
        CGRect frame;
        if ( UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation) ) {
            frame = CGRectMake(0, self.navBar.bottom, self.view.width, self.view.height-self.navBar.height-kCollectionViewHeight);
        }else {
            frame = CGRectMake(0, self.navBar.bottom, self.view.width, self.view.height-self.navBar.height);
        }
        _noteView = [[NoteSupplementView alloc] initWithFrame:frame];
        if ( _currentIndex == -1 ) {
            _noteView.mode = NoteSupplementModeAddNote;
        }else {
            _noteView.mode = NoteSupplementModePresentNote;
            _noteView.note = [[[NoteManager sharedManager] findAll] objectAtIndex:_currentIndex];
        }
    }
    return _noteView;
    
}

- (UICollectionView *) collectionView {

    if ( !_collectionView ) {
        CHTCollectionViewWaterfallLayout *chtLayout = [[CHTCollectionViewWaterfallLayout alloc] init];
        chtLayout.minimumColumnSpacing = 10;
        chtLayout.minimumInteritemSpacing =5;
        chtLayout.sectionInset = UIEdgeInsetsMake(5, 5, 2, 5);
        CGRect frame = CGRectMake(0, self.noteView.bottom, self.view.width, kCollectionViewHeight);
        _collectionView = [[NoteCollectionView alloc] initWithFrame:frame collectionViewLayout:chtLayout];
        [chtLayout release];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        //注册cell
        [_collectionView registerClass:[NoteCollectionViewCell class]
            forCellWithReuseIdentifier:Note_Cell_Identifier];
        [_collectionView registerClass:[AddNoteCollectionViewCell class]
            forCellWithReuseIdentifier:Note_AddCell_Identifier];
    }
    return _collectionView;
    
}

- (UIButton *)saveButton {

    if ( !_saveButton ) {
        _saveButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        _saveButton.frame = CGRectMake(0, 0, 30, 30);
        [_saveButton setImage:[UIImage imageNamed:@"save.png"] forState:UIControlStateNormal];
        [_saveButton addTarget:self action:@selector(saveNote:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithCustomView:_saveButton];
        self.navItem.rightBarButtonItem = saveItem;
        [saveItem release];
    }
    return _saveButton;
}

- (void) panToBack:(UIPanGestureRecognizer *)pan {
    
    if ( pan.state == UIGestureRecognizerStateBegan ) {
        //发出通知，关闭键盘
        [[NSNotificationCenter defaultCenter] postNotificationName:CloseKeyboardNotification object:nil];
    }
    DTNavigationController *nav = (DTNavigationController *)self.navigationController;
    [nav handlePanGesture:pan];
    return;
    
}

- (void) beginEditNewNote {
    
    if ( _saveButton.alpha == 1.f ) {
        return;
    }
    self.saveButton.alpha = 0.f;
    [UIView animateWithDuration:0.3 animations:^{
        self.saveButton.alpha = 1.f;
    }];

}

- (void) cancelEditNewNote {
    
    if ( !_saveButton ) {
        return;
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.saveButton.alpha = 0.f;
    }];

}

- (void) saveNote:(UIButton *)sender {

    NSString *content = _noteView.contentTextView.text;
    NSDate *date = [NSDate date];
    Note *note = [[Note alloc] initWithContent:content andDate:date];
    if ( _noteView.mode == NoteSupplementModeAddNote ) {
        if ( content.length == 0 ) {
            return;
        }
        [[NoteManager sharedManager] creatNote:note];
    }else {
        if ( [content isEqualToString:_noteView.note.content] ) {
            return;
        }
        [[NoteManager sharedManager] modifyNote:_noteView.note withNote:note];
    }
    [self.navigationController popViewControllerAnimated:YES];

}

- (void) keyboardWillShow:(NSNotification *)notification {

    CGRect rect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat sub = rect.origin.y - _noteView.bottom;
    if ( sub > 0 ) {
        _noteView.height -= sub;
    }else {
        _noteView.height += sub;
    }
    
}

- (void) keyboardWillHide:(NSNotification *)notification {

    CGFloat originHeight;
    if ( UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation) ) {
        originHeight = self.view.height-self.navBar.height-kCollectionViewHeight;
    }else {
        originHeight = self.view.height-self.navBar.height;
    }
    _noteView.height = originHeight;

}

//返回动作,复写父类方法
- (void) back:(UIButton *)button {
    
    if ( _noteView.contentTextView.isFirstResponder ) {
        [_noteView.contentTextView performSelectorOnMainThread:@selector(resignFirstResponder) withObject:nil waitUntilDone:YES];
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark - UICollectionViewDataSource-------------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [[NoteManager sharedManager] findAll].count + 1;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ( indexPath.row == 0 ) {
        AddNoteCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:Note_AddCell_Identifier forIndexPath:indexPath];
        return cell;
    }else {
        NoteCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:Note_Cell_Identifier forIndexPath:indexPath];
        cell.note = [[[NoteManager sharedManager] findAll] objectAtIndex:indexPath.row-1];
        return cell;
    }
    
}

#pragma mark - UICollectionViewDelegate----------------
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    if ( indexPath.row == 0 ) {
        _noteView.mode = NoteSupplementModeAddNote;
    }else {
        _noteView.mode = NoteSupplementModePresentNote;
        _noteView.note = [[[NoteManager sharedManager] findAll] objectAtIndex:indexPath.row-1];
    }
    [_noteView setNeedsLayout];
    
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout---------------
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    float height;
    float width;
    width = (self.view.width-20)/2.0;
    if ( indexPath.row == 0 ) {
        height = width*2.0/3.0;
    }else {
        Note *note = [[[NoteManager sharedManager] findAll] objectAtIndex:indexPath.row-1];
        height = [NoteContainerView heightWithNote:note range:NSMakeRange(0, 0) attributes:nil width:width];
    }
    return CGSizeMake(width, height);
    
}

@end
