//
//  SBAIAutomaticShipLayouter.m
//  Sea Battle
//
//  Created by Aleksey Bodnya on 5/6/14.
//  Copyright (c) 2014 Alexey Bodnya. All rights reserved.
//

#import "SBAIAutomaticShipLayouter.h"
#import "SBGameFieldCell.h"
#import "NSArrayExtensions.h"
#import "SBShipElement.h"
#import "SBShipLayouter.h"
#import "SBShipPositionController.h"


@interface SBAIAutomaticShipLayouter ()

@property (nonatomic, strong) NSArray *ships;

@end

@implementation SBAIAutomaticShipLayouter

- (void)startSetup
{
    [self loadCells];
    [self loadShips];
    [self layoutShips];
    [self.cells printShips];
}

- (void)loadCells
{
    self.cells = [NSArray emptyCells];
}

- (void)loadShips
{
    NSMutableArray *ships = [NSMutableArray array];
    for (NSUInteger shipLength = 4; shipLength >= 1; shipLength--)
    {
        NSUInteger maxCount = 4 - shipLength;
        
        for (NSUInteger shipCount = 0; shipCount <= maxCount; shipCount++)
        {
            SBShipElement *ship = [SBShipElement shipWithLength:shipLength];
            [ships addObject:ship];
        }
    }
    self.ships = [ships copy];
}

- (void)layoutShips
{
    SBShipPositionController *positionController = [SBShipPositionController new];
    positionController.ships = self.ships;
    for (SBShipElement *ship in self.ships)
    {
        ship.orientation = 0 == arc4random() % 2 ? SBShipOrientationHorizontal : SBShipOrientationVertical;
        
        SBCellCoordinate position;
        BOOL canMove;
        do
        {
            position = SBCellCoordinateMake(arc4random() % 10, arc4random() % 10);
            canMove = [positionController canMoveShip:ship toPosition:position];
        } while (!canMove);
    }
    
    [SBShipLayouter layoutShips:self.ships onCells:self.cells];
}

@end
