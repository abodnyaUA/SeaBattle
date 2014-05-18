//
//  NSKeyedUnarchiver+Safe.m
//  Sea Battle
//
//  Created by Aleksey Bodnya on 5/18/14.
//  Copyright (c) 2014 Alexey Bodnya. All rights reserved.
//

#import "NSKeyedUnarchiverExtensions.h"

@implementation NSKeyedUnarchiver (Safe)

+ (id)safeUnarchived:(NSData *)data
{
    NSObject *unarchived = nil;
    if (nil != data)
    {
        unarchived = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    return unarchived;
}

@end
