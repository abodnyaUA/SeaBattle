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
    
    SBGameFieldCell *cell = nil;
    SBCellCoordinate coordinate;
    
    cell = nil;
    coordinate = SBCellCoordinateMake(position.x - 1, position.y);
    while (SBCellCoordinateIsValid(coordinate) && ![self isFreeCell:(cell = [self cellWithPosition:coordinate]) includedStates:mask])
    {
        coordinate = SBCellCoordinateMake(coordinate.x - 1, coordinate.y);
        [cells addObject:cell];
    };
    
    cell = nil;
    coordinate = SBCellCoordinateMake(position.x + 1, position.y);
    while (SBCellCoordinateIsValid(coordinate) && ![self isFreeCell:(cell = [self cellWithPosition:coordinate]) includedStates:mask])
    {
        coordinate = SBCellCoordinateMake(coordinate.x + 1, coordinate.y);
        [cells addObject:cell];
    };
    
    cell = nil;
    coordinate = SBCellCoordinateMake(position.x, position.y - 1);
    while (SBCellCoordinateIsValid(coordinate) && ![self isFreeCell:(cell = [self cellWithPosition:coordinate]) includedStates:mask])
    {
        coordinate = SBCellCoordinateMake(coordinate.x, coordinate.y - 1);
        [cells addObject:cell];
    };
    
    cell = nil;
    coordinate = SBCellCoordinateMake(position.x, position.y + 1);
    while (SBCellCoordinateIsValid(coordinate) && ![self isFreeCell:(cell = [self cellWithPosition:coordinate]) includedStates:mask])
    {
        coordinate = SBCellCoordinateMake(coordinate.x, coordinate.y + 1);
        [cells addObject:cell];
    };
    
    return [cells copy];
}

- (BOOL)isFreeCell:(SBGameFieldCell *)cell includedStates:(NSUInteger)mask
{
    return cell.state & mask;
}

- (NSArray *)unactiveFieldsAboveDefendedShipWithPosition:(SBCellCoordinate)position
{
    NSMutableArray *cells = [NSMutableArray array];
    
    NSArray *shipCells = [self shipCellsAboveCellWithPosition:position includedStates:SBGameFieldCellStateDefended];
    
    return cells;
}

+ (NSArray *)emptyCells
{
    NSMutableArray *cells = [NSMutableArray array];
    for (int i = 0; i < 10; i++)
    {
        NSMutableArray *cellsInRow = [NSMutableArray array];
        for (int j = 0; j < 10; j++)
        {
            SBGameFieldCell *cell = [SBGameFieldCell cellWithState:SBGameFieldCellStateFree];
            cell.coordinate = SBCellCoordinateMake(j, i);
            [cellsInRow addObject:cell];
        }
        [cells addObject:[cellsInRow copy]];
    }
    return [cells copy];
}

@end
