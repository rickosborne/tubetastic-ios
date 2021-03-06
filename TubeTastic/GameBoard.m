//
// Created by Rick Osborne on 7/25/13.
// Copyright (c) 2013 rick osborne dot org. All rights reserved.
//


#import "GameBoard.h"
#import "TileChange.h"
#import "BoardSweeper.h"
#import "TubeTile.h"
#import "SourceTile.h"
#import "SinkTile.h"


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
@synthesize colCount = _colCount;
@synthesize rowCount = _rowCount;
@synthesize score = _score;

- (GameBoard *)initWithColCount:(NSUInteger)colCount rowCount:(NSUInteger)rowCount {
    if (!(self = [super init])) { return self; }
    _rowCount = rowCount;
    _colCount = colCount;
    _board = [[NSMutableArray alloc] initWithCapacity:colCount * rowCount];
    for (NSUInteger rowNum = 0; rowNum < _rowCount; rowNum++) {
        for (NSUInteger colNum = 0; colNum < _colCount; colNum++) {
            [_board addObject:[NSNull null]];
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
        BaseTile *tile = (BaseTile *) [_board objectAtIndex:[self indexForCol:colNum andRow:rowNum]];
        if (tile && [tile isKindOfClass:BaseTile.class]) {
            return tile;
        }
    }
    return nil;
}

- (void)randomizeTiles {
    _settled = false;
    for (NSUInteger rowNum = 0; rowNum < _rowCount; rowNum++) {
        for (NSUInteger colNum = 0; colNum < _colCount; colNum++) {
            BaseTile *tile = [self tileForCol:colNum andRow:rowNum];
            if (tile) {
                [self setTile:nil forCol:colNum andRow:rowNum];
            }
            TileType tileType = TileTypeTube;
            if (colNum == 0) { tileType = TileTypeSource; }
            else if (colNum == _colCount - 1) { tileType = TileTypeSink; }
            [self setNewTileOfType:tileType forCol:colNum andRow:rowNum withBits:0];
        }
    }
    [self sweepUntilSettled];
}

- (BaseTile *)setTile:(BaseTile *)tile forCol:(NSUInteger)colNum andRow:(NSUInteger)rowNum {
    if ((colNum < _colCount) && (rowNum < _rowCount)) {
        NSObject *tileObject = tile ? tile : [NSNull null];
        [_board replaceObjectAtIndex:[self indexForCol:colNum andRow:rowNum] withObject:tileObject];
        if (tile && (tile.colNum != colNum) && (tile.rowNum != rowNum)) {
            [tile setCol:colNum andRow:rowNum];
        }
    }
    return tile;
}

- (BaseTile *)setNewTileOfType:(TileType)tileType forCol:(NSUInteger)colNum andRow:(NSUInteger)rowNum withBits:(NSUInteger)bits {
    BaseTile *tile;
    switch (tileType) {
        case TileTypeTube:
            if (bits > 0) {
                tile = [[TubeTile alloc] initForBoard:self withCol:colNum withRow:rowNum withBits:bits];
            } else {
                tile = [[TubeTile alloc] initForBoard:self withCol:colNum withRow:rowNum];
            }
            break;
        case TileTypeSource:
            tile = [[SourceTile alloc] initForBoard:self withCol:colNum withRow:rowNum];
            break;
        case TileTypeSink:
            tile = [[SinkTile alloc] initForBoard:self withCol:colNum withRow:rowNum];
            break;
        default:
            tile = nil;
            break;
    }
    return [self setTile:tile forCol:colNum andRow:rowNum];
}

- (void)setScore:(NSUInteger)score {
    NSUInteger oldScore = _score;
    if (score == oldScore) { return; }
    _score = score;
    if (_watcher) {
        [_watcher scoreDidChangeFrom:oldScore to:score];
    }
}

- (void)addScore:(NSUInteger)score {
    [self setScore:_score + score];
}

- (void)sweepUntilSettled {
    while (!_settled) {
        [self powerSweep];
    }
}

- (TileChangeSet *)powerSweep {
    TileChangeSet *changes = [_sweeper sweepBoard:self];
    for (TileChangePower *tilePower in changes.powered) {
        if (tilePower.tile) {
            [tilePower.tile setPower:tilePower.power];
        }
    }
    for (TubeTile *tile in changes.vanished) {
        if (tile) {
            [self setTile:nil forCol:tile.colNum andRow:tile.rowNum];
            [tile vanish];
        }
    }
    for (TileChangeMove *move in changes.moved) {
        if (move.tile) {
            [self setTile:move.tile forCol:move.toCol andRow:move.toRow];
            [move.tile setCol:move.toCol andRow:move.toRow];
        }
    }
    for (TileChangeAppear *appear in changes.appeared) {
        [self setNewTileOfType:TileTypeTube forCol:appear.colNum andRow:appear.rowNum withBits:0];
    }
    if (_settled) {
        [self addScore:changes.vanished.count];
    } else if ((changes.appeared.count == 0) && (changes.vanished.count == 0) && (changes.moved.count == 0)) {
        _settled = YES;
        return nil;
    }
    return changes;
}

@end