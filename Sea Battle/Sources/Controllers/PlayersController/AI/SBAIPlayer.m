//
//  SBAIPlayer.m
//  Sea Battle
//
//  Created by Aleksey Bodnya on 5/6/14.
//  Copyright (c) 2014 Alexey Bodnya. All rights reserved.
//

#import "SBAIPlayer.h"

#import "SBAIAutomaticShipLayouter.h"
#import "NSArray+SBGameFieldCell.h"
#import "SBGameFieldCell.h"

@interface SBAIPlayer ()

@property (nonatomic, strong) SBAIAutomaticShipLayouter *shipLayouter;

@end

@implementation SBAIPlayer

- (instancetype)init
{
    self = [super init];
    if (nil != self)
    {
        self.shipLayouter = [SBAIAutomaticShipLayouter new];
        [self startSetup];
    }
    return self;
}

- (void)startSetup
{
    NSOperationQueue *queue = [NSOperationQueue new];
    [queue addOperationWithBlock:^{
        [self.shipLayouter startSetup];
        if ([self.delegate respondsToSelector:@selector(playerDidSetupShips:)])
        {
            [NSOperationQueue.mainQueue addOperationWithBlock:^{
                [self.delegate playerDidSetupShips:self];
            }];
        }
    }];
}

- (void)shotToCellAtPosition:(SBCellCoordinate)position withResultBlock:(void (^)(SBGameFieldCellState))block
{
    SBGameFieldCell *cell = [self.shipLayouter.cells cellWithPosition:position];
    if (cell.state == SBGameFieldCellStateWithShip)
    {
        NSArray *otherShipCells = [self.shipLayouter.cells shipCellsAboveCellWithPosition:position includedStates:SBGameFieldCellStateWithShip | SBGameFieldCellStateUnderAtack];
        otherShipCells = [otherShipCells filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"state == %d",SBGameFieldCellStateWithShip]];
        if (otherShipCells.count > 0)
        {
            cell.state = SBGameFieldCellStateUnderAtack;
        }
        else
        {
            cell.state = SBGameFieldCellStateDefended;
            [self.shipLayouter.cells defendShipWithCoordinate:position];
        }
    }
    else
    {
        cell.state = SBGameFieldCellStateUnavailable;
    }
    block(cell.state);
    [self.shipLayouter printShips];
}

@end
