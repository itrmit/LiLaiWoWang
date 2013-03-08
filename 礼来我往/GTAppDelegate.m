//
//  GTAppDelegate.m
//  礼来我往
//
//  Created by Guangtao Li on 2/11/13.
//  Copyright (c) 2013 Grant. All rights reserved.
//


#import "GTAppDelegate.h"

#import "GTViewController.h"

@interface GTAppDelegate ()
{
    UINavigationController *naviC;
}
@end


@implementation GTAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"MyDataStore.sqlite"];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.window.rootViewController = [[GTDoorViewController alloc] initWithNibName:@"GTDoorViewController_iPhone" bundle:nil];
    }
    else
    {
        self.window.rootViewController = [[GTDoorViewController alloc] initWithNibName:@"GTDoorViewController_iPad" bundle:nil];
    }
    [(GTDoorViewController *)self.window.rootViewController setDelegate:self];
    [self.window makeKeyAndVisible];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)allowComein
{
    if (naviC)
    {
        [self.window.rootViewController presentViewController:naviC animated:YES completion:^{
            self.window.rootViewController = naviC;
        }];
        return;
    }
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.viewController = [[GTViewController alloc] initWithNibName:@"GTViewController_iPhone" bundle:nil];
    } else {
        self.viewController = [[GTViewController alloc] initWithNibName:@"GTViewController_iPad" bundle:nil];
    }

    naviC = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    [naviC.navigationBar setBarStyle:UIBarStyleBlack];
    [naviC setModalTransitionStyle:(UIModalTransitionStyleFlipHorizontal)];
    [self.window.rootViewController presentViewController:naviC animated:YES completion:^{
        self.window.rootViewController = naviC;
    }];

}

@end
