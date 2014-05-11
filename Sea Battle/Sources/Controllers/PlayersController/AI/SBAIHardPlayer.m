//
//  SBAIHardPlayer.m
//  Sea Battle
//
//  Created by Aleksey Bodnya on 5/11/14.
//  Copyright (c) 2014 Alexey Bodnya. All rights reserved.
//

#import "SBAIHardPlayer.h"
#import "NSArrayExtensions.h"

@implementation SBAIHardPlayer

- (SBCellCoordinate)coordinateForFreeCell
{
    NSArray *avaiableCells = [self.userCells allCellsWithMask:SBGameFieldCellStateFree];
    
    NSUInteger ship2cellDeadCount = 0;
    NSUInteger ship3cellDeadCount = 0;
    BOOL ship4cellIsDead = NO;
    
    NSArray *defendedCells = [self.userCells allCellsWithMask:SBGameFieldCellStateDefended];
    for (SBGameFieldCell *cell in defendedCells)
    {
        NSArray *shipCells = [self.userCells shipCellsAboveCellWithPosition:cell.coordinate includedStates:SBGameFieldCellStateDefended];
        switch (shipCells.count + 1)
        {
            case 2: ship2cellDeadCount++; break;
            case 3: ship3cellDeadCount++; break;
            case 4: ship4cellIsDead = YES; break;
            default: break;
        }
    }
    
    ship2cellDeadCount /= 2;
    ship3cellDeadCount /= 3;
    
    if (!ship4cellIsDead || ship3cellDeadCount < 2 || ship2cellDeadCount < 3)
    {
        NSArray *optimalCells = !ship4cellIsDead ? [self coordinatsForFinding4CellShip] : ship3cellDeadCount < 2 ? [self coordinatsForFinding3CellShip] : [self coordinatsForFinding2CellShip];
        avaiableCells = [avaiableCells filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(SBGameFieldCell *cell, NSDictionary *bindings)
        {
            BOOL passed = NO;
            for (NSValue *encoded in optimalCells)
            {
                SBCellCoordinate decoded = SBCellCoordinateDecoded(encoded);
                passed = SBCellCoordinateEquals(cell.coordinate, decoded);
                if (passed)
                {
                    break;
                }
            }
            return passed;
        }]];
    }
    
    return [[avaiableCells objectAtIndex:arc4random() % avaiableCells.count] coordinate];
}

- (NSArray *)coordinatsForFinding4CellShip
{
    return
    @[
      SBCellCoordinateEncoded(SBCellCoordinateMake(3, 0)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(7, 0)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(2, 1)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(6, 1)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(1, 2)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(5, 2)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(9, 2)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(0, 3)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(4, 3)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(8, 3)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(3, 4)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(7, 4)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(2, 5)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(6, 5)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(1, 6)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(5, 6)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(9, 6)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(0, 7)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(4, 7)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(8, 7)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(3, 8)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(7, 8)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(2, 9)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(6, 9))
      ];
}

- (NSArray *)coordinatsForFinding3CellShip
{
    return
    @[
      SBCellCoordinateEncoded(SBCellCoordinateMake(0, 0)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(3, 0)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(6, 0)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(9, 0)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(1, 1)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(4, 1)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(7, 1)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(2, 2)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(5, 2)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(8, 2)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(0, 3)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(3, 3)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(6, 3)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(9, 3)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(1, 4)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(4, 4)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(7, 4)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(2, 5)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(5, 5)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(8, 5)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(0, 6)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(3, 6)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(6, 6)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(9, 6)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(1, 7)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(4, 7)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(7, 7)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(2, 8)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(5, 8)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(8, 8)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(0, 9)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(3, 9)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(6, 9)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(9, 9))
      ];
}

- (NSArray *)coordinatsForFinding2CellShip
{
    return
    @[
      SBCellCoordinateEncoded(SBCellCoordinateMake(1, 0)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(3, 0)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(5, 0)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(7, 0)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(9, 0)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(0, 1)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(2, 1)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(4, 1)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(6, 1)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(8, 1)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(1, 2)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(3, 2)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(5, 2)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(7, 2)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(9, 2)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(0, 3)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(2, 3)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(4, 3)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(6, 3)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(8, 3)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(1, 4)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(3, 4)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(5, 4)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(7, 4)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(9, 4)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(0, 5)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(2, 5)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(4, 5)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(6, 5)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(8, 5)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(1, 6)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(3, 6)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(5, 6)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(7, 6)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(9, 6)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(0, 7)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(2, 7)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(4, 7)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(6, 7)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(8, 7)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(1, 8)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(3, 8)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(5, 8)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(7, 8)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(9, 8)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(0, 9)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(2, 9)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(4, 9)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(6, 9)),
      SBCellCoordinateEncoded(SBCellCoordinateMake(8, 9))
      ];
}

@end
