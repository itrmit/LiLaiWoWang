//
//  GTTongJiResultViewController.m
//  礼来我往
//
//  Created by Guangtao Li on 2/17/13.
//  Copyright (c) 2013 Grant. All rights reserved.
//

#import "GTTongJiResultViewController.h"
#import "GTTongJiDetailViewController.h"
#import "Gift.h"


@interface GTTongJiResultViewController ()

@end

@implementation GTTongJiResultViewController

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
    self.resultArray = nil;
    self.startDate = nil;
    self.endDate = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"统计结果";
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
    NSArray *rowsInSection = [[self.resultArray objectAtIndex:section] objectForKey:kTongJiSectionRows];
    return rowsInSection.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *rowsInSection = [[self.resultArray objectAtIndex:indexPath.section] objectForKey:kTongJiSectionRows];
    id rowObject = [rowsInSection objectAtIndex:indexPath.row];
    static NSString *cellIdentifier = @"TongJiResultTableCellIdentifier";
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    [cell.textLabel setText:[rowObject objectForKey:@"name"]];
    [cell.detailTextLabel setText:[NSString stringWithFormat:@"%.2f 元",[[rowObject objectForKey:@"total"] floatValue]]];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;              // Default is 1 if not implemented
{
    return self.resultArray.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;    // fixed font style. use custom view (UILabel) if you want something different
{
    return [[self.resultArray objectAtIndex:section] objectForKey:kTongJiSectionTitle];
}

#pragma mark -
#pragma mark UITableViewDelegate Methods


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GTTongJiDetailViewController *detailVC = nil;
    NSArray *rowsInSection = [[self.resultArray objectAtIndex:indexPath.section] objectForKey:kTongJiSectionRows];
    NSString *name = [[rowsInSection objectAtIndex:indexPath.row] objectForKey:@"name"];
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {
        detailVC = [[GTTongJiDetailViewController alloc] initWithNibName:@"GTTongJiDetailViewController_iPhone" bundle:nil];
    }else
    {
        detailVC = [[GTTongJiDetailViewController alloc] initWithNibName:@"GTTongJiDetailViewController_iPad" bundle:nil];
    }
    NSPredicate *liLaiPredicte = nil;
    NSPredicate *woWangPredicte = nil;
    if (indexPath.section == 0)
    {
        liLaiPredicte = [NSPredicate predicateWithFormat:@"(date >= %@) AND (date <= %@) AND liLaiWoWangType == %i",self.startDate, self.endDate,LilaiType];
        woWangPredicte = [NSPredicate predicateWithFormat:@"(date >= %@) AND (date <= %@) AND liLaiWoWangType == %i",self.startDate, self.endDate,WoWangType];
    }else
    {

        liLaiPredicte = [NSPredicate predicateWithFormat:@"(name == %@) AND (date >= %@) AND (date <= %@) AND liLaiWoWangType == %i", name,self.startDate, self.endDate,LilaiType];
        woWangPredicte = [NSPredicate predicateWithFormat:@"(name == %@) AND (date >= %@) AND (date <= %@) AND liLaiWoWangType == %i", name,self.startDate, self.endDate,WoWangType];
    }
    
    detailVC.liLaiArray = [Gift MR_findAllSortedBy:@"date" ascending:NO withPredicate:liLaiPredicte];
    detailVC.woWangArray = [Gift MR_findAllSortedBy:@"date" ascending:NO withPredicate:woWangPredicte];
    
    NSMutableArray *tongJiArray = [[NSMutableArray alloc] initWithCapacity:1];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy年MM月dd日"];
    NSDictionary *tongJiRowDict =nil;
    tongJiRowDict = [NSDictionary dictionaryWithObjectsAndKeys:
                     @"开始时间",kGTDetailCellTitle,
                     [format stringFromDate:self.startDate],kGTDetailCellContent, nil];
    [tongJiArray addObject:tongJiRowDict];
    tongJiRowDict = [NSDictionary dictionaryWithObjectsAndKeys:
                     @"结束时间",kGTDetailCellTitle,
                     [format stringFromDate:self.endDate],kGTDetailCellContent, nil];
    [tongJiArray addObject:tongJiRowDict];
    float comeTotal = [[Gift MR_aggregateOperation:@"sum:" onAttribute:@"price" withPredicate:liLaiPredicte] floatValue];
    float giveTotal = [[Gift MR_aggregateOperation:@"sum:" onAttribute:@"price" withPredicate:woWangPredicte] floatValue];
    
    tongJiRowDict = [NSDictionary dictionaryWithObjectsAndKeys:
                     [NSString stringWithFormat:@"收到合计"],kGTDetailCellTitle,
                     [NSString stringWithFormat:@"%.1f元",comeTotal],kGTDetailCellContent, nil];
    [tongJiArray addObject:tongJiRowDict];
    tongJiRowDict = [NSDictionary dictionaryWithObjectsAndKeys:
                     [NSString stringWithFormat:@"赠予合计"],kGTDetailCellTitle,
                     [NSString stringWithFormat:@"%.1f元",-giveTotal],kGTDetailCellContent, nil];
    [tongJiArray addObject:tongJiRowDict];
    tongJiRowDict = [NSDictionary dictionaryWithObjectsAndKeys:
                     [NSString stringWithFormat:@"来往结果"],kGTDetailCellTitle,
                     [NSString stringWithFormat:@"%.1f元",comeTotal+giveTotal],kGTDetailCellContent, nil];
    [tongJiArray addObject:tongJiRowDict];
    detailVC.tongJiArray = tongJiArray;
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
