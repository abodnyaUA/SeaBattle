//
//  NSArray+SBGameFieldCell.m
//  Sea Battle
//
//  Created by Aleksey Bodnya on 5/2/14.
//  Copyright (c) 2014 Alexey Bodnya. All rights reserved.
//

#import "NSArray+SBGameFieldCell.h"

@implementation NSArray (SBGameFieldCell)

- (SBGameFieldCell *)cellWithPosition:(SBCellCoordinate)position
{
    return [[self objectAtIndex:position.y] objectAtIndex:position.x];
}

- (NSArray *)shipCellsAboveCellWithPosition:(SBCellCoordinate)position includedStates:(NSUInteger)mask
{
    NSMutableArray *cells = [NSMutableArray array];
    
    SBCellCoordinate offset[4] =
    {
        SBCellCoordinateMake(- 1, 0),
        SBCellCoordinateMake(+ 1, 0),
        SBCellCoordinateMake(0, - 1),
        SBCellCoordinateMake(0, + 1)
    };
    
    for (NSUInteger index = 0; index < 4; index++)
    {
        SBGameFieldCell *cell = nil;
        SBCellCoordinate coordinate = SBCellCoordinateMake(position.x + offset[index].x, position.y + offset[index].y);
        while (SBCellCoordinateIsValid(coordinate) && [self isCell:(cell = [self cellWithPosition:coordinate]) hasState:mask])
        {
            coordinate = SBCellCoordinateMake(coordinate.x + offset[index].x, coordinate.y + offset[index].y);
            [cells addObject:cell];
        };
    }
    
    return [cells copy];
}

- (BOOL)isCell:(SBGameFieldCell *)cell hasState:(NSUInteger)mask
{
    return cell.state & mask;
}

- (void)unactivatedFieldsAboveDefendedShipWithPosition:(SBCellCoordinate)position
{
    NSMutableArray *shipCells = [[self shipCellsAboveCellWithPosition:position includedStates:SBGameFieldCellStateDefended] mutableCopy];
    [shipCells addObject:[self cellWithPosition:position]];
    
    SBCellCoordinate offset[9] =
    {
        SBCellCoordinateMake(- 1, -1),
        SBCellCoordinateMake(- 1, 0),
        SBCellCoordinateMake(- 1, 1),
        
        SBCellCoordinateMake(0, -1),
        SBCellCoordinateMake(0, 0),
        SBCellCoordinateMake(0, 1),
        
        SBCellCoordinateMake(1, -1),
        SBCellCoordinateMake(1, 0),
        SBCellCoordinateMake(1, 1)
    };
    
    for (SBGameFieldCell *cell in shipCells)
    {
        for (NSUInteger index = 0; index < 9; index++)
        {
            SBGameFieldCell *newCell = nil;
            SBCellCoordinate coordinate = SBCellCoordinateMake(cell.coordinate.x + offset[index].x, cell.coordinate.y + offset[index].y);
            if (SBCellCoordinateIsValid(coordinate) && (newCell = [self cellWithPosition:coordinate]).state == SBGameFieldCellStateFree)
            {
                newCell.state = SBGameFieldCellStateUnavailable;
            }
        }
    }
}

- (void)defendShipWithCoordinate:(SBCellCoordinate)coordinate
{
    NSArray *otherShipCells = [self shipCellsAboveCellWithPosition:coordinate includedStates:SBGameFieldCellStateUnderAtack];
    for (SBGameFieldCell *cell in otherShipCells)
    {
        cell.state = SBGameFieldCellStateDefended;
    }
    [self unactivatedFieldsAboveDefendedShipWithPosition:coordinate];
}

+ (NSArray *)emptyCells
{
    NSMutableArray *cells = [NSMutableArray array];
    for (int y = 0; y < 10; y++)
    {
        NSMutableArray *cellsInRow = [NSMutableArray array];
        for (int x = 0; x < 10; x++)
        {
            SBGameFieldCell *cell = [SBGameFieldCell cellWithState:SBGameFieldCellStateFree];
            cell.coordinate = SBCellCoordinateMake(x, y);
            [cellsInRow addObject:cell];
        }
        [cells addObject:[cellsInRow copy]];
    }
    return [cells copy];
}

@end
