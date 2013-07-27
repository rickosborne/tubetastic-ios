//
// Created by Rick Osborne on 7/26/13.
// Copyright (c) 2013 rick osborne dot org. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SourceTile.h"
#import "Outlets.h"


@implementation SourceTile

- (id)initForBoard:(GameBoard*)board withCol:(int)colNum withRow:(int)rowNum {
    if (!(self = [super initForBoard:board withCol:colNum withRow:rowNum])) {
        return self;
    }
    _power = PowerSource;
    super.bits = OutletBitWest;
    return self;
}

- (void)setPower:(Power)power {}

- (void)setBits:(int)bits {}

@end