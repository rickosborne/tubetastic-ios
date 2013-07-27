//
//  SplashViewController.m
//  TubeTastic
//
//  Created by Rick Osborne on 7/24/13.
//  Copyright (c) 2013 rick osborne dot org. All rights reserved.
//

#import "SplashViewController.h"
#import "TileRenderer.h"
#import "SourceTile.h"
#import "SinkTile.h"
#import "TubeTile.h"

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
    splashView.backgroundColor = [UIColor blackColor];
    self.view = splashView;
    TileView *tileView1 = [[TileView alloc] initWithFrame:CGRectMake(0, 40, 100, 100)];
    tileView1.tile = [[SourceTile alloc] initForBoard:nil withCol:0 withRow:0];
    [self.view addSubview:tileView1];
    TileView *tileView2 = [[TileView alloc] initWithFrame:CGRectMake(100, 40, 100, 100)];
    tileView2.tile = [[TubeTile alloc] initForBoard:nil withCol:0 withRow:0 withBits:14];
    [self.view addSubview:tileView2];
    TileView *tileView3 = [[TileView alloc] initWithFrame:CGRectMake(200, 40, 100, 100)];
    tileView3.tile = [[SinkTile alloc] initForBoard:nil withCol:0 withRow:0];
    [self.view addSubview:tileView3];
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
