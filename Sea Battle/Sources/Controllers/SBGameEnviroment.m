//
//  SBGameEnviroment.m
//  Sea Battle
//
//  Created by Aleksey Bodnya on 5/10/14.
//  Copyright (c) 2014 Alexey Bodnya. All rights reserved.
//

#import "SBGameEnviroment.h"

static SBGameEnviroment *_sharedInstance = nil;

@interface SBGameEnviroment ()

@property (nonatomic, strong) SBPlayerInfo *playerInfo;

@end

@implementation SBGameEnviroment

+ (instancetype)sharedEnviroment
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [SBGameEnviroment new];
    });
    return _sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (nil != self)
    {
        self.playerInfo = [SBPlayerInfo new];
        // TODO: Use real data!
        self.playerInfo.name = @"Aleksey Bodnya";
        self.playerInfo.avatar = [UIImage imageNamed:@"DefaultUser.png"];
    }
    return self;
}

- (NSUInteger)maxCells
{
    return 4 * 1 + 3 * 2 + 2 * 3 + 1 * 4;
}

- (NSUInteger)gameFieldSize
{
    return 10;
}

@end
