//
//  AchievementDetailViewController.m
//  GNAR
//
//  Created by Chris Giersch on 2/9/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import "AchievementDetailViewController.h"
#import "AchievementViewController.h"
#import "SelectPlayersViewController.h"
#import "DetailParentTableView.h"
#import "Achievement.h"
#import "Score.h"
#import "Game.h"
#import "User.h"
#import "Enum.h"
#import "GameManager.h"

@interface AchievementDetailViewController () <SubTableViewDataSource, SubTableViewDelegate, DetailParentTableViewDelegate> //, InfoTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet DetailParentTableView *tableView;
@property NSMutableArray *achievementsDataArray;
@property NSInteger activeParentCellIndex;

@property NSMutableArray *playersArray;
@property NSMutableArray *scoresArray;

@property Game *currentGame;
@property GameManager *myGameManager;

@end

@implementation AchievementDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:( 20/255.0) alpha:1.0];

    // If adding modifiers: change the "Save" button to an new "Add" that will add modifiers to the score instead of save to Parse
    if (self.modifiersDictionary)
    {
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(onAddButtonPressed)];
        // Disable Add button (so you can't add modifiers until you select modifier)
        self.navigationItem.rightBarButtonItem = addButton;

        //TODO: Disable right bar button item until user adds first achievement 
//        self.navigationItem.rightBarButtonItem.enabled = NO;
    }

    self.myGameManager = [GameManager sharedManager];
    // Get current game object from core data singleton
    self.currentGame = self.myGameManager.currentGame;

    [Achievement getAchievementsOfType:self.type inGroup:self.group withCompletion:^(NSArray *array) {
        NSMutableArray *tempArray = [NSMutableArray new];
        for (Achievement *achievement in array)
        {
            // Create Dictionary to contain modifiers to add to scores
            NSMutableDictionary *modifiersDictionary = [NSMutableDictionary new];
            // Create Dictionary to hold scores to save to Parse
            NSMutableArray *playersArray = [[NSMutableArray alloc]initWithObjects:[User currentUser], nil];
            // Set to -1 to make segmented control unselected by default
            NSMutableString *snowLevel = [NSMutableString stringWithFormat:@"-1"];
            NSMutableString *saveKey = [NSMutableString stringWithString: @"NO"];
            NSDictionary *achievementData = @{
                                              @"achievement" : achievement,
                                              @"modifiersDictionary" : modifiersDictionary,
                                              @"playersArray" : playersArray,
                                              @"snowIndexString" : snowLevel,
                                              @"saveKey": saveKey
                                              };
            [tempArray addObject:achievementData];
        }
        self.tableView.childHeightString = [NSMutableString new];
        self.achievementsDataArray = tempArray;
        // *** Must set delegates AFTER you set the tables data source (array)
        [self.tableView setDataSourceDelegate:self];
        [self.tableView setTableViewDelegate:self];
        self.tableView.achievementsArray = self.achievementsDataArray;
        self.tableView.parentDelegate = self;
        [self.tableView reloadData];
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
    [self.view setNeedsUpdateConstraints];
}

//-----------------------------------    SUB Table View Data    ---------------------------------------------
//                             ----------    Parent Cells    ------------
#pragma mark - Sub Table View Data Source - Parent
// @required
- (NSInteger)numberOfParentCells
{
    return self.achievementsDataArray.count;
}

- (NSInteger)heightForParentRows
{
    return 55;
}

// @optional
- (NSString *)titleLabelForParentCellAtIndex:(NSInteger)parentIndex
{
    return [[self.achievementsDataArray[parentIndex] objectForKey:@"achievement"] name];
}

- (NSString *)subtitleLabelForParentCellAtIndex:(NSInteger)parentIndex
{
    if ([[self.achievementsDataArray[parentIndex] objectForKey:@"saveKey"] isEqualToString:@"YES"])
    {
        return @"🌟";
    }
    else
    {
        return @"";
    }
}

//                              ----------    Child Cells    ------------
#pragma mark - Sub Table View Data Source - Child
// @required
- (NSInteger)numberOfChildCellsUnderParentIndex:(NSInteger)parentIndex
{
    return 1;
}

- (NSInteger)heightForChildRows
{
    return [self.tableView.childHeightString integerValue];
}


//---------------------------------    SUB Table View Delegate    --------------------------------------
#pragma mark - Sub Table View Delegate
// @optional
- (void)tableView:(UITableView *)tableView didSelectCellAtChildIndex:(NSInteger)childIndex withInParentCellIndex:(NSInteger)parentIndex
{
//    NSLog(@"Selected child index at %ld with parent index %ld", childIndex, parentIndex);
}

////--------------------------------    InfoTableViewCell Delegate    ---------------------------------------------
//#pragma mark - InfoTableViewCell Delegate Methods
//- (void)didPressAddButton
//{
//    self.navigationItem.rightBarButtonItem.enabled = YES;
//}


//--------------------------------------    Saving Achievements    ---------------------------------------------
#pragma mark - Saving Achievements

// Helper method to save single achievement into Parse
- (void)saveScoresFromAchievementData: (NSDictionary *)scoreData
{
    for (User *user in scoreData[@"playersArray"])
    {
        Score *score = [[Score alloc]initScoreWithAchievementData:scoreData];
        // Set isConfirmed to whether the current user is the scorer of the score
        // Parse takes in NSNumbers for Boolean values
        score.isConfirmed = [NSNumber numberWithBool:[user.objectId isEqualToString:[User currentUser].objectId]];

        [score.scorer addObject:user];
        [score.game addObject:self.currentGame];

        // Get dictionary
        NSDictionary *modifiersDictionary = scoreData[@"modifiersDictionary"];
        // Get users array from dictionary
        // Get all modifiers for user
        NSArray *modifiers = [modifiersDictionary objectForKey:user.username];

        if (modifiers.count != 0)
        {
            for (Score *modifier in modifiers)
            {
                // Add modifer to Score's modifiers relation
//                NSLog(@"Added Modifier to score");
                [score.modifiers addObject:modifier];
            }
        }
        [PFObject saveAllInBackground:modifiers block:^(BOOL succeeded, NSError *error)
         {
             [score saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
              {
//                  NSLog(@"Saved score!");

                  if ([user isEqual:[User currentUser]])
                  {
                      PFRelation *scoreRelation = [user relationForKey:@"scores"];
                      [scoreRelation addObject:score];
                      [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
                       {
                       }];
                  }
              }];
         }];
    }
}

- (void)saveModifiersFromAchievementData:(NSDictionary *)modifierData
{
    for (User *user in modifierData[@"playersArray"])
    {
        Score *score = [[Score alloc]initScoreWithAchievementData:modifierData];
        // Set isConfirmed to whether the current user is the scorer of the score
        // Parse takes in NSNumbers for Boolean values
        score.isConfirmed = [NSNumber numberWithBool:[user.objectId isEqualToString:[User currentUser].objectId]];        [score.scorer addObject:user];
        [score.game addObject:self.currentGame];

        // If userName already exists as key in dictionary:
        if ([[self.modifiersDictionary allKeys] containsObject:user.username])
        {
            // Get array with userName key
            NSMutableArray *userScores = [self.modifiersDictionary objectForKey:user.username];
            [userScores addObject:score];
        }
        else
        {
            // Create new array and add score
            NSMutableArray *userScores = [NSMutableArray arrayWithObject:score];
            [self.modifiersDictionary setObject:userScores forKey:user.username];
        }
    }
}

//-------------------------------------    Actions    ----------------------------------------------------
#pragma mark - Actions
// When right navigation right bar "Add" button pressed: add all modifiers to current Line Worth
- (IBAction)onAddButtonPressed // (this is connected programmatically so that is why the circle is empty)
{
    for (NSDictionary *scoreData in self.achievementsDataArray)
    {
        NSString *saveKey = scoreData[@"saveKey"];
        if ([saveKey isEqualToString:@"YES"])
        {
            [self saveModifiersFromAchievementData:scoreData];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

// When navigation right bar "Save" button pressed at top of view controller: save all scores on Parse
- (IBAction)onSaveButtonPressed:(UIBarButtonItem *)sender
{
    NSMutableSet *playersSet = [NSMutableSet new];
    for (NSDictionary *scoreData in self.achievementsDataArray)
    {
        NSString *saveKey = scoreData[@"saveKey"];
        if ([saveKey isEqualToString:@"YES"])
        {
            [self saveScoresFromAchievementData:scoreData];
            NSArray *playersArray = scoreData[@"playersArray"];
            [playersSet addObjectsFromArray:playersArray];
        }
    }
    for (User *player in playersSet)
    {
        if (![player.objectId isEqual:[User currentUser].objectId])
        {
            PFQuery *userQuery = [PFUser query];
            [userQuery whereKey:@"objectId" equalTo:player.objectId];

            [userQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
//                NSLog(@"%@", object);
            }];
            // Find device associated with user
            PFQuery *pushQuery = [PFInstallation query];
            [pushQuery whereKey:(@"user") matchesQuery:userQuery];

            // Send push notification to query
            PFPush *push = [[PFPush alloc] init];
            NSDictionary *data = @{
                                   @"alert" : [NSString stringWithFormat:@"New GNAR points suggested\nfrom %@!", [[User currentUser] username]],
                                   @"message" : @"Please confirm your scores in the leaderboard!",
                                   @"badge" : @"Increment",
                                   @"type" : @"scoreAlert"
                                   };
            // Set our Installation query
            [push setQuery:pushQuery];
            [push setData:data];
            [push sendPushInBackground];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onAddModifiersButtonPressed:(UIButton *)sender
{
//    NSLog(@"Modifiers button pressed");
    AchievementViewController *achieveVC = [self.storyboard instantiateViewControllerWithIdentifier:[AchievementViewController description]];

    achieveVC.modifiersDictionary = [self.achievementsDataArray objectAtIndex:self.activeParentCellIndex][@"modifiersDictionary"];
    [self.navigationController pushViewController:achieveVC animated:YES];
}



//----------------------------------    Prepare For Segue    -------------------------------------------------
#pragma mark - Prepare for Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    {
        SelectPlayersViewController *selectVC = segue.destinationViewController;
        selectVC.selectedUsersArray = [self.achievementsDataArray objectAtIndex:self.activeParentCellIndex][@"playersArray"];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:nil action:nil];
    }
}

- (void)didGetIndex:(NSInteger)index
{
    self.activeParentCellIndex = index;
}













@end
