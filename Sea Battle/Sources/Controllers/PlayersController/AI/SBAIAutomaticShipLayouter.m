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


@interface SBAIAutomaticShipLayouter ()

@property (nonatomic, strong) NSArray *ships;

@end

@implementation SBAIAutomaticShipLayouter

- (instancetype)init
{
    self = [super init];
    if (nil != self)
    {
        [self loadCells];
        [self loadShips];
        [self layoutShips];
        [self printShips];
    }
    return self;
}

- (void)loadCells
{
    NSMutableArray *cells = [NSMutableArray array];
    for (int i=0; i<10; i++)
    {
        NSMutableArray *cellsInRow = [NSMutableArray array];
        for (int j=0;j<10;j++)
        {
            SBGameFieldCell *cell = [SBGameFieldCell cellWithState:SBGameFieldCellStateFree];
            [cellsInRow addObject:cell];
        }
        [cells addObject:[cellsInRow copy]];
    }
    self.cells = [cells copy];
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
    ///......////
    
    [SBShipLayouter layoutShips:self.ships onCells:self.cells];
}

- (void)printShips
{
    NSString *description = @"\n";
    for (int i=0; i<10; i++)
    {
        for (int j=0;j<10;j++)
        {
            SBGameFieldCell *cell = [self.cells cellWithPosition:SBCellCoordinateMake(j, i)];
            description = [description stringByAppendingString:[NSString stringWithFormat:@"%ld ",(long)cell.state]];
        }
        description = [description stringByAppendingString:@"\n"];
    }
    NSLog(@"%@",description);

}

@end
