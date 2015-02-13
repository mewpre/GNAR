//
//  Game.m
//  GNAR
//
//  Created by Chris Giersch on 2/10/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import "Game.h"

@implementation Game

@dynamic name;
@dynamic mountain;
@dynamic startAt;
@dynamic endAt;

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

- (void)getPlayersOfGameWithCompletion:(void(^)(NSArray *array))complete
{
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
