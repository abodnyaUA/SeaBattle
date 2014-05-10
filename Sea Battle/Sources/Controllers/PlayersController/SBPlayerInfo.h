//
//  SBPlayerInfo.h
//  Sea Battle
//
//  Created by Aleksey Bodnya on 5/10/14.
//  Copyright (c) 2014 Alexey Bodnya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SBPlayerInfo : NSObject

@property (nonatomic, strong) NSString *name;

#if TARGET_OS_IPHONE
@property (nonatomic, strong) UIImage *avatar;
#elif TARGET_IPHONE_SIMULATOR
@property (nonatomic, strong) UIImage *avatar;
#elif TARGET_OS_MAC
@property (nonatomic, strong) NSImage *avatar;
#endif

@end
