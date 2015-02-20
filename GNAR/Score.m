//
//  Score.m
//  GNAR
//
//  Created by Chris Giersch on 2/10/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import "Score.h"
#import "Achievement.h"
#import "User.h"

@implementation Score

@dynamic snowLevel, score, completedAt;
@dynamic achievement, achievementPointer;

@synthesize modifiers = _modifiers;
@synthesize game = _game;
@synthesize scorer = _scorer;


- (void) setModifiers:(PFRelation *)modifiers{
    _modifiers = modifiers;
}
- (PFRelation *) modifiers{
    if(_modifiers== nil) {
        _modifiers = [self relationForKey:@"modifiers"];
    }
    return _modifiers;
}
- (void) setgame:(PFRelation *)game
{
    _game = game;
}
- (PFRelation *) game{
    if(_game== nil) {
        _game = [self relationForKey:@"game"];
    }
    return _game;
}
- (void) setscorer:(PFRelation *)scorer{
    _scorer = scorer;
}
- (PFRelation *) scorer{
    if(_scorer== nil) {
        _scorer = [self relationForKey:@"scorer"];
    }
    return _scorer;
}


typedef NS_ENUM(NSInteger, AchievementType) {
    LineWorth,
    ECP,
    TrickBonus,
    Penalty
};



- (instancetype)initScoreWithAchievementData: (NSDictionary *)scoreData
{
    self = [super init];

    PFRelation *achievementRelation = [self relationForKey:@"achievement"];
    // Get achievement (pointer) from scoreData dictionary
    Achievement *achievement = scoreData[@"achievement"];
//    // Set Score's achievement relation
//    [achievementRelation addObject:achievement];

    // Set Score's Pointer to achievement
    [self setObject:achievement forKey:@"achievementPointer"];

//    // Get dictionary
//    NSDictionary *modifiersDictionary = scoreData[@"modifiersDictionary"];
//    // Get users array from dictionary
//    NSArray *usersArray = modifiersDictionary[@"users"];
//
//    for (User *user in usersArray)
//    {
//        // Get all modifiers for user
//        NSArray *modifiers = [scoreData objectForKey:user.username];
//
//        if (modifiers.count != 0)
//        {
//            for (Score *modifier in modifiers)
//            {
//                // Add modifer to Score's modifiers relation
//                PFRelation *modifierRelation = [self relationForKey:@"modifiers"];
//                [modifierRelation addObject:modifier];
//            }
//        }
//    }

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
                //TODO:do logic to get score based on gender
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
