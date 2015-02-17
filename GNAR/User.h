//
//  User.h
//  GNAR
//
//  Created by Chris Giersch on 2/10/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>

@interface User : PFUser <PFSubclassing>

@property (retain) NSString *firstName;
@property (retain) NSString *lastName;
//@property (retain) CLLocation *lastKnownLocation;
@property (retain) NSString *type;
@property (retain) NSString *gender;
@property (retain) NSDate *birthday;
@property (retain) NSString *homeMountain;
@property (retain) NSNumber *ability;
@property (retain) UIImage *profileImage;

@property NSArray *scores;

//- (void)getUserScoresWithCompletion:(void(^)(NSArray *array))complete;
+ (void)getCurrentUserScoresWithCompletion:(void(^)(NSArray *userScoresIncludingModifiers))complete;
+ (void)getCurrentUserGamesWithCompletion:(void(^)(NSArray *currentUserGames))complete;
+ (void)getCurrentUserFriendsWithCompletion:(void(^)(NSArray *currentUserFriends))complete;
+ (void)getAllUsers:(void(^)(NSArray *array))complete;
+ (void)getAllFacebookUsers:(void(^)(NSArray *array))complete;

+ (void)getAchievementsWithCompletion:(void(^)(NSArray *array))complete;

+ (NSString *)parseClassName;

@end
