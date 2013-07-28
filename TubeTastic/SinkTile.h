//
// Created by Rick Osborne on 7/26/13.
// Copyright (c) 2013 rick osborne dot org. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "BaseTile.h"


@interface SinkTile : BaseTile

- (id)initForBoard:(GameBoard *)board withCol:(int)colNum withRow:(int)rowNum;

@end