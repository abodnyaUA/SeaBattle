//
//  SBAIEasyPlayer.h
//  Sea Battle
//
//  Created by Aleksey Bodnya on 5/11/14.
//  Copyright (c) 2014 Alexey Bodnya. All rights reserved.
//

#import "SBAIPlayer.h"

@interface SBAIPlayerShotCellProviderEasy : NSObject <SBAIPlayerShotCellProvider>

@property (nonatomic, weak) SBAIPlayer *player;

@end
