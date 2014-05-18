//
//  SBGameEnviroment.m
//  Sea Battle
//
//  Created by Aleksey Bodnya on 5/10/14.
//  Copyright (c) 2014 Alexey Bodnya. All rights reserved.
//

#import "SBGameEnviroment.h"
#import "SBColorExtensions.h"
#import "NSKeyedUnarchiverExtensions.h"

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
        
        [self.playerInfo addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
        [self.playerInfo addObserver:self forKeyPath:@"color" options:NSKeyValueObservingOptionNew context:nil];
        [self.playerInfo addObserver:self forKeyPath:@"avatar" options:NSKeyValueObservingOptionNew context:nil];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        self.playerInfo.name = [NSKeyedUnarchiver safeUnarchived:[defaults objectForKey:@"SBUserPlayer_name"]] ?: @"Al11eksey Bodnya";
        self.playerInfo.avatar = [NSKeyedUnarchiver safeUnarchived:[defaults objectForKey:@"SBUserPlayer_avatar"]] ?: [SBImage imageNamed:@"DefaultUser.png"];
        self.playerInfo.color = [NSKeyedUnarchiver safeUnarchived:[defaults objectForKey:@"SBUserPlayer_color"]] ?: [SBColor niceBlue];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(NSObject *)object change:(NSDictionary *)change context:(void *)context
{
    if ([object isEqual:self.playerInfo])
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSObject *property = [object valueForKeyPath:keyPath];
        NSData *encoded = [NSKeyedArchiver archivedDataWithRootObject:property];

        [defaults setObject:encoded forKey:[@"SBUserPlayer_" stringByAppendingString:keyPath]];
        [defaults synchronize];
    }
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
