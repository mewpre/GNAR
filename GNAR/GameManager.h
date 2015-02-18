//
//  GameManager.h
//  GNAR
//
//  Created by Chris Giersch on 2/17/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Game.h"

@interface GameManager : NSObject

@property Game *currentGame;

+ (id)sharedManager;

@end
