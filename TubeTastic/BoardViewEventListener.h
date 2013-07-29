//
// Created by Rick Osborne on 7/29/13.
// Copyright (c) 2013 rick osborne dot org. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "BoardView.h"

@class TubeTile;


@protocol BoardViewEventListener <NSObject>

@optional
- (BoardViewEventResponse)boardWasRandomized;
- (BoardViewEventResponse)boardDidSettle;
- (BoardViewEventResponse)boardWillVanish;
- (BoardViewEventResponse)tilesWillAppear;
- (BoardViewEventResponse)tilesWillVanish;
- (BoardViewEventResponse)tilesDidVanish;
- (BoardViewEventResponse)tileWillSpin:(TubeTile *)tile;

@end