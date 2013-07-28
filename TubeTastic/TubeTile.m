//
// Created by Rick Osborne on 7/27/13.
// Copyright (c) 2013 rick osborne dot org. All rights reserved.
//


#import "TubeTile.h"
#import "OutletProbability.h"
#import "Outlets.h"


@implementation TubeTile {

}

- (TubeTile *)initForBoard:(GameBoard *)board withCol:(NSUInteger)colNum withRow:(NSUInteger)rowNum {
    if (!(self = [super initForBoard:board withCol:colNum withRow:rowNum])) { return self; }
    _outlets = [OutletProbability randomOutlets];
    return self;
}

- (TubeTile *)initForBoard:(GameBoard *)board withCol:(NSUInteger)colNum withRow:(NSUInteger)rowNum withBits:(NSUInteger)bits {
    if (!(self = [super initForBoard:board withCol:colNum withRow:rowNum])) { return self; }
    if (bits > 0) {
        _outlets.bits = bits;
    } else {
        _outlets = [OutletProbability randomOutlets];
    }
    return self;
}

@end