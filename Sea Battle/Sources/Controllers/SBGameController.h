//
//  SBEnviroment.h
//  Sea Battle
//
//  Created by Aleksey Bodnya on 4/29/14.
//  Copyright (c) 2014 Alexey Bodnya. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SBGameFieldView.h"
#import "SBShipPositionController.h"

@interface SBGameController : NSObject

@property (nonatomic, assign) CGFloat cellSize;
@property (nonatomic, weak  ) SBGameFieldView *gameFieldView;
@property (nonatomic, strong) SBShipPositionController *positionController;
@property (nonatomic, strong) NSArray *userCells;
@property (nonatomic, strong) NSArray *enemyCells;

+ (instancetype)sharedController;

- (void)initializeGame;

@end
