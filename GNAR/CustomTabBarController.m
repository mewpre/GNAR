//
//  CustomTabBarController.m
//  GNAR
//
//  Created by Yi-Chin Sun on 2/12/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import "CustomTabBarController.h"
#import "LoginViewController.h"
#import "User.h"
#import <Parse/Parse.h>

@interface CustomTabBarController () <LoginViewControllerDelegate>

@property LoginViewController *loginVC;

@end

@implementation CustomTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (![User currentUser])
    {
        self.loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        self.loginVC.delegate = self;
        UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:self.loginVC];
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Sign Up" style:UIBarButtonItemStylePlain target:self action: @selector(onSignUpButtonPressed)];
        self.loginVC.navigationItem.rightBarButtonItem = rightButton;
        [self presentViewController:navCon animated:NO completion:nil];
    }
    else
    {
        NSLog(@"Already logged in");
        [self setSelectedIndex:2];
        
    }
}

- (void) onSignUpButtonPressed
{
    [self.loginVC performSegueWithIdentifier:@"SignUpSegue" sender:self];
}

- (void)didDismissPresentedViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"logged in as: %@", [User currentUser].username);
    [self setSelectedIndex:2];

}

@end
