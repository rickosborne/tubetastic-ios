//
// Created by Rick Osborne on 7/25/13.
// Copyright (c) 2013 rick osborne dot org. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

static const NSString* DIRECTION_NORTH = @"N";
static const NSString* DIRECTION_SOUTH = @"S";
static const NSString* DIRECTION_EAST  = @"E";
static const NSString* DIRECTION_WEST  = @"W";
static const int DEGREES_NORTH =   0;
static const int DEGREES_EAST  =  90;
static const int DEGREES_SOUTH = 180;
static const int DEGREES_WEST  = 270;
static const int directionCount = 4;
static const int outletDegrees[] = {DEGREES_NORTH, DEGREES_EAST, DEGREES_SOUTH, DEGREES_WEST};
static const NSString* outletDirections[] = { @"N", @"E", @"S", @"W" };
static const NSDictionary* directionFromDegrees;
static const NSDictionary* outletOffsets;
static const NSDictionary* outletRotationsReverse;

@interface OutletOffset : NSObject

@property int col;
@property int row;

@end

@interface BaseTile : NSObject

+ (int)makeIdFromCol:(int)colNum andRow:(int)rowNum;
+ (int)degreesFromDirection:(NSString*)direction;

@end