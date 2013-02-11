//
//  GTViewController.h
//  礼来我往
//
//  Created by Guangtao Li on 2/11/13.
//  Copyright (c) 2013 Grant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTViewController : UIViewController<UITableViewDataSource,UISearchDisplayDelegate>
- (IBAction)liLai:(id)sender;
- (IBAction)woWang:(id)sender;
- (IBAction)zongLan:(id)sender;
- (IBAction)tongJi:(id)sender;
- (IBAction)addLiLai:(id)sender;
- (IBAction)addWoWang:(id)sender;
@end
