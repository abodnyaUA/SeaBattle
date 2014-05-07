//
//  SBAIAutomaticShipLayouter.m
//  Sea Battle
//
//  Created by Aleksey Bodnya on 5/6/14.
//  Copyright (c) 2014 Alexey Bodnya. All rights reserved.
//

#import "SBAIAutomaticShipLayouter.h"
#import "SBGameFieldCell.h"
#import "NSArray+SBGameFieldCell.h"
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
    [self printShips];
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

- (NSUInteger)powOfState:(SBGameFieldCellState)state
{
    NSUInteger pow = 0;
    do
    {
        pow++;
        state = sqrt(state);
    }
    while (state > 1);
    return pow;
}

- (void)printShips
{
    NSString *description = @"\n";
    for (int i=0; i<10; i++)
    {
        for (int j=0;j<10;j++)
        {
            SBGameFieldCell *cell = [self.cells cellWithPosition:SBCellCoordinateMake(j, i)];
            description = [description stringByAppendingString:[NSString stringWithFormat:@"%ld ",(long)[self powOfState:cell.state]]];
        }
        description = [description stringByAppendingString:@"\n"];
    }
    NSLog(@"%@",description);

}

@end
