//
// Created by Rick Osborne on 7/27/13.
// Copyright (c) 2013 rick osborne dot org. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "GameBoard.h"

@class GameBoard;
@class ScoreKeeper;

typedef NS_ENUM(NSUInteger, BoardViewEvent) {
    BoardViewEventBoardWasRandomized,
    BoardViewEventBoardDidSettle,
    BoardViewEventBoardWillVanish,
    BoardViewEventTilesWillAppear,
    BoardViewEventTilesWillVanish,
    BoardViewEventTilesDidVanish,
    BoardViewEventTileWillSpin
};

typedef NS_ENUM(BOOL, BoardViewEventResponse) {
    BoardViewEventResponseNoReaction = NO,
    BoardViewEventResponseYeahIHandledThatForYou = YES
};

@interface BoardView : UIView <GameBoardWatcher, TileViewWatcher>

@property (nonatomic, readwrite) GameBoard *gameBoard;
@property (nonatomic, readwrite) ScoreKeeper* scoreKeeper;
@property (nonatomic, readonly) BOOL isWorking;

- (void)interruptSweep;
- (void)readyForSweep;
- (float)xForColNum:(NSUInteger)colNum;
- (float)yForRowNum:(NSUInteger)rowNum;

@end