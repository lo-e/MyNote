//
//  NoteSupplementView.m
//  PresentationLayer
//
//  Created by loe on 14-9-14.
//  Copyright (c) 2014年 hainan.university. All rights reserved.
//

#import "NoteSupplementView.h"
#import "Note.h"
#import "DetailViewController.h"
#import "NoteManater.h"

@interface NoteSupplementView ()

@property (nonatomic, retain)UILabel *timeLabel;

@end

@implementation NoteSupplementView

- (void)dealloc
{
    self.note = nil;
    self.contentTextView = nil;
    self.timeLabel = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.contentTextView];
        [self addSubview:self.timeLabel];
        //监测通知,关闭键盘
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeKeyboard:) name:CloseKeyboardNotification object:nil];
    }
    return self;
}

- (UITextView *)contentTextView {
    
    if ( !_contentTextView ) {
        _contentTextView = [[UITextView alloc] init];
        _contentTextView.backgroundColor = [UIColor clearColor];
        _contentTextView.font = [UIFont systemFontOfSize:16];
        _contentTextView.left = 5;
        _contentTextView.top = 5;
        _contentTextView.delegate = self;
        
        //添加双击手势，双击退出键盘
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTextView:)];
        tapRecognizer.numberOfTapsRequired = 2;
        [_contentTextView addGestureRecognizer:tapRecognizer];
        [tapRecognizer release];
    }
    return _contentTextView;
    
}

- (UILabel *) timeLabel {
    
    if ( !_timeLabel ) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.size = CGSizeMake(200, 20);
        _timeLabel.font = [UIFont fontWithName:@"NoteWorthy" size:9];;
    }
    return _timeLabel;
    
}

- (void) setMode:(NoteSupplementMode)mode {

    _mode = mode;
    if ( _mode == NoteSupplementModeAddNote ) {
        [self.contentTextView performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.6];
    }

}

- (void) tapTextView:(UITapGestureRecognizer *)tap {

    if ( [_contentTextView isFirstResponder] ) {
        [_contentTextView resignFirstResponder];
    }else {
        [_contentTextView becomeFirstResponder];
    }
    
}

- (void) layoutSubviews {
    
    //添加note模式，只显示内容textView隐藏其他
    if ( _mode == NoteSupplementModeAddNote ) {
        _contentTextView.size = CGSizeMake(CGRectGetWidth(self.bounds)-10, CGRectGetHeight(self.bounds)-10);
        _contentTextView.text = nil;
        _timeLabel.hidden = YES;
    }else {
        //布局内容textView
        _contentTextView.size = CGSizeMake(CGRectGetWidth(self.bounds)-10, CGRectGetHeight(self.bounds)-26);
        _contentTextView.text = _note.content;
        //布局时间label
        _timeLabel.hidden = NO;
        _timeLabel.text = [NSString stringWithDate:_note.date];
        _timeLabel.left = 10;
        _timeLabel.top = CGRectGetHeight(self.bounds)-20;
    }
    
}

- (void) closeKeyboard:(NSNotification *)notification {
    
    [_contentTextView resignFirstResponder];
    
}

#pragma mark - UITextViewDelegate--------------
- (void)textViewDidChange:(UITextView *)textView {

    DetailViewController *detailVC = (DetailViewController *)self.viewController;
    if ( _mode == NoteSupplementModeAddNote ) {
        if ( textView.text.length == 0 ) {
            [detailVC cancelEditNewNote];
        }else {
            [detailVC beginEditNewNote];
        }
    }
    if ( _mode == NoteSupplementModePresentNote ) {
        if ( [textView.text isEqualToString:_note.content] ) {
            [detailVC cancelEditNewNote];
        }else {
            [detailVC beginEditNewNote];
        }
    }

}

@end
