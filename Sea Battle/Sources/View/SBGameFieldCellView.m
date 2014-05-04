//
//  SBGameFieldCellView.m
//  Sea Battle
//
//  Created by Aleksey Bodnya on 25.04.14.
//  Copyright (c) 2014 Alexey Bodnya. All rights reserved.
//

#import "SBGameFieldCellView.h"

@implementation SBGameFieldCellView

+ (instancetype)cellViewWithCell:(SBGameFieldCell *)cell andPosition:(SBCellCoordinate)position
{
    SBGameFieldCellView *cellView = [SBGameFieldCellView new];
    cellView.cell = cell;
    cellView.position = position;
    cellView.backgroundColor = cell.color;
    [cell addObserver:cellView forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
    return cellView;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"state"] && [object isKindOfClass:SBGameFieldCell.class])
    {
        if ((SBGameFieldCell *)object == self.cell)
        {
            self.backgroundColor = self.cell.color;
        }
    }
}

- (void)dealloc
{
    [self.cell removeObserver:self forKeyPath:@"state"];
}

@end
