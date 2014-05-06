//
//  SBAIPlayer.h
//  Sea Battle
//
//  Created by Aleksey Bodnya on 5/6/14.
//  Copyright (c) 2014 Alexey Bodnya. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SBPlayer.h"

@interface SBAIPlayer : NSObject <SBPlayer>

@property (nonatomic, weak) id<SBPlayerDelegate> delegate;

@end
