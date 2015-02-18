//
//  AchievementViewController.h
//  GNAR
//
//  Created by Chris Giersch on 2/9/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AchievementViewControllerDelegate <NSObject>

- (void)didFinishAddingModifiers;

@end

@interface AchievementViewController : UIViewController

@property (weak, nonatomic) id <AchievementViewControllerDelegate> delegate;
@property NSMutableDictionary *modifiersDictionary;

@end
