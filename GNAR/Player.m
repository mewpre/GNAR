//
//  Player.m
//  GNAR
//
//  Created by Chris Giersch on 2/20/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import "Player.h"

@implementation Player

@synthesize scores, totalScore, rank;
@synthesize user = _user;

- (instancetype)initWithUser:(User *)user
{
    self = [super init];
    if (self)
    {
        self.scores = [NSArray new];
        self.totalScore = 0;
        self.rank = 0;

        self.user = user;
    }
    return self;
}

//- (void)updateScore:(NSArray *)scores
//{
//    for () {
//
//    }
//}

- (void)setUser:(User *)user
{
    _user = user;
}

- (User *)user
{
    if(_user == nil)
    {
        _user = [self user];        // *** is this supposed to be [User new] or [self user]???
    }
    return _user;
}


@end
