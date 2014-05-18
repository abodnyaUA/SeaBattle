//
//  UIColorExtensions.h
//  Sea Battle
//
//  Created by Aleksey Bodnya on 5/10/14.
//  Copyright (c) 2014 Alexey Bodnya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBGameFieldCell.h"
#import "SBDefaults.h"


@interface SBColor (SBGameFieldCell)

+ (SBColor *)colorForCellState:(SBGameFieldCellState)state;

@end

@interface SBColor (SBNiceColors)

+ (SBColor *)niceBlue;
+ (SBColor *)niceRed;
+ (SBColor *)niceGreen;

@end
