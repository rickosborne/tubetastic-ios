//
// Created by Rick Osborne on 7/25/13.
// Copyright (c) 2013 rick osborne dot org. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "Outlets.h"
#import "BaseTile.h"


@implementation Outlets {
@private
    NSUInteger _bits;
}
@synthesize bits = _bits;

- (Outlets *)initWithBits:(NSUInteger)bits {
    if (!(self = [super init])) { return self; }
    self.bits = bits;
    return self;
}

- (void)setBits:(NSUInteger)bits {
    _bits = bits & (OutletBitNorth | OutletBitEast | OutletBitSouth | OutletBitWest);
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%s%s%s%s",
        (_bits & OutletBitNorth) != 0 ? "N" : "",
        (_bits & OutletBitEast)  != 0 ? "E" : "",
        (_bits & OutletBitSouth) != 0 ? "S" : "",
        (_bits & OutletBitWest)  != 0 ? "W" : ""
    ];
}

- (BOOL)hasOutletToDegrees:(NSUInteger)degrees {
    switch (degrees) {
        case DEGREES_NORTH: return (_bits & OutletBitNorth) != 0;
        case DEGREES_EAST : return (_bits & OutletBitEast)  != 0;
        case DEGREES_SOUTH: return (_bits & OutletBitSouth) != 0;
        case DEGREES_WEST : return (_bits & OutletBitWest)  != 0;
        default: return NO;
    }
}

@end