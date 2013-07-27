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
static const float SIZE_PADDING    = 1 / 16;
static const float SIZE_ARCWIDTH   = 1 / 8;
static const float DURATION_VANISH = 0.500;
static const float DURATION_DROP   = 0.250;
static const float DURATION_APPEAR = DURATION_VANISH + DURATION_DROP;
static const float DURATION_SPIN   = 0.150;
static const float DEGREES_SPIN    = -90;
static const float DEGREES_CIRCLE  = -360;
static const float OPACITY_VANISH  = 0;
static const float OPACITY_APPEAR  = 1;
static const float SCALE_VANISH    = 0;
static const float SCALE_APPEAR    = 1;

@interface TileView : UIView <TileWatcher> {
@protected
    float _padding;
    __weak BaseTile* _tile;
    __weak TileRenderer* _renderer;
    float _midpoint;
    float _size;
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
@property (nonatomic, readwrite, weak) TileRenderer *renderer;
@property (nonatomic, readwrite, weak) BaseTile *tile;

@end
