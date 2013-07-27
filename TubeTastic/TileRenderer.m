//
// Created by Rick Osborne on 7/27/13.
// Copyright (c) 2013 rick osborne dot org. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "TileRenderer.h"
#import "BaseTile.h"
#import "TileView.h"
#import "GamePrefs.h"
#import "SourceTile.h"
#import "SinkTile.h"
#import "Outlets.h"

@implementation TileRenderer

static TileRenderer *singleton;
static const float PI = 3.14159265f;
static const float DEGREES_TO_RADIANS = PI / 180.0;
static const float RADIANS_NORTH1 = -90.0 * DEGREES_TO_RADIANS;
static const float RADIANS_NORTH2 = 270.0 * DEGREES_TO_RADIANS;
static const float RADIANS_EAST = 0;
static const float RADIANS_SOUTH = 90.0 * DEGREES_TO_RADIANS;
static const float RADIANS_WEST = PI;

+ (TileRenderer *)defaultRenderer {
    if (!singleton) {
        singleton = [[TileRenderer alloc] init];
    }
    return singleton;
}

+ (void)drawTile:(BaseTile *)tile inContext:(CGContextRef)contextRef withBounds:(CGRect)bounds {
    float tileSize = bounds.size.width * SCALE_OVERSIZE;
    int bits = tile.bits;
    float halfSize = tileSize / 2.0;
    float padding = tileSize * TileView.SIZE_PADDING;
    float radius = halfSize - (padding * 2.0);
    UIColor *backColor;
    switch (tile.power) {
        case PowerSource: backColor = GamePrefs.COLOR_POWER_SOURCED; break;
        case PowerSink:   backColor = GamePrefs.COLOR_POWER_SUNK;    break;
        default:          backColor = GamePrefs.COLOR_POWER_NONE;
    }
    CGContextSetFillColorWithColor(contextRef, backColor.CGColor);
    if ([tile isKindOfClass:SourceTile.class] || [tile isKindOfClass:SinkTile.class]) {
        CGRect circle = CGRectMake(halfSize - radius, halfSize - radius, radius * 2.0, radius * 2.0);
        CGContextFillEllipseInRect(contextRef, circle);
    }
    else {
        float cornerRadius = padding * 2.0;
        float leftX = padding;
        float rightX = tileSize - padding;
        float midX = (rightX - leftX) * 0.5;
        float topY = rightX;
        float bottomY = padding;
        float midY = (topY - bottomY) * 0.5;
        CGContextSetStrokeColorWithColor(contextRef, backColor.CGColor);
        CGContextMoveToPoint(contextRef, leftX, topY - cornerRadius);
        CGContextAddArcToPoint(contextRef, leftX, bottomY, midX, bottomY, cornerRadius);
        CGContextAddArcToPoint(contextRef, rightX, bottomY, rightX, midY, cornerRadius);
        CGContextAddArcToPoint(contextRef, rightX, topY, midX, topY, cornerRadius);
        CGContextAddArcToPoint(contextRef, leftX, topY, leftX, midY, cornerRadius);
        CGContextFillPath(contextRef);
    }
    float arcSize = tileSize * TileView.SIZE_ARCWIDTH;
    CGContextSetStrokeColorWithColor(contextRef, GamePrefs.COLOR_ARC.CGColor);
    CGContextSetLineWidth(contextRef, arcSize);
    if (bits == OutletBitWest) {
        CGContextMoveToPoint(contextRef, 0, halfSize);
        CGContextAddLineToPoint(contextRef, halfSize, halfSize);
    }
    else if (bits == OutletBitSouth) {
        CGContextMoveToPoint(contextRef, halfSize, halfSize);
        CGContextAddLineToPoint(contextRef, halfSize, tileSize);
    }
    else if (bits == OutletBitEast) {
        CGContextMoveToPoint(contextRef, halfSize, halfSize);
        CGContextAddLineToPoint(contextRef, tileSize, halfSize);
    }
    else if (bits == OutletBitNorth) {
        CGContextMoveToPoint(contextRef, halfSize, 0);
        CGContextAddLineToPoint(contextRef, halfSize, halfSize);
    }
    else {
        if ((bits & OutletBitWest) != 0 && (bits & OutletBitEast) != 0) {
            CGContextMoveToPoint(contextRef, 0, halfSize);
            CGContextAddLineToPoint(contextRef, tileSize, halfSize);
        }
        if ((bits & OutletBitNorth) != 0 && (bits & OutletBitSouth) != 0) {
            CGContextMoveToPoint(contextRef, halfSize, 0);
            CGContextAddLineToPoint(contextRef, halfSize, tileSize);
        }
        if ((bits & OutletBitNorth) != 0 && (bits & OutletBitEast) != 0) {
            CGContextMoveToPoint(contextRef, halfSize, 0);
            CGContextAddArc(contextRef, tileSize, 0, halfSize, RADIANS_WEST, RADIANS_SOUTH, 1);
        }
        if ((bits & OutletBitNorth) != 0 && (bits & OutletBitWest) != 0) {
            CGContextMoveToPoint(contextRef, 0, halfSize);
            CGContextAddArc(contextRef, 0, 0, halfSize, RADIANS_SOUTH, RADIANS_EAST, 1);
        }
        if ((bits & OutletBitSouth) != 0 && (bits & OutletBitWest) != 0) {
            CGContextMoveToPoint(contextRef, halfSize, tileSize);
            CGContextAddArc(contextRef, 0, tileSize, halfSize, RADIANS_EAST, RADIANS_NORTH1, 1);
        }
        if ((bits & OutletBitSouth) != 0 && (bits & OutletBitEast) != 0) {
            CGContextMoveToPoint(contextRef, tileSize, halfSize);
            CGContextAddArc(contextRef, tileSize, tileSize, halfSize, RADIANS_NORTH1, RADIANS_WEST, 1);
        }
    }
    CGContextStrokePath(contextRef);
}


@end