//
//  SubTableView.m
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
#import "SubTableView.h"
#import "SubTableViewCell.h"

@implementation SubTableView

@synthesize insideTableView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [[self contentView] setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        fgColor = [UIColor darkTextColor];
        bgColor = [UIColor clearColor];
        font = [UIFont systemFontOfSize:16.0];
        [self configureInsideTableView];
    }
    return self;
}



#pragma mark - Configuration

- (void)configureInsideTableView {
    
    self.insideTableView = [[UITableView alloc] init];
    insideTableView.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
    
    insideTableView.dataSource = self;
    insideTableView.delegate = self;
    
    [self.insideTableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    insideTableView.scrollEnabled = NO;
    
    insideTableView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.insideTableView];
}



#pragma mark - Getters/Setters

/***
 * Delegate
 */
- (id)getDelegate {
    return delegate;
}
// TODO combine set delegate and parentIndex into one method for better safety
- (void)setDelegate:(id<SubTableViewCellDelegate>)deleg {
    
    delegate = deleg;
    NSInteger numberOfChild = [delegate numberOfChildrenUnderParentIndex:self.parentIndex];
    NSInteger rowHeight = [delegate heightForChildRows];
    insideTableView.frame = CGRectMake(0, 0, self.contentView.frame.size.width, rowHeight * numberOfChild);
}

/***
 * Foreground
 */
- (UIColor *)getSubTableForegroundColor {
    return fgColor;
}
- (void)setSubTableForegroundColor:(UIColor *)p_fgColor {
    fgColor = p_fgColor;
}

/***
 * Background
 */
- (UIColor *)getSubTableBackgroundColor {
    return bgColor;
}
- (void)setSubTableBackgroundColor:(UIColor *)p_bgColor {
    bgColor = p_bgColor;
}

/***
 * Font
 */
- (UIFont *)getSubTableFont {
    return font;
}
- (void)setSubTableFont:(UIFont *) p_font  {
    font = p_font;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (void)reload {
    [self.insideTableView reloadData];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger count = [self.delegate numberOfChildrenUnderParentIndex:self.parentIndex];
    if (count > 0)
        return count;
    else
        return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CELL_IDENTIFIER = @"SubTableViewCell_Reuse_Id";
    
    SubTableViewCell *cell = (SubTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    if (cell == nil) {
        cell = [[SubTableViewCell alloc] initWithReuseIdentifier:CELL_IDENTIFIER];
    }

    NSInteger count = [self.delegate numberOfChildrenUnderParentIndex:self.parentIndex];
    if (count > 0) {
        
        NSInteger row = [indexPath row];
        cell.titleLabel.text = [self.delegate titleLabelForChildIndex:row underParentIndex:self.parentIndex];
        cell.subtitleLabel.text = [self.delegate subtitleLabelForChildIndex:row underParentIndex:self.parentIndex];
        
        [cell setCellBackgroundColor:[UIColor colorWithWhite:0.25 alpha:1.0]];
        [cell setCellForegroundColor:fgColor];
        [cell.titleLabel setFont:font];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else {
        
        cell.titleLabel.text = @"";
        cell.subtitleLabel.text = @"";
        
        [cell setCellBackgroundColor:[UIColor colorWithWhite:0.15 alpha:1.0]];
        [cell setCellForegroundColor:fgColor];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}



#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return [delegate heightForChildRows];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // must be implemented by concrete subclasses
    
    [self.delegate didSelectRowAtChildIndex:indexPath.row underParentIndex:self.parentIndex];
}

@end
