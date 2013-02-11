//
//  GTDoorViewController.h
//  礼来我往
//
//  Created by Guangtao Li on 2/24/13.
//  Copyright (c) 2013 Grant. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GTDoorViewControllerDelegate <NSObject>

- (void)allowComein;

@end

@interface GTDoorViewController : UIViewController
@property (nonatomic, weak) id<GTDoorViewControllerDelegate> delegate;

@property (nonatomic, weak) IBOutlet UIButton *liLaiWoWangBtn;
- (IBAction)liLaiWoWangBtnClicked:(id)sender;
@end
