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

@property (retain) NSString *firstName;
@property (retain) NSString *lastName;
@property (retain) PFGeoPoint *lastKnownLocation;
@property (retain) NSString *type;
@property (retain) NSString *gender;
@property (retain) NSDate *birthday;
@property (retain) NSString *homeMountain;
@property (retain) NSNumber *ability;
@property (retain) UIImage *profileImage;

//@property (retain, nonatomic) PFRelation *friends;
@property (retain, nonatomic) PFRelation *games;
@property (retain, nonatomic) PFRelation *scores;
//@property (retain, nonatomic) PFRelation *createdAchievements;
@property (retain, nonatomic) PFRelation *createdGames;



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
