//
//  SBGameFieldCellView.h
//  Sea Battle
//
//  Created by Aleksey Bodnya on 25.04.14.
//  Copyright (c) 2014 Alexey Bodnya. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SBGameFieldCell.h"
#import "SBCellCoordinate.h"

@interface SBGameFieldCellView : UIControl

@property (nonatomic, strong) SBGameFieldCell *cell;
@property (nonatomic, assign) SBCellCoordinate position;

+ (instancetype)cellViewWithCell:(SBGameFieldCell *)cell andPosition:(SBCellCoordinate)position;

@end
