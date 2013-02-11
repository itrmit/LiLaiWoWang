//
//  GTAppDelegate.h
//  礼来我往
//
//  Created by Guangtao Li on 2/11/13.
//  Copyright (c) 2013 Grant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTDoorViewController.h"
@class GTViewController;

@interface GTAppDelegate : UIResponder <UIApplicationDelegate, GTDoorViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) GTViewController *viewController;

@end
