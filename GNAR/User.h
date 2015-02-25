//
//  User.h
//  GNAR
//
//  Created by Chris Giersch on 2/10/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "Game.h"

@interface User : PFUser <PFSubclassing>

@property NSString *firstName;
@property NSString *lastName;
@property PFGeoPoint *lastKnownLocation;
@property NSString *type;
@property NSString *gender;
@property NSDate *birthday;
@property NSString *homeMountain;
@property NSNumber *ability;
@property PFFile *profileImage;

//@property (nonatomic) PFRelation *friends;
@property (nonatomic) PFRelation *games;
@property (nonatomic) PFRelation *scores;
//@property (nonatomic) PFRelation *createdAchievements;
@property (nonatomic) PFRelation *createdGames;

//@property NSMutableArray *scores;

- (void)getUserScoresForGame:(Game *)game withCompletion:(void(^)(NSArray *array))complete;
//+ (void)getCurrentUserScoresWithCompletion:(void(^)(NSArray *userScoresIncludingModifiers))complete;
+ (void)getCurrentUserGamesWithCompletion:(void(^)(NSArray *currentUserGames))complete;
+ (void)getCurrentUserFriendsWithCompletion:(void(^)(NSArray *currentUserFriends))complete;
+ (void)getAllUsers:(void(^)(NSArray *array))complete;
+ (void)getAllFacebookUsers:(void(^)(NSArray *array))complete;

+ (void)getAchievementsWithCompletion:(void(^)(NSArray *array))complete;

+ (NSString *)parseClassName;

@end
