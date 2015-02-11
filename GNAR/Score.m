//
//  Score.m
//  GNAR
//
//  Created by Chris Giersch on 2/10/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import "Score.h"

@implementation Score

@dynamic snowLevel;
@dynamic score;
@dynamic completedAt;








+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Score";
}

@end
