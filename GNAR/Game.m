//
//  Game.m
//  GNAR
//
//  Created by Chris Giersch on 2/10/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import "Game.h"
#import "User.h"

@implementation Game

@dynamic name;
@dynamic mountain;
@dynamic startAt;
@dynamic endAt;
@synthesize players;


- (instancetype)initWithName:(NSString *)name mountain:(NSString *)mountain
{
    self = [super init];
    if (self)
    {
        self.name = name;
        self.mountain = mountain;
    }
    return self;
}

//--------------------------------------    Get Games    ---------------------------------------------
#pragma mark - Get Games
+ (void)getCurrentGameWithCompletion:(void(^)(Game *currentGame))complete
{
    PFQuery *query = [PFQuery queryWithClassName:@"Game"];
    [query whereKey:@"players" equalTo:[User currentUser]];
    [query setCachePolicy:kPFCachePolicyCacheThenNetwork];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error)
        {
            NSLog(@"Fetched with error: %@", error);
        }
        else
        {
            NSLog(@"Fetched %lu games.", (unsigned long)objects.count);
        }
        complete(objects.firstObject);
    }];
}

- (void)getGameWithCompletion:(void(^)(Game *game))complete
{
    PFQuery *query = [PFQuery queryWithClassName:@"Game"];
    [query whereKey:@"objectId" equalTo:self.objectId];

    [query setCachePolicy:kPFCachePolicyCacheThenNetwork];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        complete(objects.firstObject);
    }];
}

+ (void)getAllGames:(void(^)(NSArray *allGames))complete
{
    PFQuery *query = [PFQuery queryWithClassName:@"Game"];
    [query addAscendingOrder:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        complete(objects);
    }];
}

- (void)getPlayersOfGameWithCompletion:(void(^)(NSArray *players))complete
{
//    PFQuery *query = [PFQuery queryWithClassName:@"Comment"];
//    [query whereKey:@"post" equalTo:myPost];
//
//    [query findObjectsInBackgroundWithBlock:^(NSArray *comments, NSError *error) {
//        // comments now contains the comments for myPost
//    }];


    PFRelation *relation = [self relationForKey:@"players"];
    [relation.query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error)
        {
            NSLog(@"%@", error);
        }
        else
        {
            NSLog(@"Fetched %lu players from game.", (unsigned long)objects.count);
        }
        complete(objects);
    }];
}







+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Game";
}

@end
