//
// Created by Rick Osborne on 7/28/13.
// Copyright (c) 2013 rick osborne dot org. All rights reserved.
//


#import <Foundation/Foundation.h>

@class GameBoard;


@interface EmptyTile : NSObject {
@protected
    NSUInteger _colNum;
    NSUInteger _rowNum;
    NSUInteger _id;
    __weak GameBoard* _board;
}

@property (nonatomic, readonly) NSUInteger colNum;
@property (nonatomic, readonly) NSUInteger rowNum;
@property (nonatomic, readonly) NSUInteger id;
@property (nonatomic, readonly) EmptyTile *empty;

+ (EmptyTile *)empty;
+ (NSUInteger)makeIdFromCol:(NSUInteger)colNum andRow:(NSUInteger)rowNum;
- (EmptyTile *)initForBoard:(GameBoard*)board withCol:(NSUInteger)colNum withRow:(NSUInteger)rowNum;
- (BOOL)isEmpty;

@end