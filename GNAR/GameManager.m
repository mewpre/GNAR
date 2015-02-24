//
//  GameManager.m
//  GNAR
//
//  Created by Chris Giersch on 2/17/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import "GameManager.h"

@implementation GameManager

//@synthesize currentGame;
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

- (void)printCurrentGame
{
    NSLog(@"Saved singleton game: %@", self.currentGame.name);
    NSLog(@"Saved singleton game player count: %lu", self.currentGame.playersArray.count);
}

//- (GameManager *)init
//{
//    if (self = [super init])
//    {
//        currentGame = [Game new];
//    }
//    return self;
//}



- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

@end
