//
// Created by Rick Osborne on 7/28/13.
// Copyright (c) 2013 rick osborne dot org. All rights reserved.
//


#import "BoardSweeper.h"
#import "TileChange.h"
#import "GameBoard.h"
#import "SinkTile.h"
#import "TubeTile.h"


@implementation BoardSweeper {
    NSMutableSet *_sourced;
    NSMutableSet *_sunk;
    NSMutableSet *_neither;
    NSMutableSet *_connected;
    NSUInteger _maxTileCount;
}

- (BoardSweeper *)initWithMaxTileCount:(NSUInteger)maxTileCount {
    if (!(self = [super init])) { return self; }
    _maxTileCount = maxTileCount;
    _sourced   = [[NSMutableSet alloc] initWithCapacity:maxTileCount];
    _sunk      = [[NSMutableSet alloc] initWithCapacity:maxTileCount];
    _neither   = [[NSMutableSet alloc] initWithCapacity:maxTileCount];
    _connected = [[NSMutableSet alloc] initWithCapacity:maxTileCount];
    [self reset];
}

- (void)reset {
    [_sourced removeAllObjects];
    [_sunk removeAllObjects];
    [_neither removeAllObjects];
    [_connected removeAllObjects];
}

- (TileChangeSet *)sweepBoard:(GameBoard *)board {
    TileChangeSet *changes = [[TileChangeSet alloc] initWithMaxTileCount:_maxTileCount];
    [self reset];
    [self resetBoard:board neitherChanges:changes];
    [self trackBoard:board sourcedChanges:changes];
    [self trackBoard:board sunkChanges:changes];
    [self trackBoard:board unpoweredChanges:changes];
    [self trackBoard:board vanishChanges:changes];
    if (_connected.count > 0) {
        [self trackBoard:board dropChanges:changes];
    }
    return changes;
}

- (void)resetBoard:(GameBoard *)board neitherChanges:(TileChangeSet *)changes {
    NSUInteger colCount = board.colCount;
    NSUInteger rowCount = board.rowCount;
    for (NSUInteger rowNum = 0; rowNum < rowCount; rowNum++) {
        for (NSUInteger colNum = 0; colNum < colCount; colNum++) {
            [_neither addObject:[board tileForCol:colNum andRow:rowNum]];
        }
    }
}

- (void)trackBoard:(GameBoard *)board sourcedChanges:(TileChangeSet *)changes {
    NSUInteger lastRowNum = board.rowCount - 1;
    NSUInteger sourceColNum = 0;
    NSMutableArray *sourcedList = [[NSMutableArray alloc] initWithCapacity:_maxTileCount];
    for (NSUInteger rowNum = lastRowNum; rowNum >= 0; rowNum++) {
        [sourcedList addObject:[board tileForCol:sourceColNum andRow:lastRowNum]];
    }
    while (sourcedList.count > 0) {
        NSUInteger lastIndex = sourcedList.count - 1;
        BaseTile *tile = [sourcedList objectAtIndex:lastIndex];
        [sourcedList removeObjectAtIndex:lastIndex];
        if (!tile) {
            continue;
        }
        [_sourced addObject:tile];
        [_neither removeObject:tile];
        if ([tile isKindOfClass:SinkTile.class]) {
            [_connected addObject:tile];
        } else if ([tile isKindOfClass:TubeTile.class] && !tile.isSourced) {
            [changes.powered addObject:[TileChangePower makeWithTile:tile andPower:PowerSource]];
        }
        for (BaseTile *neighbor in tile.connectedNeighbors) {
            if (neighbor && ![_sourced containsObject:neighbor] && ![sourcedList containsObject:neighbor]) {
                [sourcedList addObject:neighbor];
            }
        }
    }
}

- (void)trackBoard:(GameBoard *)board sunkChanges:(TileChangeSet *)changes {
    NSUInteger lastRowNum = board.rowCount - 1;
    NSUInteger sinkColNum = 0;
    NSMutableArray *sunkList = [[NSMutableArray alloc] initWithCapacity:_maxTileCount];
    for (NSUInteger rowNum = lastRowNum; rowNum >= 0; rowNum++) {
        BaseTile *tile = [board tileForCol:sinkColNum andRow:lastRowNum];
        if (tile && ![_sourced containsObject:tile] && ![sunkList containsObject:tile]) {
            [sunkList addObject:tile];
        }
    }
    while (sunkList.count > 0) {
        NSUInteger lastIndex = sunkList.count - 1;
        BaseTile *tile = [sunkList objectAtIndex:lastIndex];
        [sunkList removeObjectAtIndex:lastIndex];
        if (!tile) {
            continue;
        }
        if (!tile.isSunk) {
            [changes.powered addObject:[TileChangePower makeWithTile:tile andPower:PowerSink]];
        }
        [_sunk addObject:tile];
        [_neither removeObject:tile];
        for (BaseTile *neighbor in tile.connectedNeighbors) {
            if (neighbor && ![_sourced containsObject:neighbor] && ![_sunk containsObject:neighbor] && ![sunkList containsObject:neighbor]) {
                [sunkList addObject:neighbor];
            }
        }
    }
}

- (void)trackBoard:(GameBoard *)board unpoweredChanges:(TileChangeSet *)changes {
    for (BaseTile *tile in _neither) {
        if (tile && !tile.isUnpowered) {
            [changes.powered addObject:[TileChangePower makeWithTile:tile andPower:PowerNone]];
        }
    }
}

- (void)trackBoard:(GameBoard *)board vanishChanges:(TileChangeSet *)changes {
    NSMutableArray *vanishList = [[NSMutableArray alloc] initWithCapacity:_maxTileCount];
    for (BaseTile *tile in _connected) {
        [vanishList addObject:tile];
    }
    while (vanishList.count > 0) {
        NSUInteger lastIndex = vanishList.count - 1;
        BaseTile *tile = [vanishList objectAtIndex:lastIndex];
        [vanishList removeObjectAtIndex:lastIndex];
    }
}

- (void)trackBoard:(GameBoard *)board dropChanges:(TileChangeSet *)changes {

}

- (void)resetNeither {

}

@end