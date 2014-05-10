//
//  SBGameFieldCell.m
//  Sea Battle
//
//  Created by Aleksey Bodnya on 24.04.14.
//  Copyright (c) 2014 Alexey Bodnya. All rights reserved.
//

#import "SBGameFieldCell.h"

@implementation SBGameFieldCell

+ (instancetype)cellWithState:(SBGameFieldCellState)state
{
    SBGameFieldCell *cell = [SBGameFieldCell new];
    cell.state = state;
    return cell;
}

@end
