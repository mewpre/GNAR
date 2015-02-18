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

@dynamic snowLevel, score, completedAt;
@dynamic achievement, achievementPointer;

typedef NS_ENUM(NSInteger, AchievementType) {
    LineWorth,
    ECP,
    TrickBonus,
    Penalty
};


- (instancetype)initScoreWithAchievementData: (NSDictionary *)scoreData
{
    self = [super init];
    // make score related to achievement
    PFRelation *achievementRelation = [self relationForKey:@"achievement"];
    Achievement *achievement = scoreData[@"achievement"];
    [achievementRelation addObject:achievement];
    PFObject *achievementPointer = [self objectForKey:@"achievementPointer"];
    achievementPointer = achievement;
    // add modifiers
    NSArray *modifiers = scoreData[@"modifiersArray"];
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
            {
                NSString *indexString = scoreData[@"snowIndexString"];
                self.score = [achievement.pointValues objectAtIndex:[indexString integerValue]];
            }
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
