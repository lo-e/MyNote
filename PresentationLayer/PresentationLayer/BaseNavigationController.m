//
//  BaseNavigationController.m
//  PresentationLayer
//
//  Created by loe on 14-9-15.
//  Copyright (c) 2014年 hainan.university. All rights reserved.
//


#import "BaseNavigationController.h"
#import "DetailViewController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

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
}

- (BOOL) shouldAutorotate {

    if ( [[self.viewControllers lastObject] isKindOfClass:[DetailViewController class]] ) {
        return NO;
    }else {
        return YES;
    }

}

- (NSUInteger) supportedInterfaceOrientations {


    return UIInterfaceOrientationMaskAllButUpsideDown;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
