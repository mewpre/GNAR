//
//  AchievementDetailViewController.m
//  GNAR
//
//  Created by Chris Giersch on 2/9/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import "AchievementDetailViewController.h"
#import "ParentTableView.h"
#import "ParentTableViewCell.h"
#import "SubTableView.h"
#import "SubTableViewCell.h"
#import "Achievement.h"

@interface AchievementDetailViewController () <SubTableViewDataSource, SubTableViewDelegate>

@property (weak, nonatomic) IBOutlet ParentTableView *tableView;
@property NSArray *achievementsArray;
@property NSArray *childrenArray;

typedef NS_ENUM(NSInteger, AchievementType) {
    LineWorth,
    ECP,
    TrickBonus,
    Penalty
};

@end

@implementation AchievementDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];


    self.childrenArray = @[@"BLARGH"];

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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
