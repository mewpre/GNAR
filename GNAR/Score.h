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
@property BOOL isConfirmed;

@property Achievement *achievement;
@property Achievement *achievementPointer;

@property (retain, nonatomic) PFRelation *modifiers;
@property (retain, nonatomic) PFRelation *game;
@property (retain, nonatomic) PFRelation *scorer;


+ (NSString *)parseClassName;

- (instancetype)initScoreWithAchievementData: (NSDictionary *)scoreData;


@end
