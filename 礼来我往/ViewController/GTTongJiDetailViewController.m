//
//  GTTongJiDetailViewController.m
//  礼来我往
//
//  Created by Guangtao Li on 2/17/13.
//  Copyright (c) 2013 Grant. All rights reserved.
//

#import "GTTongJiDetailViewController.h"
#import "Gift.h"

@interface GTTongJiDetailViewController ()
@end

@implementation GTTongJiDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    XLOG(@"dealloc: %@",[self class]);
    self.tongJiArray = nil;
    self.liLaiArray = nil;
    self.woWangArray = nil;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"统计明细";
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    NSInteger num = 0;
    switch (section)
    {
        case 0:
            num = self.tongJiArray.count;
            break;
        case 1:
            num = self.liLaiArray.count;
            break;
        case 2:
            num = self.woWangArray.count;
            break;
            
        default:
            break;
    }
    return num;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *detailCellIdentifier = @"TongJiDetailTableCellIdentifier";
    static NSString *tongJiCellIdentifier = @"TongJiTableCellIdentifier";
    
    UITableViewCell *cell = nil;

    __weak Gift *gift = nil;
    __weak NSString *entityStr = nil;
    __weak NSDictionary *tongJiObject = nil;
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy/MM/dd"];
    switch (indexPath.section)
    {
            
        case 0:
            cell = [tableView dequeueReusableCellWithIdentifier:tongJiCellIdentifier];
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:tongJiCellIdentifier];
            }
            tongJiObject = [self.tongJiArray objectAtIndex:indexPath.row];
            entityStr = [NSString stringWithFormat:@"%@",
                         [tongJiObject objectForKey:kGTDetailCellTitle]];
            [cell.imageView setImage:nil];
            [cell.detailTextLabel setText:[tongJiObject objectForKey:kGTDetailCellContent]];
            break;
        case 1:
            cell = [tableView dequeueReusableCellWithIdentifier:detailCellIdentifier];
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:detailCellIdentifier];
            }
            gift = [self.liLaiArray objectAtIndex:indexPath.row];
            entityStr = [NSString stringWithFormat:@"%@ %@ %.1f元",[format stringFromDate:gift.date],gift.name,[gift.price floatValue]];
            cell.detailTextLabel.text = gift.beizhu;
            [cell.imageView setImage:[[GTHelper sharedGTHelper] getImageFromGift:gift]];
            break;
        case 2:
            cell = [tableView dequeueReusableCellWithIdentifier:detailCellIdentifier];
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:detailCellIdentifier];
            }
            gift = [self.woWangArray objectAtIndex:indexPath.row];
            entityStr = [NSString stringWithFormat:@"%@ %@ %.1f元",[format stringFromDate:gift.date],gift.name,-[gift.price floatValue]];
            cell.detailTextLabel.text = gift.beizhu;
            [cell.imageView setImage:[[GTHelper sharedGTHelper] getImageFromGift:gift]];
            break;
        default:
            break;
            
    }

    [cell.textLabel setText:entityStr];
    return cell;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;              // Default is 1 if not implemented
{
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;    // fixed font style. use custom view (UILabel) if you want something different
{
    switch (section)
    {
        case 0:
            return @"统计";
            break;
        case 1:
            return @"收礼明细";
            break;
        case 2:
            return @"送礼明细";
            break;
            
        default:
            break;
    }
    return nil;
}
@end
