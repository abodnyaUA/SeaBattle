//
//  SBPlayerInfo.h
//  Sea Battle
//
//  Created by Aleksey Bodnya on 5/10/14.
//  Copyright (c) 2014 Alexey Bodnya. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SBDefaults.h"

@interface SBPlayerInfo : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) SBImage *avatar;
@property (nonatomic, strong) SBColor *color;
@end
