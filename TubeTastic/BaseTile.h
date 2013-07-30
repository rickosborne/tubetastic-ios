//
// Created by Rick Osborne on 7/25/13.
// Copyright (c) 2013 rick osborne dot org. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "Power.h"

@class GameBoard;
@class Outlets;
@class BaseTile;

@protocol TileWatcher

- (void)tile:(BaseTile *)tile powerDidChangeFrom:(Power)fromPower to:(Power)toPower;
- (void)tile:(BaseTile *)tile movedFromCol:(NSUInteger)fromColNum fromRow:(NSUInteger)fromRowNum toCol:(NSUInteger)toColNum toRow:(NSUInteger)toRowNum;
- (void)tile:(BaseTile *)tile didSpinFrom:(int)fromDegrees to:(int)toDegrees;
- (void)tileDidVanish:(BaseTile *)tile;

@end

static const int DEGREES_NORTH =   0;
static const int DEGREES_EAST  =  90;
static const int DEGREES_SOUTH = 180;
static const int DEGREES_WEST  = 270;
static const int directionCount = 4;
static const int outletDegrees[] = {DEGREES_NORTH, DEGREES_EAST, DEGREES_SOUTH, DEGREES_WEST};

@interface BaseTile : NSObject
{
@protected
    NSUInteger _colNum;
    NSUInteger _rowNum;
    NSUInteger _id;
    __weak GameBoard* _board;
    Power _power;
    Outlets* _outlets;
    int _outletRotation;
    __weak id <TileWatcher> _watcher;
}
@property (nonatomic, readonly) NSUInteger colNum;
@property (nonatomic, readonly) NSUInteger rowNum;
@property (nonatomic, readonly) NSUInteger id;
@property (nonatomic, readwrite) Power power;
@property (nonatomic, readonly, weak) NSArray* connectedNeighbors;
@property (nonatomic, readwrite, weak) id <TileWatcher> watcher;
@property (nonatomic, readwrite) NSUInteger bits;

int unrotateDegrees(int outletRotation, int degrees);
int reverseDirectionDegrees(int degrees);

//+ (int)degreesFromDirection:(NSString*)direction;

+ (NSUInteger)makeIdFromCol:(NSUInteger)colNum andRow:(NSUInteger)rowNum;
- (BaseTile *)initForBoard:(GameBoard*)board withCol:(NSUInteger)colNum withRow:(NSUInteger)rowNum;
- (BaseTile *)neighborAtDegrees:(int)degrees;
- (NSArray *)connectedNeighbors;
- (BOOL)hasOutletToDegrees:(int)degrees;
- (BOOL)isSourced;
- (BOOL)isSunk;
- (BOOL)isUnpowered;
- (void)setCol:(NSUInteger)colNum andRow:(NSUInteger)rowNum;
- (void)spin;
- (void)vanish;

@end