//
//  SBShipPositionController.h
//  Sea Battle
//
//  Created by Aleksey Bodnya on 4/28/14.
//  Copyright (c) 2014 Alexey Bodnya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBShipElementView.h"
#import "SBGameFieldView.h"

@interface SBShipPositionController : NSObject

@property (nonatomic, strong) NSArray *ships;

- (BOOL)canMoveShipElementView:(SBShipElementView *)shipElementView toPosition:(SBCellCoordinate)position;
- (void)rotateShipElementView:(SBShipElementView *)shipElementView;
- (void)moveShipElementView:(SBShipElementView *)shipElementView toPosition:(SBCellCoordinate)position;

@end
