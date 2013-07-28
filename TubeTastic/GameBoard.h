//
// Created by Rick Osborne on 7/25/13.
// Copyright (c) 2013 rick osborne dot org. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "BaseTile.h"

typedef NS_ENUM(NSUInteger, TileType) {
    TileTypeSource = 1,
    TileTypeTube   = 2,
    TileTypeSink   = 3
};

@protocol GameBoardWatcher

- (void)scoreDidChangeFrom:(NSUInteger)fromScore to:(NSUInteger)toScore;

@end


@interface GameBoard : NSObject

- (BaseTile*)tileForCol:(int)colNum andRow:(int)rowNum;

@end