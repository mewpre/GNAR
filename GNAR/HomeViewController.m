//
//  HomeViewController.m
//  GNAR
//
//  Created by Chris Giersch on 2/9/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import "HomeViewController.h"
#import "LoginViewController.h"
#import <Parse/Parse.h>


@interface HomeViewController ()<LoginViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.usernameLabel.text = [NSString stringWithFormat:@"Username: %@", [PFUser currentUser].username];
}


- (IBAction)onLogoutButtonPressed:(id)sender
{
    [PFUser logOut];
    NSLog(@"Logged Out");

    LoginViewController *vcObj = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    vcObj.delegate = self;
    UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:vcObj];

    navCon.modalPresentationStyle = UIModalPresentationOverCurrentContext;

    [self presentViewController:navCon animated:NO completion:nil];
}

- (void)didDismissPresentedViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"logged in as: %@", [PFUser currentUser].username);
    self.tabBarController.selectedIndex = 1;
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
