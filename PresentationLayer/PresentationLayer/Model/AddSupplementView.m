//
//  AddSupplementView.m
//  PresentationLayer
//
//  Created by loe on 14-9-17.
//  Copyright (c) 2014年 hainan.university. All rights reserved.
//

#import "AddSupplementView.h"

@interface AddSupplementView ()

@property (nonatomic, retain) UILabel       *label;
@property (nonatomic, retain) UIImageView   *imageView;

@end

@implementation AddSupplementView

- (void)dealloc
{
    self.label = nil;
    self.imageView = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.label];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:tap];
        [tap release];
    }
    return self;
}

- (UILabel *) label {

    if ( !_label ) {
        _label = [[UILabel alloc] initWithFrame:self.bounds];
        _label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _label.text = @"轻触添加";
        _label.font = [UIFont systemFontOfSize:15];
        _label.textColor = [UIColor lightGrayColor];
        _label.alpha = 0.6;
        _label.textAlignment = NSTextAlignmentCenter;
        [_label addSubview:self.imageView];
    }
    return  _label;

}

- (UIImageView *) imageView {

    if ( !_imageView ) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(200, 10, 20, 20)];
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
        _imageView.alpha = 1;
        _imageView.image = [UIImage imageNamed:@"add.png"];
    }
    return _imageView;
    
}

//使用代理
- (void) tap:(UITapGestureRecognizer *)tap {

    if ( [_delegate respondsToSelector:@selector(addSupplementViewDelegateTapped:)] ) {
        [_delegate addSupplementViewDelegateTapped:self];
    }
    return;

}


@end
