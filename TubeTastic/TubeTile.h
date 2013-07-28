//
// Created by Rick Osborne on 7/27/13.
// Copyright (c) 2013 rick osborne dot org. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "BaseTile.h"

@interface TubeTile : BaseTile

- (id)initForBoard:(GameBoard *)board withCol:(NSUInteger)colNum withRow:(NSUInteger)rowNum;
- (TubeTile *)initForBoard:(GameBoard *)board withCol:(NSUInteger)colNum withRow:(NSUInteger)rowNum withBits:(NSUInteger)bits;

@end