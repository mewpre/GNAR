//
//  AchievementDetailViewController.h
//  GNAR
//
//  Created by Chris Giersch on 2/9/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import <UIKit/UIKit.h>

//@protocol AchievementViewControllerDelegate <NSObject>
//
//- (void)didFinishAddingModifiers;
//
//@end

//@class Achievement;

@interface AchievementDetailViewController : UIViewController

//@property (weak, nonatomic) id <AchievementViewControllerDelegate> delegate;

@property NSInteger type;
@property NSString *group;
@property NSMutableDictionary *modifiersDictionary;

@end
