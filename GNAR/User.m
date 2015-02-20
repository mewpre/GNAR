//
//  User.m
//  GNAR
//
//  Created by Chris Giersch on 2/10/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import "User.h"
#import "GameManager.h"

@implementation User

@dynamic firstName, lastName, type, gender, birthday, homeMountain, ability, parseClassName, profileImage;
@dynamic lastKnownLocation;

//@dynamic scores;

//@synthesize friends = _friends;
@synthesize games = _games;
@synthesize scores = _scores;
//@synthesize createdAchievements = _createdAchievements;
@synthesize createdGames = _createdGames;

- (void)setGames:(PFRelation *)games
{
    _games = games;
}
- (PFRelation *)games
{
    if(_games == nil)
    {
        _games = [self relationForKey:@"games"];
    }
    return _games;
}

- (void)setScores:(PFRelation *)scores
{
    _scores = scores;
}
- (PFRelation *)scores
{
    if(_scores == nil)
    {
        _scores = [self relationForKey:@"scores"];
    }
    return _scores;
}

- (void)setCreatedGames:(PFRelation *)createdGames
{
    _createdGames = createdGames;
}
- (PFRelation *)createdGames
{
    if(_createdGames == nil)
    {
        _createdGames = [self relationForKey:@"createdGames"];
    }
    return _createdGames;
}




//--------------------------------------    Get Scores    ---------------------------------------------
#pragma mark - Get Scores

+ (void)getCurrentUserScoresWithCompletion:(void(^)(NSArray *userScoresIncludingModifiers))complete
{
    
    PFRelation *relation = [[User currentUser] relationForKey:@"scores"];
    [relation.query includeKey:@"modifiers"];
    [relation.query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {

//        PFQuery *query = [PFQuery queryWithClassName:@"Score"];
//        [query whereKey:@"scorer" equalTo:[User currentUser]];
//        [query includeKey:@"modifiers"];
//        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {

        if (error)
        {
            NSLog(@"%@", error);
        }
        else
        {
            NSLog(@"Fetched %lu scores", (unsigned long)objects.count);
//            NSLog(@"...including %lu modifiers", (unsigned long)objects.count);
//            NSLog(@"...including %lu players", (unsigned long)objects.count);
        }
        complete(objects);
    }];
}


//--------------------------------------    Get Games    ---------------------------------------------
#pragma mark - Get Games
+ (void)getCurrentUserGamesWithCompletion:(void(^)(NSArray *currentUserGames))complete
{
    PFRelation *relation = [[User currentUser] relationForKey:@"games"];
//    [relation.query includeKey:@"players"];
    [relation.query addAscendingOrder:@"createdAt"];
    // Apply local cache
    [relation.query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error)
        {
            NSLog(@"%@", error);
        }
        else
        {
            NSLog(@"Fetched %lu games with no errors", (unsigned long)objects.count);
        }
        complete(objects);
    }];
}

//- (void)getUserScoresForGame:(Game *)game withCompletion:(void(^)(NSArray *array))complete
//{
//    PFQuery *query = [PFQuery queryWithClassName:@"Score"];
//    [query whereKey:@"scorer" equalTo:self];
//    [query whereKey:@"game" equalTo:]
//
//    PFRelation *relation = [self relationForKey:@"scores"];
//    [relation.query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if (error)
//        {
//            NSLog(@"%@", error);
//        }
//        else
//        {
//            NSLog(@"Fetched %lu scores for %@", (unsigned long)objects.count, self);
//        }
//        complete(objects);
//
//    }];
//}


//--------------------------------------    Get Users    ---------------------------------------------
#pragma mark - Get Users
+ (void)getAllUsers:(void(^)(NSArray *array))complete
{
    PFQuery *query = [PFUser query];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error)
        {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu Users.", objects.count);
        }
        else
        {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        complete(objects);
    }];
}

+ (void)getAllFacebookUsers:(void(^)(NSArray *array))complete
{
    // Issue a Facebook Graph API request to get your user's friend list
    [FBRequestConnection startForMyFriendsWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (error)
        {
            NSLog(@"%@", error);
        }
        else
        {
            // result will contain an array with your user's friends in the "data" key
            NSArray *friendObjects = [result objectForKey:@"data"];
            NSMutableArray *friendIds = [NSMutableArray arrayWithCapacity:friendObjects.count];
            // Create a list of friends' Facebook IDs
            for (NSDictionary *friendObject in friendObjects)
            {
                [friendIds addObject:[friendObject objectForKey:@"id"]];
            }

            // Construct a PFUser query that will find friends whose facebook ids
            // are contained in the current user's friend list.
            PFQuery *friendQuery = [PFUser query];
            [friendQuery whereKey:@"fbId" containedIn:friendIds];

            // findObjects will return a list of PFUsers that are friends
            // with the current user
            [friendQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                NSLog(@"Successfully retrieved %lu Facebook friends.", (unsigned long)objects.count);
                complete(objects);
            }];
        }
    }];
}


//--------------------------------------    Get Friends    ---------------------------------------------
#pragma mark - Get Friends
+ (void)getCurrentUserFriendsWithCompletion:(void(^)(NSArray *currentUserFriends))complete
{
    PFRelation *relation = [[User currentUser] relationForKey:@"friends"];

    [relation.query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error)
        {
            NSLog(@"%@", error);
        }
        else
        {
            NSLog(@"Fetched %lu friends with no errors", (unsigned long)objects.count);
        }
        complete(objects);
    }];
}


//--------------------------------------    Get Achievements    ---------------------------------------------
#pragma mark - Get Achievements
+ (void)getAchievementsWithCompletion:(void(^)(NSArray *array))complete
{
    PFQuery *query = [PFQuery queryWithClassName:@"Achievement"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error)
        {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu achievements.", objects.count);
        }
        else
        {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        complete(objects);
    }];
}


//--------------------------------------    Other    ---------------------------------------------
#pragma mark - Other
+ (void)load {
    [self registerSubclass];
}
+ (NSString *)parseClassName {
    return @"User";
}

@end
