//
//  SBGameEnviroment.h
//  Sea Battle
//
//  Created by Aleksey Bodnya on 5/10/14.
//  Copyright (c) 2014 Alexey Bodnya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBPlayerInfo.h"
#import "SBDefaults.h"

@interface SBGameEnviroment : NSObject

@property (nonatomic, strong, readonly) SBPlayerInfo *playerInfo;

+ (instancetype)sharedEnviroment;

- (NSUInteger)maxCells;
- (NSUInteger)gameFieldSize;

@end
