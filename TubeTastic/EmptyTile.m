//
// Created by Rick Osborne on 7/28/13.
// Copyright (c) 2013 rick osborne dot org. All rights reserved.
//


#import "EmptyTile.h"
#import "GameBoard.h"


@implementation EmptyTile

@synthesize colNum = _colNum, rowNum = _rowNum, id = _id, empty;

static EmptyTile *_empty;

+ (void)initialize {
    _empty = [[EmptyTile alloc] init];
}

+ (EmptyTile *)empty {
    return _empty;
}

+ (NSUInteger)makeIdFromCol:(NSUInteger)colNum andRow:(NSUInteger)rowNum {
    return (colNum * 1000) + rowNum;
}

- (EmptyTile *)initForBoard:(GameBoard*)board withCol:(NSUInteger)colNum withRow:(NSUInteger)rowNum {
    if (!(self = [super init])) { return self; }
    _colNum = colNum;
    _rowNum = rowNum;
    _board = board;
    _id = [BaseTile makeIdFromCol:colNum andRow:rowNum];
    return self;
}

- (BOOL)isEmpty {
    return self == _empty;
}

@end