//
// Created by Rick Osborne on 7/26/13.
// Copyright (c) 2013 rick osborne dot org. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "BaseTile.h"


@interface SourceTile : BaseTile

- (SourceTile *)initForBoard:(GameBoard *)board withCol:(NSUInteger)colNum withRow:(NSUInteger)rowNum;

@end