//
//  Score.m
//  GNAR
//
//  Created by Chris Giersch on 2/10/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import "Score.h"
#import "Achievement.h"

@implementation Score

@dynamic snowLevel;
@dynamic score;
@dynamic completedAt;

typedef NS_ENUM(NSInteger, AchievementType) {
    LineWorth,
    ECP,
    TrickBonus,
    Penalty
};


- (instancetype)initScoreWithAchievement:(Achievement *)achievement withModifiers:(NSArray *)modifiers
{
    self = [super init];
    // make score related to achievement
    PFRelation *achievementRelation = [self relationForKey:@"achievement"];
    [achievementRelation addObject:achievement];

    // add modifiers
    if (modifiers.count != 0)
    {
        for (Score *modifier in modifiers)
        {
            PFRelation *modifierRelation = [self relationForKey:@"modifiers"];
            [modifierRelation addObject:modifier];
        }
    }

    if (achievement.pointValues.count == 1)
    {
        self.score = achievement.pointValues.firstObject;
    }
    else
    {
        AchievementType type = achievement.type;
        switch (type)
        {
            case LineWorth:
#warning                //do logic to get score based on snow level
                self.score = achievement.pointValues.firstObject;
                //note: a score of 0 means it's not rated
                break;

                case ECP:
#warning                //do logic to get score based on gender
                break;
                
            default:
                break;
        }

    }



    return self;
}





+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Score";
}

@end
