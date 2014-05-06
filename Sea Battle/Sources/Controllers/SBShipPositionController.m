//
//  SBShipPositionController.m
//  Sea Battle
//
//  Created by Aleksey Bodnya on 4/28/14.
//  Copyright (c) 2014 Alexey Bodnya. All rights reserved.
//

#import "SBShipPositionController.h"

#import "SBCellCoordinate.h"
#import "NSArray+SBGameFieldCell.h"
#import "SBGameController.h"

@interface SBShipPositionController ()

@end

@implementation SBShipPositionController

- (void)rotateShipElementView:(SBShipElementView *)shipElementView
{
    SBCellCoordinate coordinate = SBCellCoordinateOfShipElementView(shipElementView);
    if (shipElementView.ship.orientation == SBShipOrientationHorizontal)
    {
        shipElementView.ship.orientation = SBShipOrientationVertical;
        if (coordinate.y >= 10 - shipElementView.ship.length)
        {
            if ([self canMoveShipElementView:shipElementView toPosition:SBCellCoordinateMake(coordinate.x, 10 - shipElementView.ship.length)])
            {
                shipElementView.ship.orientation = SBShipOrientationHorizontal;
                [self moveShipElementView:shipElementView toPosition:SBCellCoordinateMake(coordinate.x, 10 - shipElementView.ship.length)];
                [shipElementView rotate];
            }
            else
            {
                shipElementView.ship.orientation = SBShipOrientationHorizontal;
            }
        }
        else
        {
            if ([self canMoveShipElementView:shipElementView toPosition:coordinate])
            {
                shipElementView.ship.orientation = SBShipOrientationHorizontal;
                [shipElementView rotate];
            }
            else
            {
                shipElementView.ship.orientation = SBShipOrientationHorizontal;
            }
        }
    }
    else
    {
        shipElementView.ship.orientation = SBShipOrientationHorizontal;
        if (coordinate.x >= 10 - shipElementView.ship.length)
        {
            if ([self canMoveShipElementView:shipElementView toPosition:SBCellCoordinateMake(10 - shipElementView.ship.length, coordinate.y)])
            {
                shipElementView.ship.orientation = SBShipOrientationVertical;
                [self moveShipElementView:shipElementView toPosition:SBCellCoordinateMake(10 - shipElementView.ship.length, coordinate.y)];
                [shipElementView rotate];
            }
            else
            {
                shipElementView.ship.orientation = SBShipOrientationVertical;
            }
        }
        else
        {
            if ([self canMoveShipElementView:shipElementView toPosition:coordinate])
            {
                shipElementView.ship.orientation = SBShipOrientationVertical;
                [shipElementView rotate];
            }
            else
            {
                shipElementView.ship.orientation = SBShipOrientationVertical;
            }
        }
    }
}

- (void)moveShipElementView:(SBShipElementView *)shipElementView toPosition:(SBCellCoordinate)position
{
    CGFloat cellSize = [[[SBGameController sharedController] gameFieldView] cellSize];
    
    if (![self canMoveShipElementView:shipElementView toPosition:position])
    {
        position = shipElementView.ship.topLeftPosition;
    }
    
    if (SBCellCoordinateIsValid(position))
    {
    
        CGFloat x = position.x * cellSize;
        CGFloat y = position.y * cellSize + self.fieldView.frame.origin.y;
        shipElementView.frame = CGRectMake(x, y, shipElementView.frame.size.width, shipElementView.frame.size.height);
        shipElementView.backgroundColor = [UIColor clearColor]; // TODO: Better higlight
    }
}

- (BOOL)canMoveShipElementView:(SBShipElementView *)shipElementView toPosition:(SBCellCoordinate)position
{
    SBCellCoordinate coordinate = position;
    BOOL result = YES;
    if (SBCellCoordinateIsValid(position))
    {
        if (shipElementView.ship.orientation == SBShipOrientationHorizontal)
        {
            result = coordinate.x <= 10-shipElementView.ship.length && coordinate.y < 10;
        }
        else
        {
            result = coordinate.y <= 10-shipElementView.ship.length && coordinate.x < 10;
        }
        
        if (result)
        {
            SBCellCoordinate lastAvailablePosition = shipElementView.ship.topLeftPosition;
            shipElementView.ship.topLeftPosition = coordinate;
            result = [self hasConflictWithOtherShipsShip:shipElementView.ship];
            if (!result)
            {
                shipElementView.ship.topLeftPosition = lastAvailablePosition;
            }
        }
    }
    else
    {
        result = NO;
    }
    
    return result;
}

- (BOOL)hasConflictWithOtherShipsShip:(SBShipElement *)ship
{
    NSArray *cellsForEvaluatedShip = [self reservedCellsForShip:ship usingBorder:NO];
    NSArray *cellsForOtherShips = [self reservedCellsForShips:[self shipsWithoutShip:ship]];
    NSArray *conflictedCells =
    [cellsForOtherShips filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NSValue *other, NSDictionary *bindings) {
        BOOL result = NO;
        SBCellCoordinate coordinateOther = SBCellCoordinateDecoded(other);
        for (NSValue *evaluated in cellsForEvaluatedShip)
        {
            SBCellCoordinate coordinateEvaluated = SBCellCoordinateDecoded(evaluated);
            if (!result)
            {
                result = SBCellCoordinateEquals(coordinateOther, coordinateEvaluated);
            }
        }
        return result;
    }]];
    return [conflictedCells count] == 0;
}

- (NSArray *)reservedCellsForShip:(SBShipElement *)ship usingBorder:(BOOL)isUseBorder
{
    NSMutableArray *cells = [NSMutableArray array];
    SBCellCoordinate shipPosition = ship.topLeftPosition;
    if (ship.orientation == SBShipOrientationHorizontal)
    {
        for (NSUInteger x = shipPosition.x; x < shipPosition.x + ship.length; x++)
        {
            [cells addObject:SBCellCoordinateEncoded(SBCellCoordinateMake(x, shipPosition.y))];
        }
        if (isUseBorder)
        {
            NSUInteger min = shipPosition.x > 0 ? shipPosition.x - 1 : 0;
            NSUInteger max = shipPosition.x + ship.length < 10 ? shipPosition.x + ship.length : 9;
            for (NSUInteger x = min; x <= max; x++)
            {
                [cells addObject:SBCellCoordinateEncoded(SBCellCoordinateMake(x, shipPosition.y - 1))];
                [cells addObject:SBCellCoordinateEncoded(SBCellCoordinateMake(x, shipPosition.y + 1))];
            }
            [cells addObject:SBCellCoordinateEncoded(SBCellCoordinateMake(min, shipPosition.y))];
            [cells addObject:SBCellCoordinateEncoded(SBCellCoordinateMake(max, shipPosition.y))];
        }
    }
    else
    {
        for (NSUInteger y = shipPosition.y; y < shipPosition.y + ship.length; y++)
        {
            [cells addObject:SBCellCoordinateEncoded(SBCellCoordinateMake(shipPosition.x, y))];
        }
        if (isUseBorder)
        {
            NSUInteger min = shipPosition.y > 0 ? shipPosition.y - 1 : 0;
            NSUInteger max = shipPosition.y + ship.length < 10 ? shipPosition.y + ship.length : 9;
            for (NSUInteger y = min; y <= max; y++)
            {
                [cells addObject:SBCellCoordinateEncoded(SBCellCoordinateMake(shipPosition.x - 1, y))];
                [cells addObject:SBCellCoordinateEncoded(SBCellCoordinateMake(shipPosition.x + 1, y))];
            }
            [cells addObject:SBCellCoordinateEncoded(SBCellCoordinateMake(shipPosition.x, min))];
            [cells addObject:SBCellCoordinateEncoded(SBCellCoordinateMake(shipPosition.x, max))];
        }
    }
    [cells filterUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NSValue *evaluatedObject, NSDictionary *bindings) {
        SBCellCoordinate coordinate = SBCellCoordinateDecoded(evaluatedObject);
        return SBCellCoordinateIsValid(coordinate);
    }]];
    return [cells copy];
}

- (NSArray *)reservedCellsForShips:(NSArray *)ships
{
    NSMutableArray *cells = [NSMutableArray array];
    for (SBShipElement *ship in ships)
    {
        [cells addObjectsFromArray:[self reservedCellsForShip:ship usingBorder:YES]];
    }
    return [cells copy];
}

- (NSArray *)shipsWithoutShip:(SBShipElement *)aShip
{
    NSArray *ships =
    [self.ships filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(SBShipElement *ship, NSDictionary *bindings) {
        return ship != aShip;
    }]];
    return ships;
}

- (BOOL)allShipsOnField
{
    NSArray *ships = [self.ships filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(SBShipElement *ship, NSDictionary *bindings) {
        return !SBCellCoordinateIsValid(ship.topLeftPosition);
    }]];
    return ships.count == 0;
}

@end
