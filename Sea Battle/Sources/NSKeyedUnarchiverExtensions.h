//
//  NSKeyedUnarchiver+Safe.h
//  Sea Battle
//
//  Created by Aleksey Bodnya on 5/18/14.
//  Copyright (c) 2014 Alexey Bodnya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSKeyedUnarchiver (Safe)

+ (id)safeUnarchived:(NSData *)data;

@end

