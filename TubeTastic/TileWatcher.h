//
// Created by Rick Osborne on 7/25/13.
// Copyright (c) 2013 rick osborne dot org. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "BaseTile.h"

@interface TileWatcher : NSObject


- (void)tile:(BaseTile*)tile powerDidChangeFrom:(Power)fromPower to:(Power)toPower;

@end