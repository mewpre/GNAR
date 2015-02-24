//
//  Achievement.m
//  GNAR
//
//  Created by Chris Giersch on 2/10/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import "Achievement.h"

@implementation Achievement

@dynamic name;
@dynamic abbreviation;
@dynamic pointValues;
//@dynamic location;
@dynamic isAvailable;
@dynamic isCustom;
@dynamic type;
//@dynamic timeLimiter;
@dynamic description;
@dynamic group;
@dynamic difficulty;
@dynamic heroFactor;
@dynamic funFactor;


+ (void)getAchievementsOfType:(NSInteger)type inGroup:(NSString *)group withCompletion:(void(^)(NSArray *array))complete
{
    PFQuery *query = [PFQuery queryWithClassName:@"Achievement"];
    [query whereKey:@"type" equalTo: [NSNumber numberWithInteger: type]];
    [query whereKey:@"group" equalTo:group];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error)
        {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu achievements.", (unsigned long)objects.count);
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
    return @"Achievement";
}

@end
