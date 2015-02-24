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

@property (strong, nonatomic) IBOutlet UIBarButtonItem *addButton; // set to strong so it will stay when we set it to nil and not auto-released too early
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
    self.tableView.backgroundColor = [UIColor colorWithWhite:( 30/255.0) alpha:1.0];


    if (!self.modifiersDictionary)
    {
        self.title = @"Add Scores";
    }
    else
    {
        self.title = @"Add Modifiers";
    }
    
    self.typesArray = [[NSArray alloc] initWithObjects:@"Line Worths", @"ECPs", @"Trick Bonuses", @"Penalties", nil];
    self.dataDictionary = @{ self.typesArray[0] : @[@"Cornice II Bowl", @"Eagle's Nest", @"Enchanted Forest", @"Fingers", @"Light Towers/Headwall", @"Mainline Pocket", @"Olympic Lady", @"The Nose", @"The Palisades", @"West Side KT22"],
                             self.typesArray[1] : @[@"Daily ECPs", @"Yearly ECPs", @"Unlimited ECPs"],
                             self.typesArray[2] : @[@"Grabs", @"Inverted", @"Spins", @"Tricks"],
                             self.typesArray[3] : @[@"Clothing", @"Falling", @"Other"]
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //TODO: remove this once changed to collapse rows after pressing add button
    [self.tableView collapseAllRows];
}

//-----------------------------------    SUB Table View Data Source    ----------------------------------------------------
//                             ----------    Parent Cells    ------------
#pragma mark - Sub Table View Data Source - Parent
// @required
- (NSInteger)numberOfParentCells
{
    if (self.modifiersDictionary) // If adding modifiers to score: remove LineWorths so to only add other kind of points
    {
        return self.typesArray.count - 1;
    }
    else
    {
        return self.typesArray.count;
    }
}

- (NSInteger)heightForParentRows
{
    return 55;
}

// @optional
- (NSString *)titleLabelForParentCellAtIndex:(NSInteger)parentIndex
{
    if (self.modifiersDictionary)
    {
        return self.typesArray[parentIndex + 1];
    }
    else
    {
        return self.typesArray[parentIndex];

    }
}

- (NSString *)subtitleLabelForParentCellAtIndex:(NSInteger)parentIndex
{
    return @"";
}

#pragma mark - Sub Table View Data Source - Child
// @required
- (NSInteger)numberOfChildCellsUnderParentIndex:(NSInteger)parentIndex
{
    if (self.modifiersDictionary)
    {
        return [self.dataDictionary[self.typesArray[parentIndex + 1]] count];
    }
    else
    {
        return [self.dataDictionary[self.typesArray[parentIndex]] count];
    }
}

//                             ----------    Child Cells    ------------
- (NSInteger)heightForChildRows
{
    return 45;
}

// @optional
- (NSString *)titleLabelForCellAtChildIndex:(NSInteger)childIndex withinParentCellIndex:(NSInteger)parentIndex
{
    if (self.modifiersDictionary)
    {
        return [self.dataDictionary[self.typesArray[parentIndex + 1]] objectAtIndex:childIndex];
    }
    else
    {
        return [self.dataDictionary[self.typesArray[parentIndex]] objectAtIndex:childIndex];
    }
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

//--------------------------------------    Prepare For Segue    ---------------------------------------------
#pragma mark - Prepare For Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[NSDictionary class]])
    {

        NSInteger parent = [sender[@"Parent Index"] integerValue];
        NSInteger child = [sender[@"Child Index"] integerValue];

        AchievementDetailViewController *detailVC = segue.destinationViewController;
        if (self.modifiersDictionary)
        {
            detailVC.type = parent + 1;
            detailVC.group = [self.dataDictionary objectForKey:self.typesArray[parent + 1]][child];
            detailVC.title = [self.dataDictionary objectForKey:self.typesArray[parent + 1]][child];
            detailVC.modifiersDictionary = self.modifiersDictionary;
            
        }
        else
        {
            detailVC.type = parent;
            detailVC.group = [self.dataDictionary objectForKey:self.typesArray[parent]][child];
            detailVC.title = [self.dataDictionary objectForKey:self.typesArray[parent]][child];
        }
    }
}



















@end
