//
//  SBGameFieldCell.h
//  Sea Battle
//
//  Created by Aleksey Bodnya on 24.04.14.
//  Copyright (c) 2014 Alexey Bodnya. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SBCellCoordinate.h"

typedef NS_ENUM(NSUInteger, SBGameFieldCellState)
{
    SBGameFieldCellStateFree =          1 << 0,
    SBGameFieldCellStateUnavailable =   1 << 1,
    SBGameFieldCellStateUnderAtack =    1 << 2,
    SBGameFieldCellStateDefended =      1 << 3,
    SBGameFieldCellStateWithShip =      1 << 4
};

@interface SBGameFieldCell : NSObject

@property (nonatomic, assign) SBGameFieldCellState state;
@property (nonatomic, assign) SBCellCoordinate coordinate;

+ (instancetype)cellWithState:(SBGameFieldCellState)state;

@end
