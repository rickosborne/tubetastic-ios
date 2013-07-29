//
//  TileView.h
//  TubeTastic
//
//  Created by Rick Osborne on 7/25/13.
//  Copyright (c) 2013 rick osborne dot org. All rights reserved.
//

#import "BaseTile.h"

@class TileView;

@protocol TileViewWatcher

- (void)tileViewDidStartSpinning:(TileView*)tileView;
- (void)tileViewDidFinishSpinning:(TileView *)tileView;
- (void)tileViewDidStartVanishing:(TileView*)tileView;
- (void)tileViewDidFinishVanishing:(TileView *)tileView;
- (void)tileViewDidStartMoving:(TileView*)tileView;
- (void)tileViewDidFinishMoving:(TileView *)tileView;
- (void)tileViewDidStartAppearing:(TileView*)tileView;
- (void)tileViewDidFinishAppearing:(TileView *)tileView;

@end

@class TileRenderer;
@class TileActorWatcher;

@interface TileView : UIView <TileWatcher> {
@protected
    float _padding;
    EmptyTile *_tile;
    float _midpoint;
    float _size;
    NSUInteger _totalSpins;
    int _spinRemain;
    BOOL _isSpinning;
    BOOL _isVanishing;
    BOOL _isDropping;
    BOOL _isAppearing;
    __weak id<TileViewWatcher> _watcher;
}

@property (nonatomic, readonly) BOOL isSpinning;
@property (nonatomic, readonly) BOOL isVanishing;
@property (nonatomic, readonly) BOOL isAppearing;
@property (nonatomic, readonly) BOOL isDropping;
@property (nonatomic, readwrite, weak) id<TileViewWatcher> watcher;
@property (nonatomic, readonly) float size;
//@property (nonatomic, readwrite) TileRenderer *renderer;
@property (nonatomic, readwrite) EmptyTile *tile;

@property (nonatomic, readwrite) float SIZE_PADDING;
@property (nonatomic, readwrite) float SIZE_ARCWIDTH;
@property (nonatomic, readwrite) float DURATION_VANISH;
@property (nonatomic, readwrite) float DURATION_DROP;
@property (nonatomic, readwrite) float DURATION_APPEAR;
@property (nonatomic, readwrite) float DURATION_SPIN;
@property (nonatomic, readwrite) float DEGREES_SPIN;
@property (nonatomic, readwrite) float DEGREES_CIRCLE;
@property (nonatomic, readwrite) float OPACITY_VANISH;
@property (nonatomic, readwrite) float OPACITY_APPEAR;
@property (nonatomic, readwrite) float SCALE_VANISH;
@property (nonatomic, readwrite) float SCALE_APPEAR;

- (void)appear;

+(float)SIZE_PADDING;
+(float)SIZE_ARCWIDTH;
+(float)DURATION_VANISH;
+(float)DURATION_DROP;
+(float)DURATION_APPEAR;
+(float)DURATION_SPIN;
+(float)DEGREES_SPIN;
+(float)DEGREES_CIRCLE;
+(float)OPACITY_VANISH;
+(float)OPACITY_APPEAR;
+(float)SCALE_VANISH;
+(float)SCALE_APPEAR;

@end
