//
//  SBGameFieldCell.h
//  Sea Battle
//
//  Created by Aleksey Bodnya on 24.04.14.
//  Copyright (c) 2014 Alexey Bodnya. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SBGameFieldCellState)
{
    SBGameFieldCellStateFree = 0,
    SBGameFieldCellStateUnavailable,
    SBGameFieldCellStateUnderAtack,
    SBGameFieldCellStateDefended,
    SBGameFieldCellStateWithShip
};

@interface SBGameFieldCell : NSObject

@property (nonatomic, assign) SBGameFieldCellState state;

+ (instancetype)cellWithState:(SBGameFieldCellState)state;
- (UIColor *)color;

@end
