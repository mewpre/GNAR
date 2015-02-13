//
//  Game.h
//  GNAR
//
//  Created by Chris Giersch on 2/10/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import <Parse/Parse.h>

@interface Game : PFObject <PFSubclassing>

@property (retain) NSString *name;
@property (retain) NSString *mountain;
@property (retain) NSDate *startAt;
@property (retain) NSDate *endAt;

- (instancetype)initWithName:(NSString *)name mountain:(NSString *)mountain;
- (void)getPlayersOfGameWithCompletion:(void(^)(NSArray *array))complete;
+ (NSString *)parseClassName;

@end
