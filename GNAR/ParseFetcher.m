//
//  ParseFetcher.m
//  GNAR
//
//  Created by Chris Giersch on 2/9/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import "ParseFetcher.h"

@implementation ParseFetcher

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

@end
