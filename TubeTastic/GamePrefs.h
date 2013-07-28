//
// Created by Rick Osborne on 7/27/13.
// Copyright (c) 2013 rick osborne dot org. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface GamePrefs : NSObject

@property UIColor *COLOR_POWER_SOURCED;
@property UIColor *COLOR_POWER_SUNK;
@property UIColor *COLOR_POWER_NONE;
@property UIColor *COLOR_ARC;
@property UIColor *COLOR_SCORE;
@property UIColor *COLOR_BACK;

+ (UIColor *)COLOR_POWER_SOURCED;
+ (UIColor *)COLOR_POWER_SUNK;
+ (UIColor *)COLOR_POWER_NONE;
+ (UIColor *)COLOR_ARC;
+ (UIColor *)COLOR_SCORE;
+ (UIColor *)COLOR_BACK;

@end