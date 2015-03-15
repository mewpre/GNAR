//
//  RulesViewController.m
//  GNAR
//
//  Created by Chris Giersch on 2/23/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import "RulesViewController.h"

@interface RulesViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation RulesViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.textView scrollRangeToVisible:NSMakeRange(0, 0)];
}
- (IBAction)onGotItButtonPressed:(UIButton *)sender
{
//    NSLog(@"Got It button pressed");
    [self dismissViewControllerAnimated:YES completion:nil];
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
