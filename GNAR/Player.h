//
//  Player.h
//  GNAR
//
//  Created by Yi-Chin Sun on 2/25/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import <Parse/Parse.h>
@class User;
@class Game;

@interface Player : PFObject

@property (retain) NSNumber *totalScore;
@property (retain) NSNumber *rank;

@property User *user;
@property Game *game;

+ (NSString *)parseClassName;

@end
