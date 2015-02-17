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
#import "Enum.h"

@interface AchievementDetailViewController () <SubTableViewDataSource, SubTableViewDelegate, DetailParentTableViewDelegate, SelectPlayersViewControllerDelegate>

@property (weak, nonatomic) IBOutlet DetailParentTableView *tableView;
@property NSMutableArray *achievementsDataArray;
@property NSMutableArray *playersArrayForPassing;
@property NSInteger activeParentCellIndex;

@property NSMutableArray *playersArray;
@property NSMutableArray *scoresArray;

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
            NSDictionary *achievementData = @{
                                              @"achievement" : achievement,
                                              @"modifiersArray" : modifiersArray,
                                              @"playersArray" : playersArray,
                                              @"snowIndexString" : snowLevel
                                              };
            [tempArray addObject:achievementData];
        }

        self.achievementsDataArray = tempArray;
        // *** Must set delegates AFTER you set the tables data source (array)
        [self.tableView setDataSourceDelegate:self];
        [self.tableView setTableViewDelegate:self];
        self.tableView.achievementsArray = self.achievementsDataArray;
        self.tableView.parentDelegate = self;
        [self.tableView reloadData];
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
    return 75;
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
    return 400;
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

//Only used for testing for now
//- (void)tableView:(UITableView *)tableView didSelectParentCellAtIndex:(NSInteger)parentIndex
//{
////    Achievement *selectedAchievement = [self.achievementsArray objectAtIndex:parentIndex];
////    [self saveScoresFromAchievement:selectedAchievement toUsers:@[[PFUser currentUser]]];
//    NSLog(@"Pressed cell");
////    [self performSegueWithIdentifier:@"AddAchievementSegue" sender:self.achievementsArray[parentIndex]];
//}



// Helper method to save single achievement into Parse
- (void)saveScoresFromAchievement: (Achievement *) achievement toUsers:(NSArray *)usersArray
{
    for (PFUser *user in usersArray)
    {
        // TODO: Implement logic to get modifiers from custom table view cell
#warning        //Implement logic to get modifiers from custom table view cell
        NSArray *modifiersArray = @[];
        Score *score = [[Score alloc]initScoreWithAchievement:achievement withModifiers:modifiersArray];
            PFRelation *scorerRelation = [score relationForKey:@"scorer"];
            [scorerRelation addObject:[PFUser currentUser]];
            [score saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
             {
                 PFRelation *scoresRelation = [[PFUser currentUser] relationForKey:@"scores"];
                 [scoresRelation addObject:score];
                 [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
                  {
                  }];
            }];
    }
}



//-------------------------------------    Actions    ----------------------------------------------------
#pragma mark - Actions
- (IBAction)onSaveButtonPressed:(UIBarButtonItem *)sender
{
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
//    [self performSegueWithIdentifier:@"SelectPlayersSegue" sender:self];
}

- (void)didPressDoneButtonWithSelectedUsers:(NSMutableArray *)selectedUsersArray
{
    NSLog(@"addFriendsSaveButtonPressed method called");
    [self.tableView reloadData];
    
}













@end
