//
//  SubTableView.h
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

@protocol SubTableViewCellDelegate <NSObject>

@required
- (NSInteger)numberOfChildrenUnderParentIndex:(NSInteger)parentIndex;
- (NSInteger)heightForChildRows;

@optional
- (void)didSelectRowAtChildIndex:(NSInteger)childIndex
                underParentIndex:(NSInteger)parentIndex;
- (NSString *)titleLabelForChildIndex:(NSInteger)childIndex underParentIndex:(NSInteger)parentIndex;
- (NSString *)subtitleLabelForChildIndex:(NSInteger)childIndex underParentIndex:(NSInteger)parentIndex;

@end



@interface SubTableView : UITableViewCell <UITableViewDataSource,UITableViewDelegate> {
    UITableView *insideTableView;
    __weak id delegate;
    UIColor *bgColor;
    UIColor *fgColor;
    UIFont *font;
}

@property (nonatomic,strong) UITableView *insideTableView;
@property (nonatomic,weak,getter = getDelegate, setter = setDelegate:) id<SubTableViewCellDelegate> delegate;
@property (nonatomic) NSInteger parentIndex;

@property (nonatomic, strong, getter = getSubTableForegroundColor, setter = setSubTableForegroundColor:) UIColor *fgColor;
@property (nonatomic, strong, getter = getSubTableBackgroundColor, setter = setSubTableBackgroundColor:) UIColor *bgColor;
@property (nonatomic, strong, getter = getSubTableFont, setter = setSubTableFont:) UIFont *font;

- (void)reload;

@end
