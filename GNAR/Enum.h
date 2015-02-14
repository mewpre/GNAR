//
//  Enum.h
//  GNAR
//
//  Created by Chris Giersch on 2/14/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Enum : NSObject

// Achievement types
typedef NS_ENUM(NSInteger, AchievementType)
{
    LineWorth,
    ECP,
    TrickBonus,
    Penalty
};

// Section types for LineWorth (for AddAchievementViewController custom table view)
typedef NS_ENUM(NSInteger, LineWorthSectionType)
{
    LWInfoCell,
    LWSnowCell,
    LWModifierCell,
    LWAddModifierCell,
    LWPlayerCell,
    LWAddPlayerCell
};

// Section types for all other point types (for AddAchievementViewController custom table view)
typedef NS_ENUM(NSInteger, ScoreSectionType)
{
    InfoCell,
    PlayerCell,
    AddPlayerCell
};

@end
