//
//  SBShipPositionController.h
//  Sea Battle
//
//  Created by Aleksey Bodnya on 4/28/14.
//  Copyright (c) 2014 Alexey Bodnya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBShipElement.h"
#import "SBGameFieldView.h"

@interface SBShipPositionController : NSObject

@property (nonatomic, strong) NSArray *ships;
@property (nonatomic, weak  ) SBGameFieldView *fieldView;

- (BOOL)canMoveShip:(SBShipElement *)ship toPosition:(SBCellCoordinate)position;
- (void)rotateShipElement:(SBShipElement *)shipElement;
- (void)moveShipElement:(SBShipElement *)shipElement toPosition:(SBCellCoordinate)position;
- (BOOL)allShipsOnField;

@end
