//
// Created by Rick Osborne on 7/27/13.
// Copyright (c) 2013 rick osborne dot org. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "GamePrefs.h"


@implementation GamePrefs

static GamePrefs* singleton = nil;

+ (void)initialize {
    if (!singleton) {
        singleton = [[GamePrefs alloc] init];
        singleton.COLOR_POWER_SOURCED = [UIColor colorWithRed:0 green:0.6 blue:1 alpha:1];
        singleton.COLOR_POWER_SUNK    = [UIColor colorWithRed:1 green:0.6 blue:0 alpha:1];
        singleton.COLOR_POWER_NONE    = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
        singleton.COLOR_ARC           = [UIColor colorWithRed:0.933333 green:0.933333 blue:0.933333 alpha:1];
        singleton.COLOR_SCORE         = [UIColor colorWithRed:0.625 green:0.625 blue:0.625 alpha:1];
        singleton.COLOR_BACK          = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    }
}

+ (UIColor *)COLOR_POWER_SOURCED { return singleton.COLOR_POWER_SOURCED; }
+ (UIColor *)COLOR_POWER_SUNK    { return singleton.COLOR_POWER_SUNK; }
+ (UIColor *)COLOR_POWER_NONE    { return singleton.COLOR_POWER_NONE; }
+ (UIColor *)COLOR_ARC           { return singleton.COLOR_ARC; }
+ (UIColor *)COLOR_SCORE         { return singleton.COLOR_SCORE; }
+ (UIColor *)COLOR_BACK          { return singleton.COLOR_BACK; }

@end