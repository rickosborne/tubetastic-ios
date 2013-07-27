//
// Created by Rick Osborne on 7/27/13.
// Copyright (c) 2013 rick osborne dot org. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "OutletProbability.h"
#import "Outlets.h"


@implementation OutletProbability {

@private
    NSUInteger _probability;
    NSMutableArray *_outlets;
}

static NSArray *outletProbabilities;
static NSUInteger probabilityMax;

+ (void)initialize {
    probabilityMax = 100;
    outletProbabilities = @[
            [[OutletProbability alloc] initWithProbability:5 andBitsCount:1, OutletBitNorth | OutletBitEast | OutletBitSouth | OutletBitWest ],
            [[OutletProbability alloc] initWithProbability:50 andBitsCount:1,
                    OutletBitEast  | OutletBitSouth | OutletBitWest,
                    OutletBitNorth | OutletBitSouth | OutletBitWest,
                    OutletBitNorth | OutletBitEast  | OutletBitWest,
                    OutletBitNorth | OutletBitEast  | OutletBitSouth
            ],
            [[OutletProbability alloc] initWithProbability:90 andBitsCount:6,
                    OutletBitNorth | OutletBitEast,
                    OutletBitNorth | OutletBitSouth,
                    OutletBitNorth | OutletBitWest,
                    OutletBitEast  | OutletBitSouth,
                    OutletBitEast  | OutletBitWest,
                    OutletBitSouth | OutletBitWest
            ],
            [[OutletProbability alloc] initWithProbability:100 andBitsCount:4,
                    OutletBitNorth,
                    OutletBitEast,
                    OutletBitSouth,
                    OutletBitWest
            ]
    ];
}

- (OutletProbability *)initWithProbability:(NSUInteger)probability andBitsCount:(NSUInteger)count, ... {
    if (!(self = [super init])) { return self; }
    _probability = probability;
    va_list args;
    va_start(args, count);
    _outlets = [[NSMutableArray alloc] initWithCapacity:count];
    for (NSUInteger i = 0; i < count; i++) {
        [_outlets setObject:[[Outlets alloc] initWithBits:va_arg(args, int)] atIndexedSubscript:i];
    }
    va_end(args);
    return self;
}

- (BOOL)hasProbabilityAtLeast:(NSUInteger)probability {
    return (probability <= _probability);
}

- (Outlets *)randomOutlets {
    return (Outlets *) [_outlets objectAtIndex:arc4random() % _outlets.count];
}

+ (Outlets *)randomOutlets {
    NSUInteger prob = arc4random() % probabilityMax;
    for (OutletProbability *outletProb in outletProbabilities) {
        if ([outletProb hasProbabilityAtLeast:prob]) {
            return outletProb.randomOutlets;
        }
    }
    return nil;
}


@end