//
// Created by Rick Osborne on 7/27/13.
// Copyright (c) 2013 rick osborne dot org. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "TubeTile.h"
#import "OutletProbability.h"
#import "Outlets.h"


@implementation TubeTile {

}

- (TubeTile *)initForBoard:(GameBoard *)board withCol:(int)colNum withRow:(int)rowNum {
    if (!(self = [super initForBoard:board withCol:colNum withRow:rowNum])) { return self; }
    _outlets = [OutletProbability randomOutlets];
    return self;
}

- (TubeTile *)initForBoard:(GameBoard *)board withCol:(int)colNum withRow:(int)rowNum withBits:(NSUInteger)bits {
    if (!(self = [super initForBoard:board withCol:colNum withRow:rowNum])) { return self; }
    _outlets.bits = bits;
    return self;
}

@end