//
//  GameManager.m
//  GNAR
//
//  Created by Chris Giersch on 2/17/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import "GameManager.h"

@implementation GameManager

static GameManager *gameManager = nil;

+ (GameManager *)sharedManager
{
    if (!gameManager)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            gameManager = [[self alloc] init];
        });
    }
    return gameManager;
}


//- (id)init
//{
//    if (self = [super init]) {
//        someProperty = [[NSString alloc] initWithString:@"Default Property Value"];
//    }
//    return self;
//}



- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

@end
