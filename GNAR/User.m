//
//  User.m
//  GNAR
//
//  Created by Chris Giersch on 2/10/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import "User.h"

@implementation User

@dynamic firstName;
@dynamic lastName;
//@dynamic lastKnownLocation;
@dynamic type;
@dynamic gender;
@dynamic birthday;
@dynamic homeMountain;
@dynamic ability;

@dynamic profileImage;

+ (void)getCurrentUserGamesWithCompletion:(void(^)(NSArray *array))complete
{
    PFRelation *relation = [[PFUser currentUser] relationForKey:@"games"];

    [relation.query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error)
        {
            NSLog(@"%@", error);
        }
        else
        {
            NSLog(@"Fetched games with no errors");
        }
        complete(objects);
    }];
}

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


+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"User";
}

@end
