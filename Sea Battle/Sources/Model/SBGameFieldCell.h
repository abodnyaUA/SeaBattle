//
//  SBGameFieldCell.h
//  Sea Battle
//
//  Created by Aleksey Bodnya on 24.04.14.
//  Copyright (c) 2014 Alexey Bodnya. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SGGameFieldCellState)
{
    SGGameFieldCellStateFree = 0,
    SGGameFieldCellStateUnavailable,
    SGGameFieldCellStateUnderAtack,
    SGGameFieldCellStateDefended,
    SGGameFieldCellStateWithShip
};

@interface SBGameFieldCell : NSObject

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) SGGameFieldCellState state;

+ (instancetype)cellForRowWithIndexPath:(NSIndexPath *)indexPath;
- (UIColor *)color;

@end
