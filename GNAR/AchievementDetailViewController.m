//
//  AchievementDetailViewController.m
//  GNAR
//
//  Created by Chris Giersch on 2/9/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import "AchievementDetailViewController.h"
#import "AddAchievementViewController.h"
#import "ParentTableView.h"
#import "ParentTableViewCell.h"
#import "SubTableView.h"
#import "SubTableViewCell.h"
#import "Achievement.h"
#import "Score.h"
#import "Enum.h"

@interface AchievementDetailViewController () <SubTableViewDataSource, SubTableViewDelegate>

@property (weak, nonatomic) IBOutlet ParentTableView *tableView;
@property NSArray *achievementsArray;
@property NSArray *childrenArray;

@property NSMutableArray *scoresArray;

@end

@implementation AchievementDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [Achievement getAchievementsOfType:self.type inGroup:self.group withCompletion:^(NSArray *array) {
        self.achievementsArray = array;

        // *** Must set delegates AFTER you set the tables data source (array)
        [self.tableView setDataSourceDelegate:self];
        [self.tableView setTableViewDelegate:self];
        [self.tableView reloadData];
    }];
}


//-----------------------------------    SUB Table View Data Source    ----------------------------------------------------
#pragma mark - Sub Table View Data Source - Parent
// @required
- (NSInteger)numberOfParentCells
{
    return self.achievementsArray.count;
}

- (NSInteger)heightForParentRows
{
    return 75;
}

// @optional
- (NSString *)titleLabelForParentCellAtIndex:(NSInteger)parentIndex
{
    return [self.achievementsArray[parentIndex] name];
}

- (NSString *)subtitleLabelForParentCellAtIndex:(NSInteger)parentIndex
{
    return @"";
}



#pragma mark - Sub Table View Data Source - Child
// @required
- (NSInteger)numberOfChildCellsUnderParentIndex:(NSInteger)parentIndex
{
    return self.childrenArray.count;
}

- (NSInteger)heightForChildRows
{
    return 55;
}

// @optional
- (NSString *)titleLabelForCellAtChildIndex:(NSInteger)childIndex withinParentCellIndex:(NSInteger)parentIndex
{
    return @"Child Label";
}

- (NSString *)subtitleLabelForCellAtChildIndex:(NSInteger)childIndex withinParentCellIndex:(NSInteger)parentIndex
{
    return @"";
}

//-----------------------------------    SUB Table View Delegate    ----------------------------------------------------
#pragma mark - Sub Table View Delegate
// @optional
- (void)tableView:(UITableView *)tableView didSelectCellAtChildIndex:(NSInteger)childIndex withInParentCellIndex:(NSInteger)parentIndex
{
    
}

//Only used for testing for now
- (void)tableView:(UITableView *)tableView didSelectParentCellAtIndex:(NSInteger)parentIndex
{
//    Achievement *selectedAchievement = [self.achievementsArray objectAtIndex:parentIndex];
//    [self saveScoresFromAchievement:selectedAchievement toUsers:@[[PFUser currentUser]]];
    NSLog(@"Pressed cell");
    [self performSegueWithIdentifier:@"AddAchievementSegue" sender:self.achievementsArray[parentIndex]];
}



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

//-------------------------------------    Prepare For Segue    ----------------------------------------------------
#pragma mark - Prepare for Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    AddAchievementViewController *addVC = segue.destinationViewController;
    addVC.achievement = sender;
}
















@end
