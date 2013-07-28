//
// Created by Rick Osborne on 7/25/13.
// Copyright (c) 2013 rick osborne dot org. All rights reserved.
//


#import <Foundation/Foundation.h>

//static const int BIT_WEST  = 1;
//static const int BIT_SOUTH = 2;
//static const int BIT_EAST  = 4;
//static const int BIT_NORTH = 8;

typedef NS_ENUM(NSUInteger, OutletBit) {
    OutletBitWest  = 1,
    OutletBitSouth = 2,
    OutletBitEast  = 4,
    OutletBitNorth = 8
};

@interface Outlets : NSObject

@property (nonatomic, readwrite) NSUInteger bits;

- (Outlets *)initWithBits:(NSUInteger)bits;
- (BOOL)hasOutletToDegrees:(NSUInteger)degrees;

@end