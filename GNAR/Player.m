//
//  Player.m
//  GNAR
//
//  Created by Yi-Chin Sun on 2/25/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import "Player.h"

@implementation Player

@dynamic totalScore, rank;
@dynamic user, game;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Player";
}

@end
