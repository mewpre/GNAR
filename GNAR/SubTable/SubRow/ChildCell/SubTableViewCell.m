//
//  SubTableViewCell.m
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
#import "SubTableViewCell.h"

@implementation SubTableViewCell
@synthesize titleLabel;
@synthesize subtitleLabel;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [[self contentView] setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    
    if (!self)
        return self;
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.opaque = NO;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:titleLabel];
    
    self.subtitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    subtitleLabel.backgroundColor = [UIColor clearColor];
    subtitleLabel.opaque = NO;
    subtitleLabel.textColor = [UIColor blackColor];
    subtitleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:subtitleLabel];
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setupDisplay];
}

- (void)setupDisplay {
    
    [self.contentView setAutoresizesSubviews:YES];

    self.titleLabel.frame = CGRectMake(35, 10, 185, 20);
    self.subtitleLabel.frame = CGRectMake(35, 30, 185, 16);
    
    self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    self.subtitleLabel.font = [UIFont systemFontOfSize:12];
}

- (void)setCellForegroundColor:(UIColor *)foregroundColor {
    titleLabel.textColor = foregroundColor;
    subtitleLabel.textColor = [UIColor colorWithWhite:0.9 alpha:1.0];
}

- (void)setCellBackgroundColor:(UIColor *) backgroundColor {
    self.contentView.backgroundColor = backgroundColor;
}

@end
