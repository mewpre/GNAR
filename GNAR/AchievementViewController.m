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
//#import "SubTableView.h"
//#import "SubTableViewCell.h"


@interface AchievementViewController () <SubTableViewDataSource, SubTableViewDelegate>

@property (weak, nonatomic) IBOutlet ParentTableView *tableView;
@property NSArray *achievementsArray;
@property NSArray *typesArray;
@property NSDictionary *dataDictionary;

@property NSInteger selectedParentIndex;


@end

@implementation AchievementViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.typesArray = [[NSArray alloc] initWithObjects:@"Line Worths", @"ECPs", @"Penalties", @"Trick Bonuses", nil];
    self.dataDictionary = @{ self.typesArray[0] : @[@"Cornice II Bowl", @"Eagle's Nest", @"Enchanted Forest", @"Fingers", @"Light Towers/Headwall", @"Mainline Pocket", @"Olympic Lady", @"The Nose", @"The Palisades", @"West Side KT22"],
                             self.typesArray[1] : @[@"Daily ECPs", @"Yearly ECPs", @"Unlimited ECPs"],
                             self.typesArray[2] : @[@"Clothing", @"Falling", @"Other"],
                             self.typesArray[3] : @[@"Grabs", @"Inverted", @"Spins", @"Tricks"]
                             };

    [self.tableView setDataSourceDelegate:self];
    [self.tableView setTableViewDelegate:self];

    // Create achievements for testing
//    Achievement *ML = [Achievement new];
//    ML[@"name"] = @"The Loft";
//    //    ML[@"description"] = @"Make headband or hat out of Priority Mail tape from Olympic Valley Post Office. Get signed by \"Postman Larry\" and ski with it on for 3 full days.";
//    ML[@"type"] = @0;
//    ML[@"group"] = @"The Palisades";
//    [ML saveInBackground];
//
//    Achievement *BT = [Achievement new];
//    BT[@"name"] = @"The Tube";
//    //    BT[@"description"] = @"Make your own sticker out of \"I SKI SQUAW\" or \"I SNOWBOARD SQUAW\" stickers and place it on your car for the season.";
//    BT[@"type"] = @0;
//    BT[@"group"] = @"The Palisades";
//    [BT saveInBackground];
//
//    Achievement *CB = [Achievement new];
//    CB[@"name"] = @"Bigger Balls";
//    //    CB[@"description"] = @"Get your season pass signed (permanent marker) by Tom Day.";
//    CB[@"type"] = @0;
//    CB[@"group"] = @"West Side KT22";
//    [CB saveInBackground];
//
//    Achievement *BN = [Achievement new];
//    BN[@"name"] = @"Cartwheel";
//    //    BN[@"description"] = @"Go monoskiing all day long.";
//    BN[@"type"] = @0;
//    BN[@"group"] = @"West Side KT22";
//    [BN saveInBackground];
//
//    Achievement *XT = [Achievement new];
//    XT[@"name"] = @"The Portal";
//    //    XT[@"description"] = @"Obtain a totally ridiculous season pass picture. 3 or more friends must say, \"How did they let you do that?\" or equivalent.";
//    XT[@"type"] = @0;
//    XT[@"group"] = @"West Side KT22";
//    [XT saveInBackground];
//
//    NSLog(@"Saved achievements");


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
    return 55;
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
    return 45;
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
    NSDictionary *pathDictionary = @{@"Parent Index": [NSNumber numberWithInteger:parentIndex],
                                     @"Child Index": [NSNumber numberWithInteger:childIndex]};
    [self performSegueWithIdentifier:@"AchievementDetailSegue" sender:pathDictionary];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[NSDictionary class]])
    {
        NSInteger parent = [sender[@"Parent Index"] integerValue];
        NSInteger child = [sender[@"Child Index"]integerValue];

        AchievementDetailViewController *detailVC = segue.destinationViewController;
        detailVC.type = parent;
        detailVC.group = [self.dataDictionary objectForKey:self.typesArray[parent]][child];

    }
}




















@end
