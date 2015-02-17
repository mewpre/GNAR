//
//  DetailParentTableView.m
//  GNAR
//
//  Created by Chris Giersch on 2/15/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import "DetailParentTableView.h"
#import "ParentTableViewCell.h"

@implementation DetailParentTableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *PARENT_IDENTIFIER = @"CellReuseId_Parent";
    static NSString *CHILD_CONTAINER_IDENTIFIER = @"CellReuseId_Container";

    NSInteger row = indexPath.row;
    NSUInteger parentIndex = [self parentIndexForRow:row];
    BOOL isParentCell = ![self isExpansionCell:row];

    if (isParentCell) {

        ParentTableViewCell *cell = (ParentTableViewCell *)[self dequeueReusableCellWithIdentifier:PARENT_IDENTIFIER];
        if (cell == nil) {
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
        cell.modifiersArray = [self.achievementsArray objectAtIndex:parentIndex][@"modifiersArray"];
        cell.snowIndexString = [self.achievementsArray objectAtIndex:parentIndex][@"snowIndexString"];
        cell.saveKey = [self.achievementsArray objectAtIndex:parentIndex][@"saveKey"];

        cell.heightString = self.childHeightString;
        [cell setDelegate:self];
        [cell reload];

        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    UITableViewCell *selectedPCell = [tableView cellForRowAtIndexPath:indexPath];
    if ([selectedPCell isKindOfClass:[ParentTableViewCell class]])
    {
        ParentTableViewCell *pCell = (ParentTableViewCell *)selectedPCell;
        NSLog(@"Parent Index: %lu", [pCell parentIndex]);
        [self.parentDelegate didGetIndex: [pCell parentIndex]];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
