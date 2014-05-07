//
//  SBAIAutomaticShipLayouter.h
//  Sea Battle
//
//  Created by Aleksey Bodnya on 5/6/14.
//  Copyright (c) 2014 Alexey Bodnya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SBAIAutomaticShipLayouter : NSObject

@property (nonatomic, strong) NSArray *cells;

- (void)startSetup;
#warning TODO: remove printShips
- (void)printShips;

@end
