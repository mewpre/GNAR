//
//  CustomTabBarController.m
//  GNAR
//
//  Created by Yi-Chin Sun on 2/12/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import "CustomTabBarController.h"
#import "LoginViewController.h"
#import <Parse/Parse.h>

@interface CustomTabBarController () <LoginViewControllerDelegate>

@end

@implementation CustomTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (![PFUser currentUser])
    {
        LoginViewController *vcObj = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        vcObj.delegate = self;
        UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:vcObj];

        navCon.modalPresentationStyle = UIModalPresentationOverCurrentContext;

        [self presentViewController:navCon animated:NO completion:nil];
    }
    else
    {
        NSLog(@"Already logged in");
        [self setSelectedIndex:2];
        
    }
}

- (void)didDismissPresentedViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"logged in as: %@", [PFUser currentUser].username);
    [self setSelectedIndex:2];

}

@end
