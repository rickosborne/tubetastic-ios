//
// Created by Rick Osborne on 7/27/13.
// Copyright (c) 2013 rick osborne dot org. All rights reserved.
//


#import <Foundation/Foundation.h>

static const int BITS_SOURCED = 400;
static const int BITS_SUNK    = 100;
static const int TILE_COUNT   = (16 * 3) + 2;
static const float SCALE_OVERSIZE = 1;

@class BaseTile;

@interface TileRenderer : NSObject


+ (void)drawRoundedBoxInContext:(CGContextRef)contextRef withBounds:(CGRect)bounds andRadius:(float)cornerRadius;
+ (void)drawTile:(BaseTile *)tile inContext:(CGContextRef)contextRef withBounds:(CGRect)bounds;

@end