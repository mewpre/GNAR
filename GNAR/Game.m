//
//  Game.m
//  GNAR
//
//  Created by Chris Giersch on 2/10/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import "User.h"
#import "Game.h"
#import "GameManager.h"

@implementation Game

@dynamic name;
@dynamic mountain;
@dynamic startAt;
@dynamic endAt;
@dynamic playersArray;

@synthesize players = _players;
@synthesize creator = _creator;

- (void)saveGame
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:self];
    [defaults setObject:myEncodedObject forKey:@"CurrentGame"];
    [defaults synchronize];
    [GameManager sharedManager].currentGame = self;
}

+ (void)loadSavedGame
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    // Load game object from defaults
    NSData *myEncodedGame = [defaults objectForKey:@"CurrentGame"];
    Game *game = (Game *)[NSKeyedUnarchiver unarchiveObjectWithData:myEncodedGame];

    // Else: laod game from defaults only (which doesn't have realations connected yet)
    //TODO: encode game PFRelations so we can pull relations from nsuserdefaults too
    [GameManager sharedManager].currentGame = game;
//    [GameManager sharedManager].currentPlayers = 

    // Update players
    
}

+ (void)loadSavedGameWithCompletion:(void(^)(Game *loadedGame))complete
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // Load GAME ID from defaults
    NSString *gameId = [defaults objectForKey:@"CurrentGameId"];
    // Load game from parse
    [Game getGameWithId:gameId withCompletion:^(Game *game) {
        // Save game to NSUserDefaults
        [GameManager sharedManager].currentGame = game;
        NSLog(@"Loaded game: %@", game);
        complete(game);
    }];

}


- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.mountain forKey:@"mountain"];
    [encoder encodeObject:self.startAt forKey:@"startAt"];
    [encoder encodeObject:self.endAt forKey:@"endAt"];

    [encoder encodeObject:self.playersArray forKey:@"playersArray"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self)
    {
        self.name = [decoder decodeObjectForKey:@"name"];
        self.mountain = [decoder decodeObjectForKey:@"mountain"];
        self.startAt = [decoder decodeObjectForKey:@"startAt"];
        self.endAt = [decoder decodeObjectForKey:@"endAt"];
        self.playersArray = [decoder decodeObjectForKey:@"playersArray"];
    }
    return self;
}

- (void)setPlayers:(PFRelation *)players
{
    _players = players;
}

- (PFRelation *)players
{
    if(_players == nil)
    {
        _players = [self relationForKey:@"players"];
    }
    return _players;
}

- (void)setCreator:(PFRelation *)creator
{
    _creator = creator;
}

- (PFRelation *)creator
{
    if(_creator == nil)
    {
        _creator = [self relationForKey:@"creator"];
    }
    return _creator;
}


- (instancetype)initWithName:(NSString *)name mountain:(NSString *)mountain
{
    self = [super init];
    if (self)
    {
        self.name = name;
        self.mountain = mountain;
    }
    return self;
}

//--------------------------------------    Get Games    ---------------------------------------------
#pragma mark - Get Games
+ (void)getCurrentGameWithCompletion:(void(^)(Game *currentGame))complete
{
    PFQuery *query = [PFQuery queryWithClassName:@"Game"];
    [query whereKey:@"players" equalTo:[User currentUser]];
    [query setCachePolicy:kPFCachePolicyCacheThenNetwork];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error)
        {
            NSLog(@"Fetched with error: %@", error);
        }
        else
        {
            NSLog(@"Fetched %lu games.", objects.count);
        }
        complete(objects.firstObject);
    }];
}

+ (void)getGameWithId:(NSString *)gameId withCompletion:(void(^)(Game *game))complete
{
    PFQuery *query = [PFQuery queryWithClassName:@"Game"];
    [query whereKey:@"objectId" equalTo:gameId];
//    [query includeKey:@"players"];

//    [query setCachePolicy:kPFCachePolicyCacheThenNetwork];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        complete(objects.firstObject);
    }];
}

- (void)getGameWithCompletion:(void(^)(Game *game))complete
{
    PFQuery *query = [PFQuery queryWithClassName:@"Game"];
    [query whereKey:@"objectId" equalTo:self.objectId];

    [query setCachePolicy:kPFCachePolicyCacheThenNetwork];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        complete(objects.firstObject);
    }];
}

+ (void)getAllGames:(void(^)(NSArray *allGames))complete
{
    PFQuery *query = [PFQuery queryWithClassName:@"Game"];
    [query addAscendingOrder:@"createdAt"];
    [query includeKey:@"players"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        complete(objects);
    }];
}

- (void)getPlayersOfGameWithCompletion:(void(^)(NSArray *players))complete
{
    PFRelation *relation = [self relationForKey:@"players"];
    
    [relation.query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error)
        {
            NSLog(@"%@", error);
        }
        else
        {
            NSLog(@"Fetched %lu players from game.", objects.count);
        }
        complete(objects);
    }];
}







+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Game";
}

@end
