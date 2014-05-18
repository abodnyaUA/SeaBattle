//
//  UIImageExtensions.h
//  Sea Battle
//
//  Created by Aleksey Bodnya on 5/18/14.
//  Copyright (c) 2014 Alexey Bodnya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBGameFieldCell.h"
#import "SBDefaults.h"

@interface SBImage (SBGameFieldCell)

+ (SBImage *)iconForCellState:(SBGameFieldCellState)state;

@end
