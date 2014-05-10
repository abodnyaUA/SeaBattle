//
//  SBShipLayouter.m
//  Sea Battle
//
//  Created by Aleksey Bodnya on 5/6/14.
//  Copyright (c) 2014 Alexey Bodnya. All rights reserved.
//

#import "SBShipLayouter.h"

#import "SBCellCoordinate.h"
#import "SBGameFieldCell.h"
#import "SBShipElement.h"
#import "NSArrayExtensions.h"

@implementation SBShipLayouter

+ (void)layoutShips:(NSArray *)ships onCells:(NSArray *)cells
{
    for (SBShipElement *ship in ships)
    {
        if (ship.orientation == SBShipOrientationHorizontal)
        {
            for (NSUInteger x = ship.topLeftPosition.x; x < ship.topLeftPosition.x + ship.length; x++)
            {
                [cells cellWithPosition:SBCellCoordinateMake(x, ship.topLeftPosition.y)].state = SBGameFieldCellStateWithShip;
            }
        }
        else
        {
            for (NSUInteger y = ship.topLeftPosition.y; y < ship.topLeftPosition.y + ship.length; y++)
            {
                [cells cellWithPosition:SBCellCoordinateMake(ship.topLeftPosition.x, y)].state = SBGameFieldCellStateWithShip;
            }
        }
    }
}

@end
