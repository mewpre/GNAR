//
//  Player.h
//  GNAR
//
//  Created by Chris Giersch on 2/20/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import "User.h"

@interface Player : User

@property NSArray *scores;
@property int totalScore;
@property int rank;

@property (nonatomic) User *user;

@end
