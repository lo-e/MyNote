//
//  BaseViewController.m
//  PresentationLayer
//
//  Created by loe on 14-9-15.
//  Copyright (c) 2014年 hainan.university. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)dealloc
{
    self.navItem = nil;
    self.navBar = nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.9 green:0.91 blue:0.9 alpha:1];
    [self addNavigationBar];
}

- (void) viewWillAppear:(BOOL)animated {

    [self setBackItem];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) addNavigationBar {
    
    CGRect frame;
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if ( orientation == UIInterfaceOrientationPortrait ) {
        frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 64);
    } else {
        frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 44);
    }
    _navBar = [[UINavigationBar alloc] initWithFrame:frame];
    _navBar.backgroundColor = [UIColor blackColor];
    _navBar.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    [_navBar pushNavigationItem:self.myNavItem animated:YES];
    [self.view addSubview:_navBar];
    
}

- (UINavigationItem *) myNavItem {

    if ( !_navItem ) {
        _navItem = [[UINavigationItem alloc] init];
    }
    return _navItem;
}

//自定义返回图标
- (void) setBackItem {

    if ( self.navigationController.viewControllers.count > 1 ) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        button.frame = CGRectMake(0, 0, 36, 20);
        [button addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        _navItem.leftBarButtonItem = backItem;
        [backItem release];
    }

}
//返回动作
- (void) back:(UIButton *)button {

    [self.navigationController popViewControllerAnimated:YES];

}
//自定义title视图
- (void) setTitle:(NSString *)title {

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont fontWithName:@"Bradley Hand" size:16];
    self.navItem.titleView = titleLabel;
    [titleLabel release];

}

@end
