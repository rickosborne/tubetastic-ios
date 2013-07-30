//
// Created by Rick Osborne on 7/25/13.
// Copyright (c) 2013 rick osborne dot org. All rights reserved.
//


#import "BaseTile.h"
#import "GameBoard.h"
#import "Outlets.h"
#import "OutletOffset.h"

@implementation BaseTile

@synthesize colNum = _colNum, rowNum = _rowNum, id = _id, power = _power, watcher = _watcher;

+ (NSUInteger)makeIdFromCol:(NSUInteger)colNum andRow:(NSUInteger)rowNum {
    return (colNum * 1000) + rowNum;
}

- (BaseTile *)initForBoard:(GameBoard*)board withCol:(NSUInteger)colNum withRow:(NSUInteger)rowNum {
    if (!(self = [super init])) { return self; }
    _colNum = colNum;
    _rowNum = rowNum;
    _board = board;
    _id = [BaseTile makeIdFromCol:colNum andRow:rowNum];
    _power = PowerNone;
    _watcher = nil;
    _outletRotation = 0;
    _outlets = [[Outlets alloc] init];
    return self;
}

int reverseDirectionDegrees(int degrees) {
    switch (degrees) {
        case DEGREES_NORTH: return DEGREES_SOUTH;
        case DEGREES_EAST : return DEGREES_WEST;
        case DEGREES_SOUTH: return DEGREES_NORTH;
        case DEGREES_WEST: return DEGREES_EAST;
        default: return 0;
    }
}

int unrotateDegrees(int outletRotation, int degrees) {
    switch (outletRotation) {
        case 90:
            switch (degrees) {
                case DEGREES_NORTH: return DEGREES_EAST;
                case DEGREES_EAST : return DEGREES_SOUTH;
                case DEGREES_SOUTH: return DEGREES_WEST;
                case DEGREES_WEST : return DEGREES_NORTH;
                default: return -1;
            }
        case 180:
            return reverseDirectionDegrees(degrees);
        case 270:
            switch (degrees) {
                case DEGREES_NORTH: return DEGREES_WEST;
                case DEGREES_EAST : return DEGREES_NORTH;
                case DEGREES_SOUTH: return DEGREES_EAST;
                case DEGREES_WEST : return DEGREES_SOUTH;
                default: return -1;
            }
        default:
            return degrees;
    }
}

- (NSString*)description {
    NSMutableString *connected = [[NSMutableString alloc] initWithFormat:@"%@ %d,%d %@", self.class, _colNum, _rowNum, _outlets];
    for (int degreesNum = 0; degreesNum < directionCount; degreesNum++) {
        int degrees = outletDegrees[degreesNum];
        if ([self hasOutletToDegrees:degrees]) {
            BaseTile* neighbor = [self neighborAtDegrees:degrees];
            int reverseDegrees = reverseDirectionDegrees(degrees);
            if (neighbor && [neighbor hasOutletToDegrees:reverseDegrees]) {
                [connected appendFormat:@" %d:%d:%d,%d", neighbor.power, degrees, neighbor.colNum, neighbor.rowNum];
            }
        }
    }
    return connected;
}

- (BOOL)hasOutletToDegrees:(int)degrees {
    int originalDegrees = unrotateDegrees(_outletRotation, degrees);
    return [_outlets hasOutletToDegrees:originalDegrees];
}

- (NSArray *)connectedNeighbors {
    NSMutableArray *connected = [[NSMutableArray alloc] initWithCapacity:directionCount];
    for (int degreesNum = 0; degreesNum < directionCount; degreesNum++) {
        int degrees = outletDegrees[degreesNum];
        if ([self hasOutletToDegrees:degrees]) {
            BaseTile *neighbor = [self neighborAtDegrees:degrees];
            if (neighbor && [neighbor hasOutletToDegrees:reverseDirectionDegrees(degrees)]) {
                [connected addObject:neighbor];
            }
        }
    }
    return connected;
}

- (BaseTile *)neighborAtDegrees:(int)degrees {
    OutletOffset *offset = [OutletOffset makeForDegrees:degrees];
    return [_board tileForCol:_colNum + offset.col andRow:_rowNum + offset.row];
}

- (void)setPower:(Power)power {
    Power fromPower = _power;
    if (fromPower != power) {
        _power = power;
        if (_watcher) {
            [_watcher tile:self powerDidChangeFrom:fromPower to:power];
        }
    }
}

- (BOOL)isSourced { return (_power & PowerSource); }
- (BOOL)isSunk { return (_power & PowerSink); }
- (BOOL)isUnpowered { return (_power == PowerNone); }
- (NSUInteger)bits { return _outlets.bits; }
- (void)setBits:(NSUInteger)bits { _outlets.bits = bits; }

- (void)setCol:(NSUInteger)colNum andRow:(NSUInteger)rowNum {
    int fromColNum = _colNum;
    int fromRowNum = _rowNum;
    if ((fromColNum != colNum) || (fromRowNum != rowNum)) {
        _colNum = colNum;
        _rowNum = rowNum;
        _id = [BaseTile makeIdFromCol:colNum andRow:rowNum];
        if (_watcher) {
            [_watcher tile:self movedFromCol:fromColNum fromRow:fromRowNum toCol:colNum toRow:rowNum];
        }
    }
}

- (void)spin {
    int fromDegrees = _outletRotation;
    _outletRotation += 90;
    if (_watcher) {
        [_watcher tile:self didSpinFrom:fromDegrees to:_outletRotation];
    }
    _outletRotation %= 360;
}

- (void)vanish {
    if (_watcher) {
        [_watcher tileDidVanish:self];
    }
}

@end