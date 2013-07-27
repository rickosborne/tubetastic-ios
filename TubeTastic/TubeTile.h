//
// Created by Rick Osborne on 7/27/13.
// Copyright (c) 2013 rick osborne dot org. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "BaseTile.h"

@interface TubeTile : BaseTile

- (id)initForBoard:(GameBoard *)board withCol:(int)colNum withRow:(int)rowNum;
- (TubeTile *)initForBoard:(GameBoard *)board withCol:(int)colNum withRow:(int)rowNum withBits:(NSUInteger)bits;

@end