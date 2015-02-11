//
//  Achievement.h
//  GNAR
//
//  Created by Chris Giersch on 2/10/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import <Parse/Parse.h>

@interface Achievement : PFObject <PFSubclassing>

typedef NS_ENUM(NSInteger, AchievementType) {
    LineWorth,
    ECP,
    TrickBonus,
    Penalty
};

@property (retain) NSString *name;
@property (retain) NSString *abbreviation;
@property (retain) NSArray *pointValues;
//@property (retain) CLLocation *location;
@property BOOL isAvailable;
@property BOOL isCustom;
@property AchievementType type;
//@property double timeLimiter;
@property (retain) NSString *description;
@property (retain) NSString *group;
@property (retain) NSString *difficulty;
@property (retain) NSString *heroFactor;
@property (retain) NSString *funFactor;


+ (NSString *)parseClassName;

@end
