//
//  NSArrayExtensions.h
//  Sea Battle
//
//  Created by Aleksey Bodnya on 5/2/14.
//  Copyright (c) 2014 Alexey Bodnya. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SBGameFieldCell.h"
#import "SBCellCoordinate.h"

@interface NSArray (SBGameFieldCell)

+ (NSArray *)emptyCells;
- (SBGameFieldCell *)cellWithPosition:(SBCellCoordinate)position;
- (NSArray *)shipCellsAboveCellWithPosition:(SBCellCoordinate)position includedStates:(NSUInteger)mask;
- (void)defendShipWithCoordinate:(SBCellCoordinate)coordinate;
- (void)shotToCellWithPosition:(SBCellCoordinate)position;
- (NSArray *)allCellsWithMask:(NSUInteger)mask;

- (void)printShips;

@end
