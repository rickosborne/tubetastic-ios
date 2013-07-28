//
// Created by Rick Osborne on 7/26/13.
// Copyright (c) 2013 rick osborne dot org. All rights reserved.
//


#import "OutletOffset.h"


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
