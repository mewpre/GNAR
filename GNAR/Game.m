//
//  Game.m
//  GNAR
//
//  Created by Chris Giersch on 2/10/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import "Game.h"

@implementation Game

@dynamic name;
@dynamic mountain;
@dynamic startAt;
@dynamic endAt;


+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Game";
}

@end
