//
// Created by Rick Osborne on 7/26/13.
// Copyright (c) 2013 rick osborne dot org. All rights reserved.
//


#import "SinkTile.h"
#import "Outlets.h"


@implementation SinkTile

- (SinkTile *)initForBoard:(GameBoard*)board withCol:(NSUInteger)colNum withRow:(NSUInteger)rowNum {
    if (!(self = [super initForBoard:board withCol:colNum withRow:rowNum])) {
        return self;
    }
    _power = PowerSink;
    super.bits = OutletBitWest;
    return self;
}

- (void)setPower:(Power)power {}

- (void)setBits:(NSUInteger)bits {}

@end