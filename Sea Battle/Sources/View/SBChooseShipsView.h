//
//  SBChooseShipsView.h
//  Sea Battle
//
//  Created by Aleksey Bodnya on 25.04.14.
//  Copyright (c) 2014 Alexey Bodnya. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SBShipElementView.h"

@protocol SBChooseShipsViewDelegate;

@interface SBChooseShipsView : UIView <SBShipElementViewDelegate>

@property (nonatomic, weak) IBOutlet id<SBChooseShipsViewDelegate> delegate;
@property (nonatomic, strong, readonly) NSArray *ships;

- (void)load;
- (void)resetShipElementView:(SBShipElementView *)shipElementView;

@end

@protocol SBChooseShipsViewDelegate <NSObject>

@optional

- (void)chooseShipsView:(SBChooseShipsView *)chooseShipsView didDraggedShipElementView:(SBShipElementView *)shipElementView;
- (void)chooseShipsView:(SBChooseShipsView *)chooseShipsView didDroppedShipElementView:(SBShipElementView *)shipElementView;
- (void)chooseShipsView:(SBChooseShipsView *)chooseShipsView didRotateShipElementView:(SBShipElementView *)shipElementView;

@end
