//
//  AchievementViewController.m
//  GNAR
//
//  Created by Chris Giersch on 2/9/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import "AchievementViewController.h"
#import "AchievementDetailViewController.h"
#import "Achievement.h"
#import "User.h"
#import "ParentTableView.h"
#import "ParentTableViewCell.h"
#import "SubTableView.h"
#import "SubTableViewCell.h"


@interface AchievementViewController () <SubTableViewDataSource, SubTableViewDelegate>

@property (weak, nonatomic) IBOutlet ParentTableView *tableView;
@property NSArray *achievementsArray;
@property NSArray *typesArray;
@property NSDictionary *dataDictionary;


@end

@implementation AchievementViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.typesArray = [[NSArray alloc] initWithObjects:@"Line Worths", @"ECPs", @"Penalties", @"Trick Bonuses", nil];
    self.dataDictionary = @{ self.typesArray[0] : @[@"Cornice II Bowl", @"Eagle's Nest", @"Enchanted Forest", @"Fingers", @"Light Towers/Headwall", @"Mainline Pocket", @"Olympic Lady", @"The Nose", @"The Palisades", @"West Side KT22"],
                             self.typesArray[1] : @[@"Daily", @"Yearly", @"Unlimited"],
                             self.typesArray[2] : @[@"Clothing", @"Falling", @"Other"],
                             self.typesArray[3] : @[@"Grabs", @"Inverted", @"Spins", @"Tricks"]
                             };

    [self.tableView setDataSourceDelegate:self];
    [self.tableView setTableViewDelegate:self];

    // Create achievements for testing

//    [User getAchievementsWithCompletion:^(NSArray *array)
//    {
//        self.achievementsArray = array;
//        [self.tableView reloadData];
//    }];

}

//-----------------------------------    SUB Table View Data Source    ----------------------------------------------------
#pragma mark - Sub Table View Data Source - Parent
// @required
- (NSInteger)numberOfParentCells
{
    return self.typesArray.count;
}

- (NSInteger)heightForParentRows
{
    return 75;
}

// @optional
- (NSString *)titleLabelForParentCellAtIndex:(NSInteger)parentIndex
{
    return self.typesArray[parentIndex];
}

- (NSString *)subtitleLabelForParentCellAtIndex:(NSInteger)parentIndex
{
    return @"";
}



#pragma mark - Sub Table View Data Source - Child
// @required
- (NSInteger)numberOfChildCellsUnderParentIndex:(NSInteger)parentIndex
{
    return [self.dataDictionary[self.typesArray[parentIndex]] count];
}

- (NSInteger)heightForChildRows
{
    return 55;
}

// @optional
- (NSString *)titleLabelForCellAtChildIndex:(NSInteger)childIndex withinParentCellIndex:(NSInteger)parentIndex
{
    return [self.dataDictionary[self.typesArray[parentIndex]] objectAtIndex:childIndex];
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

@end
