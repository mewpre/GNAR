//
//  AchievementDetailViewController.m
//  GNAR
//
//  Created by Chris Giersch on 2/9/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import "AchievementDetailViewController.h"
#import "SelectPlayersViewController.h"
#import "ParentTableView.h"
#import "DetailParentTableView.h"
#import "ParentTableViewCell.h"
#import "AchievementDetailTableView.h"
//#import "SubTableView.h"
//#import "SubTableViewCell.h"
#import "Achievement.h"
#import "Score.h"
#import "Game.h"
#import "User.h"
#import "Enum.h"

@interface AchievementDetailViewController () <SubTableViewDataSource, SubTableViewDelegate, DetailParentTableViewDelegate, SelectPlayersViewControllerDelegate>

@property (weak, nonatomic) IBOutlet DetailParentTableView *tableView;
@property NSMutableArray *achievementsDataArray;
@property NSMutableArray *playersArrayForPassing;
@property NSInteger activeParentCellIndex;

@property NSMutableArray *playersArray;
@property NSMutableArray *scoresArray;

@property Game *currentGame;

@end

@implementation AchievementDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [Achievement getAchievementsOfType:self.type inGroup:self.group withCompletion:^(NSArray *array) {
        NSMutableArray *tempArray = [NSMutableArray new];
        for (Achievement *achievement in array)
        {
            NSMutableArray *modifiersArray = [NSMutableArray new];
            NSMutableArray *playersArray = [NSMutableArray new];
            NSMutableString *snowLevel = [NSMutableString new];
            NSMutableString *saveKey = [NSMutableString stringWithString: @"NO"];
            NSDictionary *achievementData = @{
                                              @"achievement" : achievement,
                                              @"modifiersArray" : modifiersArray,
                                              @"playersArray" : playersArray,
                                              @"snowIndexString" : snowLevel,
                                              @"saveKey": saveKey,
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
         [User getCurrentUserGamesWithCompletion:^(NSArray *array)
        {
            self.currentGame = array.firstObject;
        }];
    }];

}


//-----------------------------------    SUB Table View Data Source    ----------------------------------------------------
#pragma mark - Sub Table View Data Source - Parent
// @required
- (NSInteger)numberOfParentCells
{
    return self.achievementsDataArray.count;
}

- (NSInteger)heightForParentRows
{
    return 65;
}

// @optional
- (NSString *)titleLabelForParentCellAtIndex:(NSInteger)parentIndex
{
    return [[self.achievementsDataArray[parentIndex] objectForKey:@"achievement"] name];
}

- (NSString *)subtitleLabelForParentCellAtIndex:(NSInteger)parentIndex
{
    return @"";
}



#pragma mark - Sub Table View Data Source - Child
// @required
- (NSInteger)numberOfChildCellsUnderParentIndex:(NSInteger)parentIndex
{
    return 1;
}

- (NSInteger)heightForChildRows
{
    NSLog(@"%ld", (long)[self.tableView.childHeightString integerValue]);
//    return [self.tableView.childHeightString integerValue];
    return 450;
}



// @optional
//- (NSString *)titleLabelForCellAtChildIndex:(NSInteger)childIndex withinParentCellIndex:(NSInteger)parentIndex
//{
//    return @"Child Label";
//}
//
//- (NSString *)subtitleLabelForCellAtChildIndex:(NSInteger)childIndex withinParentCellIndex:(NSInteger)parentIndex
//{
//    return @"";
//}

//---------------------------------    SUB Table View Delegate    ----------------------------------------------------
#pragma mark - Sub Table View Delegate
// @optional
- (void)tableView:(UITableView *)tableView didSelectCellAtChildIndex:(NSInteger)childIndex withInParentCellIndex:(NSInteger)parentIndex
{
    NSLog(@"Selected child index at %lu with parent index %lu", childIndex, parentIndex);
}

// Helper method to save single achievement into Parse
- (void)saveScoresFromAchievementData: (NSDictionary *)scoreData
{
    for (PFUser *user in scoreData[@"playersArray"])
    {
        Score *score = [[Score alloc]initScoreWithAchievementData:scoreData];
        PFRelation *scorerRelation = [score relationForKey:@"scorer"];
        [scorerRelation addObject:user];
        PFRelation *gameRelation = [score relationForKey:@"game"];
        [gameRelation addObject:self.currentGame];
        [score saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
         {
             NSLog(@"Saved score!");
             if ([user isEqual:[PFUser currentUser]])
             {
                 PFRelation *scoreRelation = [user relationForKey:@"scores"];
                 [scoreRelation addObject:score];
                 [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
                 {
                     NSLog(@"Saved score to self");
                 }];
             }
         }];
    }
}



//-------------------------------------    Actions    ----------------------------------------------------
#pragma mark - Actions
- (IBAction)onSaveButtonPressed:(UIBarButtonItem *)sender
{
    for (NSDictionary *scoreData in self.achievementsDataArray)
    {
        NSString *saveKey = scoreData[@"saveKey"];
        if ([saveKey isEqualToString:@"YES"])
        {
            [self saveScoresFromAchievementData:scoreData];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

//----------------------------------    Prepare For Segue    -------------------------------------------------
#pragma mark - Prepare for Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    SelectPlayersViewController *selectVC = segue.destinationViewController;
    selectVC.delegate = self;
    selectVC.selectedUsersArray = [self.achievementsDataArray objectAtIndex:self.activeParentCellIndex][@"playersArray"];

}


- (void)didGetIndex:(NSInteger)index
{
    self.activeParentCellIndex = index;
}

- (void)didPressDoneButtonWithSelectedUsers:(NSMutableArray *)selectedUsersArray
{
    NSLog(@"addFriendsSaveButtonPressed method called");
    [self.tableView reloadData];
    [self.view setNeedsUpdateConstraints];

}













@end
