//
//  ParentTableView.h
//  SubTableExample
//
//  Created by Alex Koshy on 7/16/14.
//  Copyright (c) 2014 ajkoshy7. All rights reserved.
/*
 Permission is hereby granted, free of charge, to any person obtaining a
 copy of this software and associated documentation files (the "Software"),
 to deal in the Software without restriction, including without limitation
 the rights to use, copy, modify, merge, publish, distribute, sublicense,
 and/or sell copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
 OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */


#import <UIKit/UIKit.h>
#import "ExpandedContainer.h"
#import "ParentTableViewCell.h"

@class ViewController;

@protocol SubTableViewDelegate <NSObject>

@optional
- (void)tableView:(UITableView *)tableView didSelectCellAtChildIndex:(NSInteger)childIndex withInParentCellIndex:(NSInteger)parentIndex;
- (void)tableView:(UITableView *)tableView didDeselectCellAtChildIndex:(NSInteger)childIndex withInParentCellIndex:(NSInteger)parentIndex;
- (void)tableView:(UITableView *)tableView didSelectParentCellAtIndex:(NSInteger)parentIndex;


@end



@protocol SubTableViewDataSource <NSObject>

@required
- (NSInteger)numberOfParentCells;
- (NSInteger)numberOfChildCellsUnderParentIndex:(NSInteger)parentIndex;
- (NSInteger)heightForParentRows;
- (NSInteger)heightForChildRows;

@optional

// Parent DataSource
- (NSString *)titleLabelForParentCellAtIndex:(NSInteger)parentIndex;
- (NSString *)subtitleLabelForParentCellAtIndex:(NSInteger)parentIndex;

// Child DataSource
- (NSString *)titleLabelForCellAtChildIndex:(NSInteger)childIndex withinParentCellIndex:(NSInteger)parentIndex;
- (NSString *)subtitleLabelForCellAtChildIndex:(NSInteger)childIndex withinParentCellIndex:(NSInteger)parentIndex;

@end



@interface ParentTableView : UITableView
    <UITableViewDataSource, UITableViewDelegate, SubTableViewCellDelegate> {
    __weak id tableViewDelegate;
    __weak id dataSourceDelegate;
    NSMutableArray * expansionStates;
}

@property (nonatomic, weak) id<SubTableViewDelegate> tableViewDelegate;
@property (nonatomic, weak, getter = getDataSourceDelegate, setter = setDataSourceDelegate:) id<SubTableViewDataSource> dataSourceDelegate;
@property (nonatomic, strong) NSMutableArray * expansionStates;

@property (assign, nonatomic) NSInteger selectedRow;
- (void)collapseAllRows;
- (void)collapseForParentAtRow:(NSInteger)row;
- (void)expandForParentAtRow:(NSInteger)row;
- (NSUInteger)rowForParentIndex:(NSUInteger)parentIndex;
- (NSUInteger)parentIndexForRow:(NSUInteger)row;
- (BOOL)isExpansionCell:(NSUInteger)row;
- (void)selectCell:(ParentTableViewCell *)cell;
- (void)deselectCell:(ParentTableViewCell *)cell;



@end
