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
    [relation.query includeKey:@"friends"];
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

+ (void)getCurrentUserFriendsWithCompletion:(void(^)(NSArray *array))complete
{
    PFRelation *relation = [[PFUser currentUser] relationForKey:@"friends"];

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
