//
//  SBAINormalPlayer.m
//  Sea Battle
//
//  Created by Aleksey Bodnya on 5/10/14.
//  Copyright (c) 2014 Alexey Bodnya. All rights reserved.
//

#import "SBAINormalPlayer.h"
#import "NSArrayExtensions.h"

@implementation SBAINormalPlayer

- (instancetype)init
{
    self = [super init];
    if (nil != self)
    {
        self.info.name = @"Normal AI";
    }
    return self;
}

- (SBCellCoordinate)coordinateForFreeCell
{
    NSArray *avaiableCells = [self.userCells allCellsWithMask:SBGameFieldCellStateFree];
    SBGameFieldCell *randomCell = [avaiableCells objectAtIndex:arc4random() % avaiableCells.count];
    return randomCell.coordinate;
}

- (SBCellCoordinate)coordinateForShotWithAttackedCells:(NSArray *)underAtack
{
    SBCellCoordinate resultCoordinate = SBCellCoordinateZero;
    // 1 cell
    if (underAtack.count == 1)
    {
        SBCellCoordinate offset[4] =
        {
            SBCellCoordinateMake(- 1, 0),
            SBCellCoordinateMake(+ 1, 0),
            SBCellCoordinateMake(0, - 1),
            SBCellCoordinateMake(0, + 1)
        };
        SBGameFieldCell *underAttackCell = [underAtack objectAtIndex:0];
        do
        {
            NSUInteger index = arc4random() % 4;
            resultCoordinate = SBCellCoordinateMake(underAttackCell.coordinate.x + offset[index].x, underAttackCell.coordinate.y + offset[index].y);
            if (SBCellCoordinateIsValid(resultCoordinate) && [self.userCells cellWithPosition:resultCoordinate].state != SBGameFieldCellStateFree)
            {
                resultCoordinate = SBCellCoordinateZero;
            }
        }
        while (!SBCellCoordinateIsValid(resultCoordinate));
    }
    // 2, 3 cells
    else
    {
        BOOL horizontal = [[underAtack objectAtIndex:0] coordinate].y == [[underAtack objectAtIndex:1] coordinate].y;
        if (horizontal)
        {
            underAtack = [underAtack sortedArrayUsingComparator:^NSComparisonResult(SBGameFieldCell *obj1, SBGameFieldCell *obj2)
                          {
                              return obj1.coordinate.x - obj2.coordinate.x;
                          }];
            
            // Try left coordinate
            SBGameFieldCell *underAttackCell = [underAtack objectAtIndex:0];
            resultCoordinate = SBCellCoordinateMake(underAttackCell.coordinate.x - 1, underAttackCell.coordinate.y);
            if (!SBCellCoordinateIsValid(resultCoordinate) || [self.userCells cellWithPosition:resultCoordinate].state != SBGameFieldCellStateFree)
            {
                // Try right coordinate
                SBGameFieldCell *underAttackCell = [underAtack objectAtIndex:(underAtack.count - 1)];
                resultCoordinate = SBCellCoordinateMake(underAttackCell.coordinate.x + 1, underAttackCell.coordinate.y);
            }
        }
        else
        {
            underAtack = [underAtack sortedArrayUsingComparator:^NSComparisonResult(SBGameFieldCell *obj1, SBGameFieldCell *obj2)
                          {
                              return obj1.coordinate.y - obj2.coordinate.y;
                          }];
            
            // Try top coordinate
            SBGameFieldCell *underAttackCell = [underAtack objectAtIndex:0];
            resultCoordinate = SBCellCoordinateMake(underAttackCell.coordinate.x, underAttackCell.coordinate.y - 1);
            if (!SBCellCoordinateIsValid(resultCoordinate) || [self.userCells cellWithPosition:resultCoordinate].state != SBGameFieldCellStateFree)
            {
                // Try bootom coordinate
                SBGameFieldCell *underAttackCell = [underAtack objectAtIndex:(underAtack.count - 1)];
                resultCoordinate = SBCellCoordinateMake(underAttackCell.coordinate.x, underAttackCell.coordinate.y + 1);
            }
        }
    }
    return resultCoordinate;
}

@end
