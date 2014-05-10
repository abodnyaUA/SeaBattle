//
//  UIColor+SBGameFieldCell.h
//  Sea Battle
//
//  Created by Aleksey Bodnya on 5/10/14.
//  Copyright (c) 2014 Alexey Bodnya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBGameFieldCell.h"


@interface UIColor (SBGameFieldCell)

+ (UIColor *)colorForCellState:(SBGameFieldCellState)state;

@end
