//
// Created by Rick Osborne on 7/28/13.
// Copyright (c) 2013 rick osborne dot org. All rights reserved.
//


#import "TileChange.h"
#import "BaseTile.h"


@implementation TileChange {
@protected
    BaseTile *_tile;
}
@synthesize tile = _tile;

- (id)initWithTile:(BaseTile *)tile {
    if (!(self = [super init])) { return self; }
    _tile = tile;
    return self;
}

@end

// ------------------------------------------------------------------

@implementation TileChangePower {
@protected
    Power _power;
}

@synthesize power = _power;

- (id)initWithTile:(BaseTile *)tile andPower:(Power)power {
    if (!(self = [super initWithTile:tile])) { return self; }
    _power = power;
    return self;
}

@end

// ------------------------------------------------------------------

@implementation TileChangeMove {
@protected
    NSUInteger _fromCol;
    NSUInteger _fromRow;
    NSUInteger _toCol;
    NSUInteger _toRow;
}
@synthesize fromCol = _fromCol;
@synthesize fromRow = _fromRow;
@synthesize toCol = _toCol;
@synthesize toRow = _toRow;

- (id)initWithTile:(BaseTile *)tile fromCol:(NSUInteger)fromCol fromRow:(NSUInteger)fromRow toCol:(NSUInteger)toCol toRow:(NSUInteger)toRow {
    if (!(self = [super initWithTile:tile])) { return self; }
    _fromCol = fromCol;
    _fromRow = fromRow;
    _toCol = toCol;
    _toRow = toRow;
    return self;
}

// ------------------------------------------------------------------

@implementation TileChangeAppear {
@protected
    NSUInteger _colNum;
    NSUInteger _rowNum;
}
@synthesize colNum = _colNum;
@synthesize rowNum = _rowNum;

- (id)initWithTile:(BaseTile *)tile colNum:(NSUInteger)colNum rowNum:(NSUInteger)rowNum {
    if (!(self = [super initWithTile:tile])) { return self; }
    _colNum = colNum;
    _rowNum = rowNum;
    return self;
}

// ------------------------------------------------------------------

@implementation TileChangeSet {

@private
    NSArray *_moved;
    NSArray *_powered;
    NSArray *_vanished;
    NSArray *_appeared;
}

@synthesize moved = _moved;
@synthesize powered = _powered;
@synthesize vanished = _vanished;
@synthesize appeared = _appeared;

- (TileChangeSet *)initWithMaxTileCount:(NSUInteger)maxTileCount {
    if (!(self = [super init])) { return self; }
    _moved    = [[NSMutableArray alloc] initWithCapacity:maxTileCount];
    _powered  = [[NSMutableArray alloc] initWithCapacity:maxTileCount];
    _vanished = [[NSMutableArray alloc] initWithCapacity:maxTileCount];
    _appeared = [[NSMutableArray alloc] initWithCapacity:maxTileCount];
    return self;
}

@end