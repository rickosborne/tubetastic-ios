//
//  SplashViewController.m
//  TubeTastic
//
//  Created by Rick Osborne on 7/24/13.
//  Copyright (c) 2013 rick osborne dot org. All rights reserved.
//

#import "SplashViewController.h"

@interface SplashViewController ()

@end

@implementation SplashViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (!self) {
        return self;
    }
//    self.restorationIdentifier = @"SplashViewController";
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 500)];
    [button setTitle:@"New Game" forState:UIControlStateNormal];
    [self.view addSubview:button];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//+ (UIViewController *) viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder {
//    return self;
//}

- (void)loadView {
    CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
    SplashView *splashView = [[SplashView alloc] initWithFrame:appFrame];
    splashView.backgroundColor = [UIColor blueColor];
    self.view = splashView;
    TileView *tileView = [[TileView alloc] initWithFrame:CGRectMake(20, 40, 60, 60)];
    [self.view addSubview:tileView];
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
