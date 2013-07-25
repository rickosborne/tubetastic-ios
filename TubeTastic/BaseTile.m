//
// Created by Rick Osborne on 7/25/13.
// Copyright (c) 2013 rick osborne dot org. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BaseTile.h"
#import "GameBoard.h"
#import "Outlets.h"
#import "TileWatcher.h"

@implementation OutletOffset

- (id)init { return nil; };

- (id)initWithCol:(int)colNum andRow:(int)rowNum {
    if ((self = [super init])) {
        self.col = colNum;
        self.row = rowNum;
    }
    return self;
}

+ (OutletOffset *)makeForCol:(int)colNum andRow:(int)rowNum {
    return [[OutletOffset alloc] initWithCol:colNum andRow:rowNum];
}

+ (OutletOffset *)makeForDegrees:(int)degrees {
    OutletOffset *outletOffset = [OutletOffset makeForCol:0 andRow:0];
    switch (degrees) {
        case DEGREES_NORTH:
            outletOffset.col = 0;
            outletOffset.row = -1;
            break;
        case DEGREES_EAST:
            outletOffset.col = 1;
            outletOffset.row = 0;
            break;
        case DEGREES_SOUTH:
            outletOffset.col = 0;
            outletOffset.row = 1;
            break;
        case DEGREES_WEST:
            outletOffset.col = -1;
            outletOffset.row = 0;
            break;
    }
    return outletOffset;
}

@end


@implementation BaseTile
{
    int _colNum;
    int _rowNum;
    int _id;
    GameBoard* _board;
    Power _power;
    Outlets* _outlets;
    int _outletRotation;
    TileWatcher* _watcher;
}
@synthesize power = _power, colNum = _colNum, rowNum = _rowNum, id = _id;

+ (void)initialize {
    // yeah, this is ugly
    NSNumber *degreesNorth = [NSNumber numberWithInt:DEGREES_NORTH];
    NSNumber *degreesEast  = [NSNumber numberWithInt:DEGREES_EAST];
    NSNumber *degreesSouth = [NSNumber numberWithInt:DEGREES_SOUTH];
    NSNumber *degreesWest  = [NSNumber numberWithInt:DEGREES_WEST];
    directionFromDegrees = @{
            degreesNorth: DIRECTION_NORTH,
            degreesEast : DIRECTION_EAST,
            degreesSouth: DIRECTION_SOUTH,
            degreesWest : DIRECTION_WEST
    };
    outletRotationsReverse = @{
            degreesNorth: @{
                    [NSNumber numberWithInt:(DEGREES_NORTH + DEGREES_NORTH) % 360]: degreesNorth,
                    [NSNumber numberWithInt:(DEGREES_NORTH + DEGREES_EAST)  % 360]: degreesEast,
                    [NSNumber numberWithInt:(DEGREES_NORTH + DEGREES_SOUTH) % 360]: degreesSouth,
                    [NSNumber numberWithInt:(DEGREES_NORTH + DEGREES_WEST)  % 360]: degreesWest,
            },
            degreesEast: @{
                    [NSNumber numberWithInt:(DEGREES_EAST  + DEGREES_NORTH) % 360]: degreesNorth,
                    [NSNumber numberWithInt:(DEGREES_EAST  + DEGREES_EAST)  % 360]: degreesEast,
                    [NSNumber numberWithInt:(DEGREES_EAST  + DEGREES_SOUTH) % 360]: degreesSouth,
                    [NSNumber numberWithInt:(DEGREES_EAST  + DEGREES_WEST)  % 360]: degreesWest,
            },
            degreesSouth: @{
                    [NSNumber numberWithInt:(DEGREES_SOUTH + DEGREES_NORTH) % 360]: degreesNorth,
                    [NSNumber numberWithInt:(DEGREES_SOUTH + DEGREES_EAST)  % 360]: degreesEast,
                    [NSNumber numberWithInt:(DEGREES_SOUTH + DEGREES_SOUTH) % 360]: degreesSouth,
                    [NSNumber numberWithInt:(DEGREES_SOUTH + DEGREES_WEST)  % 360]: degreesWest,
            },
            degreesSouth: @{
                    [NSNumber numberWithInt:(DEGREES_WEST  + DEGREES_NORTH) % 360]: degreesNorth,
                    [NSNumber numberWithInt:(DEGREES_WEST  + DEGREES_EAST)  % 360]: degreesEast,
                    [NSNumber numberWithInt:(DEGREES_WEST  + DEGREES_SOUTH) % 360]: degreesSouth,
                    [NSNumber numberWithInt:(DEGREES_WEST  + DEGREES_WEST)  % 360]: degreesWest,
            }
    };
    outletOffsets = @{
            degreesNorth: [OutletOffset makeForDegrees:DEGREES_NORTH],
            degreesEast : [OutletOffset makeForDegrees:DEGREES_EAST],
            degreesSouth: [OutletOffset makeForDegrees:DEGREES_SOUTH],
            degreesWest : [OutletOffset makeForDegrees:DEGREES_WEST]
    };
}

+ (int)makeIdFromCol:(int)colNum andRow:(int)rowNum {
    return (colNum * 1000) + rowNum;
}

+ (int)degreesFromDirection:(NSString*)direction {
    for (int i = 0; i < directionCount; i++) {
        if ([outletDirections[i] isEqualToString:direction]) {
            return outletDegrees[i];
        }
    }
    return 0;
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
            }
            break;
        case 180:
            return reverseDirectionDegrees(degrees);
        case 270:
            switch (degrees) {
                case DEGREES_NORTH: return DEGREES_WEST;
                case DEGREES_EAST : return DEGREES_NORTH;
                case DEGREES_SOUTH: return DEGREES_EAST;
                case DEGREES_WEST : return DEGREES_SOUTH;
            }
            break;
        default:
            return degrees;
    }
    return -1;
}

- (id)initForBoard:(GameBoard*)board withCol:(int)colNum withRow:(int)rowNum {
    self = [super init];
    if (!self) { return self; }
    _colNum = colNum;
    _rowNum = rowNum;
    _board = board;
    _id = [BaseTile makeIdFromCol:colNum andRow:rowNum];
    _power = PowerNone;
    _watcher = nil;
    _outletRotation = 0;
    _outlets = [[Outlets alloc] init];
}

- (NSString*)description {
    NSMutableString *connected = [[NSMutableString alloc] initWithFormat:@"BaseTile %d,%d %@", _colNum, _rowNum, _outlets];
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

- (BaseTile*)neighborAtDegrees:(int)degrees {
    OutletOffset *offset = [OutletOffset makeForDegrees:degrees];
    return [_board tileForCol:_colNum + offset.col andRow:_rowNum + offset.row];
}

- (id)setPower:(Power)power {
    Power fromPower = _power;
    if (fromPower != power) {
        _power = power;
        if (_watcher) {
            [_watcher tile:self powerDidChangeFrom:fromPower to:power];
        }
    }
}



@end