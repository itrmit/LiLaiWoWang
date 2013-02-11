//
//  GTListViewController.h
//  礼来我往
//
//  Created by Guangtao Li on 2/16/13.
//  Copyright (c) 2013 Grant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (nonatomic) LiLaiWoWangType liLaiWoWangType;

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@end
