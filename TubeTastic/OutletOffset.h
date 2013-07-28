//
// Created by Rick Osborne on 7/26/13.
// Copyright (c) 2013 rick osborne dot org. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "BaseTile.h"

@interface OutletOffset : NSObject

@property int col;
@property int row;

+ (OutletOffset *)makeForCol:(int)colNum andRow:(int)rowNum;
+ (OutletOffset *)makeForDegrees:(int)degrees;

- (id)initWithCol:(int)colNum andRow:(int)rowNum;

@end