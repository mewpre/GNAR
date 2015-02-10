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


+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"User";
}

@end
