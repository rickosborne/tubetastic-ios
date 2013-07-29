//
// Created by Rick Osborne on 7/25/13.
// Copyright (c) 2013 rick osborne dot org. All rights reserved.
//


#import "BaseTile.h"
#import "GameBoard.h"
#import "Outlets.h"
#import "OutletOffset.h"

@implementation BaseTile

@synthesize power = _power, watcher = _watcher;

//+ (void)initialize {
//    // yeah, this is ugly
//    NSNumber *degreesNorth = [NSNumber numberWithInt:DEGREES_NORTH];
//    NSNumber *degreesEast  = [NSNumber numberWithInt:DEGREES_EAST];
//    NSNumber *degreesSouth = [NSNumber numberWithInt:DEGREES_SOUTH];
//    NSNumber *degreesWest  = [NSNumber numberWithInt:DEGREES_WEST];
//    directionFromDegrees = @{
//            degreesNorth: DIRECTION_NORTH,
//            degreesEast : DIRECTION_EAST,
//            degreesSouth: DIRECTION_SOUTH,
//            degreesWest : DIRECTION_WEST
//    };
//    outletRotationsReverse = @{
//            degreesNorth: @{
//                    [NSNumber numberWithInt:(DEGREES_NORTH + DEGREES_NORTH) % 360]: degreesNorth,
//                    [NSNumber numberWithInt:(DEGREES_NORTH + DEGREES_EAST)  % 360]: degreesEast,
//                    [NSNumber numberWithInt:(DEGREES_NORTH + DEGREES_SOUTH) % 360]: degreesSouth,
//                    [NSNumber numberWithInt:(DEGREES_NORTH + DEGREES_WEST)  % 360]: degreesWest,
//            },
//            degreesEast: @{
//                    [NSNumber numberWithInt:(DEGREES_EAST  + DEGREES_NORTH) % 360]: degreesNorth,
//                    [NSNumber numberWithInt:(DEGREES_EAST  + DEGREES_EAST)  % 360]: degreesEast,
//                    [NSNumber numberWithInt:(DEGREES_EAST  + DEGREES_SOUTH) % 360]: degreesSouth,
//                    [NSNumber numberWithInt:(DEGREES_EAST  + DEGREES_WEST)  % 360]: degreesWest,
//            },
//            degreesSouth: @{
//                    [NSNumber numberWithInt:(DEGREES_SOUTH + DEGREES_NORTH) % 360]: degreesNorth,
//                    [NSNumber numberWithInt:(DEGREES_SOUTH + DEGREES_EAST)  % 360]: degreesEast,
//                    [NSNumber numberWithInt:(DEGREES_SOUTH + DEGREES_SOUTH) % 360]: degreesSouth,
//                    [NSNumber numberWithInt:(DEGREES_SOUTH + DEGREES_WEST)  % 360]: degreesWest,
//            },
//            degreesSouth: @{
//                    [NSNumber numberWithInt:(DEGREES_WEST  + DEGREES_NORTH) % 360]: degreesNorth,
//                    [NSNumber numberWithInt:(DEGREES_WEST  + DEGREES_EAST)  % 360]: degreesEast,
//                    [NSNumber numberWithInt:(DEGREES_WEST  + DEGREES_SOUTH) % 360]: degreesSouth,
//                    [NSNumber numberWithInt:(DEGREES_WEST  + DEGREES_WEST)  % 360]: degreesWest,
//            }
//    };
//    outletOffsets = @{
//            degreesNorth: [OutletOffset makeForDegrees:DEGREES_NORTH],
//            degreesEast : [OutletOffset makeForDegrees:DEGREES_EAST],
//            degreesSouth: [OutletOffset makeForDegrees:DEGREES_SOUTH],
//            degreesWest : [OutletOffset makeForDegrees:DEGREES_WEST]
//    };
//}

//+ (int)degreesFromDirection:(NSString*)direction {
//    for (int i = 0; i < directionCount; i++) {
//        if ([outletDirections[i] isEqualToString:direction]) {
//            return outletDegrees[i];
//        }
//    }
//    return 0;
//}

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

- (BaseTile *)initForBoard:(GameBoard*)board withCol:(NSUInteger)colNum withRow:(NSUInteger)rowNum {
    self = [super initForBoard:board withCol:colNum withRow:rowNum];
    if (!self) { return self; }
    _power = PowerNone;
    _watcher = nil;
    _outletRotation = 0;
    _outlets = [[Outlets alloc] init];
    return self;
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

- (EmptyTile *)neighborAtDegrees:(int)degrees {
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