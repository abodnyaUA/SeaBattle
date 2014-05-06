//
//  SBShipLayouter.h
//  Sea Battle
//
//  Created by Aleksey Bodnya on 5/6/14.
//  Copyright (c) 2014 Alexey Bodnya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SBShipLayouter : NSObject

+ (void)layoutShips:(NSArray *)ships onCells:(NSArray *)cells;

@end
