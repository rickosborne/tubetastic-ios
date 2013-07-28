//
// Created by Rick Osborne on 7/25/13.
// Copyright (c) 2013 rick osborne dot org. All rights reserved.
//


#import "GameBoard.h"
#import "TileChange.h"
#import "BoardSweeper.h"


@implementation GameBoard {
@private
    NSUInteger _rowCount;
    NSUInteger _colCount;
    NSMutableArray *_board;
    NSUInteger _score;
    BoardSweeper *_sweeper;
@protected
    id <GameBoardWatcher> _watcher;
    BOOL _settled;
}
@synthesize watcher = _watcher;
@synthesize settled = _settled;

- (GameBoard *)initWithColCount:(NSUInteger)colCount rowCount:(NSUInteger)rowCount {
    if (!(self = [super init])) { return self; }
    _rowCount = rowCount;
    _colCount = colCount;
    _board = [[NSMutableArray alloc] initWithCapacity:colCount * rowCount];
    for (NSUInteger rowNum = 0; rowNum < _rowCount; rowNum++) {
        for (NSUInteger colNum = 0; colNum < _colCount; colNum++) {
            [self setTile:[EmptyTile empty] forCol:colNum andRow:rowNum];
        }
    }
    _score = 0;
    _sweeper = [[BoardSweeper alloc] init];
    _settled = false;
    _watcher = nil;
    return self;
}

- (NSUInteger)indexForCol:(NSUInteger)colNum andRow:(NSUInteger)rowNum {
    return (rowNum * _colCount) + colNum;
}

- (BaseTile *)tileForCol:(NSUInteger)colNum andRow:(NSUInteger)rowNum {
    if ((colNum < _colCount) && (rowNum < _rowCount)) {
        return (BaseTile *) [_board objectAtIndex:[self indexForCol:colNum andRow:rowNum]];
    }
    return nil;
}

- (void)randomizeTiles {
    _settled = false;
    for (NSUInteger rowNum = 0; rowNum < _rowCount; rowNum++) {
        for (NSUInteger colNum = 0; colNum < _colCount; colNum++) {
            BaseTile *tile = [self tileForCol:colNum andRow:rowNum];
            if (tile) {
                [self setTile:[EmptyTile empty] forCol:colNum andRow:rowNum];
            }
            TileType tileType = TileTypeTube;
            if (colNum == 0) { tileType = TileTypeSource; }
            else if (colNum == _colCount - 1) { tileType = TileTypeSink; }
            [self setNewTileOfType:tileType forCol:colNum andRow:rowNum withBits:0];
        }
    }
    [self sweepUntilSettled];
}

- (void)setTile:(EmptyTile *)tile forCol:(NSUInteger)colNum andRow:(NSUInteger)rowNum {
    if ((colNum < _colCount) && (rowNum < _rowCount)) {
        [_board replaceObjectAtIndex:[self indexForCol:colNum andRow:rowNum] withObject:tile];

    }
}

- (void)setNewTileOfType:(TileType)tileType forCol:(NSUInteger)colNum andRow:(NSUInteger)rowNum withBits:(NSUInteger)bits {
}

- (void)sweepUntilSettled {

}

@end