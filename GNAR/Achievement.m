//
//  Achievement.m
//  GNAR
//
//  Created by Chris Giersch on 2/10/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import "Achievement.h"

@implementation Achievement

@dynamic name;
@dynamic abbreviation;
@dynamic pointValues;
//@dynamic location;
@dynamic isAvailable;
@dynamic isCustom;
@dynamic type;
//@dynamic timeLimiter;
@dynamic description;
@dynamic area;
@dynamic difficulty;
@dynamic heroFactor;
@dynamic funFactor;




+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Achievement";
}

@end
