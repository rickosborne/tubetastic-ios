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

@implementation TileRenderer

static TileRenderer *singleton;

+ (TileRenderer *)defaultRenderer {
    if (!singleton) {
        singleton = [[TileRenderer alloc] init];
    }
    return singleton;
}

+ (void)drawRoundedBoxInContext:(CGContextRef)contextRef withBounds:(CGRect)bounds andRadius:(float)cornerRadius {

}

+ (void)drawTile:(BaseTile *)tile inContext:(CGContextRef)contextRef withBounds:(CGRect)bounds {
    float tileSize = bounds.size.width * SCALE_OVERSIZE;
//    float tileSize = bounds.size.width;
    float farthest = tileSize - 1.0;
    int bits = tile.bits;
    float halfStep = SCALE_OVERSIZE / 2.0;
    float halfSize = tileSize / 2.0;
    float padding = tileSize * TileView.SIZE_PADDING;
    float radius = halfSize - (padding * 2.0);
    UIColor *backColor;
    switch (tile.power) {
        case PowerSource: backColor = GamePrefs.COLOR_POWER_SOURCED; break;
        case PowerSink:   backColor = GamePrefs.COLOR_POWER_SUNK;    break;
        default:          backColor = GamePrefs.COLOR_POWER_NONE;
    }
//    [backColor set];
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
}


@end