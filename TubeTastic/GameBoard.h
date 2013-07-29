//
// Created by Rick Osborne on 7/25/13.
// Copyright (c) 2013 rick osborne dot org. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "EmptyTile.h"

@class TileChangeSet;

typedef NS_ENUM(NSUInteger, TileType) {
    TileTypeSource = 1,
    TileTypeTube   = 2,
    TileTypeSink   = 3
};

@protocol GameBoardWatcher

- (void)scoreDidChangeFrom:(NSUInteger)fromScore to:(NSUInteger)toScore;

@end


@interface GameBoard : NSObject

@property (nonatomic, readwrite) id<GameBoardWatcher> watcher;
@property (nonatomic, readonly) BOOL settled;
@property (nonatomic, readonly) NSUInteger colCount;
@property (nonatomic, readonly) NSUInteger rowCount;
@property (nonatomic, readonly) NSUInteger score;

- (GameBoard *)initWithColCount:(NSUInteger)colCount rowCount:(NSUInteger)rowCount;
- (EmptyTile *)tileForCol:(NSUInteger)colNum andRow:(NSUInteger)rowNum;

- (void)randomizeTiles;

- (TileChangeSet *)powerSweep;

@end