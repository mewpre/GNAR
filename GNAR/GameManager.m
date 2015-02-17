//
//  GameManager.m
//  GNAR
//
//  Created by Chris Giersch on 2/17/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import "GameManager.h"

@implementation GameManager

@synthesize currentGame;

+ (id)sharedManager
{
    static GameManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
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
