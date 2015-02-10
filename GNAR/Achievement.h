//
//  Achievement.h
//  GNAR
//
//  Created by Chris Giersch on 2/10/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import <Parse/Parse.h>

@interface Achievement : PFObject <PFSubclassing>

@property (retain) NSString *name;
@property (retain) NSString *abbreviation;
@property (retain) NSArray *pointValues;
//@property (retain) CLLocation *location;
@property BOOL isAvailable;
@property BOOL isCustom;
@property (retain) NSString *type;
@property (retain) NSString *snowLevel;
//@property double timeLimiter;
@property (retain) NSString *description;
@property (retain) NSString *difficulty;
@property (retain) NSString *heroFactor;
@property (retain) NSString *funFactor;

@property (retain) NSDate *completedAt;


+ (NSString *)parseClassName;

@end
