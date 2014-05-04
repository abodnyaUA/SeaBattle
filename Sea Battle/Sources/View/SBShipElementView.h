//
//  SBShipElementView.h
//  Sea Battle
//
//  Created by Aleksey Bodnya on 25.04.14.
//  Copyright (c) 2014 Alexey Bodnya. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SBShipElement.h"
#import "SBCellCoordinate.h"

@protocol SBShipElementViewDelegate;

@interface SBShipElementView : UIView

@property (nonatomic, strong) SBShipElement *ship;
@property (nonatomic, weak) IBOutlet id<SBShipElementViewDelegate> delegate;
@property (nonatomic, assign) CGPoint defaultPoint;
@property (nonatomic, assign) BOOL didUsed;

- (id)initWithShipLength:(NSUInteger)length withCellSize:(CGFloat)cellSize inPoint:(CGPoint)point;
- (void)rotate;

@end

@protocol SBShipElementViewDelegate <NSObject>

- (void)shipElementViewDidDragged:(SBShipElementView *)shipElementView;
- (void)shipElementViewDidDropped:(SBShipElementView *)shipElementView;
- (void)shipElementViewDidTapped:(SBShipElementView *)shipElementView;

@end
