//
//  SBShipPositionController.m
//  Sea Battle
//
//  Created by Aleksey Bodnya on 4/28/14.
//  Copyright (c) 2014 Alexey Bodnya. All rights reserved.
//

#import "SBShipPositionController.h"

#import "SBCellCoordinate.h"
#import "NSArrayExtensions.h"
#import "SBGameController.h"

@interface SBShipPositionController ()

@end

@implementation SBShipPositionController

- (void)rotateShipElement:(SBShipElement *)ship
{
    SBCellCoordinate coordinate = ship.topLeftPosition;
    if (ship.orientation == SBShipOrientationHorizontal)
    {
        ship.orientation = SBShipOrientationVertical;
        if (coordinate.y >= 10 - ship.length)
        {
            if ([self canMoveShip:ship toPosition:SBCellCoordinateMake(coordinate.x, 10 - ship.length)])
            {
                ship.orientation = SBShipOrientationHorizontal;
                [self moveShipElement:ship toPosition:SBCellCoordinateMake(coordinate.x, 10 - ship.length)];
                if ([ship.delegate respondsToSelector:@selector(shipDidRotated:)])
                {
                    [ship.delegate shipDidRotated:ship];
                }
            }
            else
            {
                ship.orientation = SBShipOrientationHorizontal;
            }
        }
        else
        {
            if ([self canMoveShip:ship toPosition:coordinate])
            {
                ship.orientation = SBShipOrientationHorizontal;
                if ([ship.delegate respondsToSelector:@selector(shipDidRotated:)])
                {
                    [ship.delegate shipDidRotated:ship];
                }
            }
            else
            {
                ship.orientation = SBShipOrientationHorizontal;
            }
        }
    }
    else
    {
        ship.orientation = SBShipOrientationHorizontal;
        if (coordinate.x >= 10 - ship.length)
        {
            if ([self canMoveShip:ship toPosition:SBCellCoordinateMake(10 - ship.length, coordinate.y)])
            {
                ship.orientation = SBShipOrientationVertical;
                [self moveShipElement:ship toPosition:SBCellCoordinateMake(10 - ship.length, coordinate.y)];
                if ([ship.delegate respondsToSelector:@selector(shipDidRotated:)])
                {
                    [ship.delegate shipDidRotated:ship];
                }
            }
            else
            {
                ship.orientation = SBShipOrientationVertical;
            }
        }
        else
        {
            if ([self canMoveShip:ship toPosition:coordinate])
            {
                ship.orientation = SBShipOrientationVertical;
                if ([ship.delegate respondsToSelector:@selector(shipDidRotated:)])
                {
                    [ship.delegate shipDidRotated:ship];
                }
            }
            else
            {
                ship.orientation = SBShipOrientationVertical;
            }
        }
    }
}

- (void)moveShipElement:(SBShipElement *)ship toPosition:(SBCellCoordinate)position
{
    if (![self canMoveShip:ship toPosition:position])
    {
        position = ship.topLeftPosition;
    }
    
    if (SBCellCoordinateIsValid(position))
    {
        if ([ship.delegate respondsToSelector:@selector(shipDidMoved:)])
        {
            [ship.delegate shipDidMoved:ship];
        }
    }
}

- (BOOL)canMoveShip:(SBShipElement *)ship toPosition:(SBCellCoordinate)position
{
    SBCellCoordinate coordinate = position;
    BOOL result = YES;
    if (SBCellCoordinateIsValid(position))
    {
        if (ship.orientation == SBShipOrientationHorizontal)
        {
            result = coordinate.x <= 10 - ship.length && coordinate.y < 10;
        }
        else
        {
            result = coordinate.y <= 10 - ship.length && coordinate.x < 10;
        }
        
        if (result)
        {
            SBCellCoordinate lastAvailablePosition = ship.topLeftPosition;
            ship.topLeftPosition = coordinate;
            result = [self hasConflictWithOtherShipsShip:ship];
            if (!result)
            {
                ship.topLeftPosition = lastAvailablePosition;
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
