//
//  Score.h
//  GNAR
//
//  Created by Chris Giersch on 2/10/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import <Parse/Parse.h>
@class Achievement;

@interface Score : PFObject <PFSubclassing>

@property (retain) NSString *snowLevel;
@property (retain) NSNumber *score;
@property (retain) NSDate *completedAt;

+ (NSString *)parseClassName;

- (instancetype)initScoreWithAchievement:(Achievement *)achievement withModifiers: (NSArray *)modifiers;


@end
