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

@property NSArray *playersArray;

@property (retain, nonatomic) PFRelation *players;
@property (retain, nonatomic) PFRelation *creator;

- (void)saveGame;
+ (void)loadSavedGame;
+ (void)loadSavedGameWithCompletion:(void(^)(Game *loadedGame))complete;

+ (void)getCurrentGameWithCompletion:(void(^)(Game *currentGame))complete;
- (instancetype)initWithName:(NSString *)name mountain:(NSString *)mountain;
+ (void)getGameWithId:(NSString *)gameId withCompletion:(void(^)(Game *game))complete;
- (void)getGameWithCompletion:(void(^)(Game *game))complete;
+ (void)getAllGames:(void(^)(NSArray *allGames))complete;
- (void)getPlayersOfGameWithCompletion:(void(^)(NSArray *players))complete;
+ (NSString *)parseClassName;

@end
