//
//  DetailParentTableView.m
//  GNAR
//
//  Created by Chris Giersch on 2/15/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import "DetailParentTableView.h"
#import "ParentTableViewCell.h"

@interface DetailParentTableView ()
{
    ParentTableViewCell *previouslySelectedCell;
}

@end

@implementation DetailParentTableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *PARENT_IDENTIFIER = @"CellReuseId_Parent";
    static NSString *CHILD_CONTAINER_IDENTIFIER = @"CellReuseId_Container";

    NSInteger row = indexPath.row;
    NSUInteger parentIndex = [self parentIndexForRow:row];
    BOOL isParentCell = ![self isExpansionCell:row];

    if (isParentCell)
    {
        ParentTableViewCell *cell = (ParentTableViewCell *)[self dequeueReusableCellWithIdentifier:PARENT_IDENTIFIER];
        if (cell == nil)
        {
            cell = [[ParentTableViewCell alloc] initWithReuseIdentifier:PARENT_IDENTIFIER];
        }

        cell.titleLabel.text = [self.dataSourceDelegate titleLabelForParentCellAtIndex:parentIndex];
        [cell.titleLabel setFont:[UIFont boldSystemFontOfSize:19]];

        cell.subtitleLabel.text = [self.dataSourceDelegate subtitleLabelForParentCellAtIndex:parentIndex];
        [cell.subtitleLabel setFont:[UIFont systemFontOfSize:13]];

        [cell setCellForegroundColor:[UIColor whiteColor]];
        [cell setCellBackgroundColor:[UIColor colorWithWhite:( 30/255.0) alpha:1.0]];
        [cell setParentIndex:parentIndex];
        cell.tag = parentIndex;

        [self deselectCell:cell];
        if ([[self.expansionStates objectAtIndex:[cell parentIndex]] boolValue])
            [self selectCell:cell];

        return cell;
    }
    else
    {
        AchievementDetailTableView *cell = (AchievementDetailTableView *)[self dequeueReusableCellWithIdentifier:CHILD_CONTAINER_IDENTIFIER];
        if (cell == nil) {
            cell = [[AchievementDetailTableView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CHILD_CONTAINER_IDENTIFIER];
        }
        cell.insideTableView.dataSource = cell;
        cell.insideTableView.delegate = cell;
        [cell setSubTableForegroundColor:[UIColor whiteColor]];
        [cell setSubTableBackgroundColor:[UIColor colorWithWhite:( 30/255.0) alpha:1.0]];
        [cell setParentIndex:parentIndex];

        cell.achievement = [self.achievementsArray objectAtIndex:parentIndex][@"achievement"];
        cell.playersArray = [self.achievementsArray objectAtIndex:parentIndex][@"playersArray"];
        cell.modifiersDictionary = [self.achievementsArray objectAtIndex:parentIndex][@"modifiersDictionary"];
        cell.snowIndexString = [self.achievementsArray objectAtIndex:parentIndex][@"snowIndexString"];
        cell.saveKey = [self.achievementsArray objectAtIndex:parentIndex][@"saveKey"];

        cell.heightString = self.childHeightString;
        [cell setDelegate:self];
        cell.detailDelegate = self;
        [cell reload];

        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *selectedPCell = [tableView cellForRowAtIndexPath:indexPath];
    if ([selectedPCell isKindOfClass:[ParentTableViewCell class]])
    {

        ParentTableViewCell *pCell = (ParentTableViewCell *)selectedPCell;
        self.selectedRow = [pCell parentIndex];
        NSLog(@"Parent Index: %lu", (long)[pCell parentIndex]);
        [self.parentDelegate didGetIndex: [pCell parentIndex]];

        if ([[self.expansionStates objectAtIndex:[pCell parentIndex]] boolValue]) {
            // clicked an already expanded cell
            [self collapseForParentAtRow:indexPath.row];
            [self deselectCell:pCell];
            previouslySelectedCell = nil;
        }
        else {

            // clicked a collapsed cell
            [self collapseAllRows];
            [self expandForParentAtRow:[pCell parentIndex]];

            [self deselectCell:previouslySelectedCell];
            previouslySelectedCell = pCell;
            [self selectCell:previouslySelectedCell];
        }

        if ([self.tableViewDelegate respondsToSelector:@selector(tableView:didSelectParentCellAtIndex:)]) {
            [self.tableViewDelegate tableView:tableView didSelectParentCellAtIndex:[pCell parentIndex]];
        }
    }
}

//-----------------------------    Achievement Detail Table View Delegate Methods   ------------------------------
#pragma mark - Achievement Detail Table View Delegate Methods
- (void)didChangeSubTableViewHeight
{
    [self reloadData];
}

- (void)didPressAddButtonAtParentIndex:(NSInteger)parentIndex
{
    [self reloadData];
    [self collapseForParentAtRow:parentIndex];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
