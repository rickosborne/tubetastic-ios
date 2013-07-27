//
// Created by Rick Osborne on 7/27/13.
// Copyright (c) 2013 rick osborne dot org. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface BoardView : UIView

@property (nonatomic, readonly) BOOL isWorking;

- (void)interruptSweep;
- (void)readyForSweep;
- (float)xForColNum:(int)colNum;
- (float)yForRowNum:(int)rowNum;

@end