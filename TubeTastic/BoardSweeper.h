//
// Created by Rick Osborne on 7/28/13.
// Copyright (c) 2013 rick osborne dot org. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface BoardSweeper : NSObject


- (TileChangeSet *)sweepBoard:(GameBoard *)board;

@end