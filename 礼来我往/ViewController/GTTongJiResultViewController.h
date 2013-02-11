//
//  GTTongJiResultViewController.h
//  礼来我往
//
//  Created by Guangtao Li on 2/17/13.
//  Copyright (c) 2013 Grant. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kTongJiText     @"kTongJiText"
#define kTongJiDetail   @"kTongJiDetail"
#define kTongJiSectionTitle @"kTongJiSectionTitle"
#define kTongJiSectionRows  @"kTongJiSectionRows"


@interface GTTongJiResultViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) NSArray *resultArray;
@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *endDate;
@end
