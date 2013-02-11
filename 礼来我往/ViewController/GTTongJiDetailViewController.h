//
//  GTTongJiDetailViewController.h
//  礼来我往
//
//  Created by Guangtao Li on 2/17/13.
//  Copyright (c) 2013 Grant. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kGTDetailCellTitle   @"kGTDetailCellTitle"
#define kGTDetailCellContent @"kGTDetailCellContent"
@interface GTTongJiDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) NSArray *tongJiArray;
@property (strong, nonatomic) NSArray *liLaiArray;
@property (strong, nonatomic) NSArray *woWangArray;
@end
