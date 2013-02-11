//
//  GTZongLanViewController.h
//  礼来我往
//
//  Created by Guangtao Li on 2/16/13.
//  Copyright (c) 2013 Grant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTZongLanViewController : UIViewController<PMCalendarControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *liLaitableView;
@property (weak, nonatomic) IBOutlet UITableView *wowangtableView;
@end
