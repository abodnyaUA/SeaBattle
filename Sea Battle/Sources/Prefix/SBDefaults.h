//
//  SBDefaults.h
//  Sea Battle
//
//  Created by Aleksey Bodnya on 5/18/14.
//  Copyright (c) 2014 Alexey Bodnya. All rights reserved.
//

#ifndef Sea_Battle_SBDefaults_h
#define Sea_Battle_SBDefaults_h

#if TARGET_OS_IPHONE
    #define SBImage UIImage
    #define SBColor UIColor
#elif TARGET_OS_MAC
    #define SBImage NSImage
    #define SBColor NSColor
#endif

#endif
