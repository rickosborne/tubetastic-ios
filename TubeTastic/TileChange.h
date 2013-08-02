//
// Created by Rick Osborne on 7/28/13.
// Copyright (c) 2013 rick osborne dot org. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "Power.h"

@class BaseTile;

@interface TileChange : NSObject

@property (nonatomic, readonly) BaseTile *tile;

- (id)initWithTile:(BaseTile *)tile;

@end

// ------------------------------------------------------------------

@interface TileChangePower : TileChange

@property (nonatomic, readonly) Power power;

+ (TileChangePower *)makeWithTile:(BaseTile *)tile andPower:(Power)power;
- (TileChangePower *)initWithTile:(BaseTile *)tile andPower:(Power)power;

@end

// ------------------------------------------------------------------

@interface TileChangeMove : TileChange

@property (nonatomic, readonly) NSUInteger fromCol;
@property (nonatomic, readonly) NSUInteger fromRow;
@property (nonatomic, readonly) NSUInteger toCol;
@property (nonatomic, readonly) NSUInteger toRow;

+ (TileChangeMove *)makeWithTile:(BaseTile *)tile fromCol:(NSUInteger)fromCol fromRow:(NSUInteger)fromRow toCol:(NSUInteger)toCol toRow:(NSUInteger)toRow;
- (TileChangeMove *)initWithTile:(BaseTile *)tile fromCol:(NSUInteger)fromCol fromRow:(NSUInteger)fromRow toCol:(NSUInteger)toCol toRow:(NSUInteger)toRow;

@end

// ------------------------------------------------------------------

@interface TileChangeAppear : TileChange

@property (nonatomic, readonly) NSUInteger colNum;
@property (nonatomic, readonly) NSUInteger rowNum;

+ (TileChangeAppear *)makeWithTile:(BaseTile *)tile colNum:(NSUInteger)colNum rowNum:(NSUInteger)rowNum;
- (TileChangeAppear *)initWithTile:(BaseTile *)tile colNum:(NSUInteger)colNum rowNum:(NSUInteger)rowNum;

@end

// ------------------------------------------------------------------

@interface TileChangeSet : NSObject

@property (nonatomic, readonly) NSMutableArray *moved;
@property (nonatomic, readonly) NSMutableArray *powered;
@property (nonatomic, readonly) NSMutableArray *vanished;
@property (nonatomic, readonly) NSMutableArray *appeared;

- (TileChangeSet *)initWithMaxTileCount:(NSUInteger)maxTileCount;

@end