//
//  GTViewController.m
//  礼来我往
//
//  Created by Guangtao Li on 2/11/13.
//  Copyright (c) 2013 Grant. All rights reserved.
//

#import "GTViewController.h"
#import "Gift.h"
#import "GTAddViewController.h"
#import "GTListViewController.h"
#import "GTZongLanViewController.h"
#import "GTTongJiViewController.h"
@interface GTViewController ()
{
    NSArray *liLaiArray;
    NSArray *woWangArray;
    UIImage *emptyImage;
}

@end

@implementation GTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.title = @"礼来我往";
    emptyImage = [UIImage imageNamed:@"imageReplacement-Small"];
}

- (void)dealloc
{
    XLOG(@"dealloc: %@",[self class]);
    liLaiArray = nil;
    woWangArray = nil;
    emptyImage = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


- (IBAction)liLai:(id)sender
{
    [self moveToListViewByType:LilaiType];
}
- (IBAction)woWang:(id)sender
{
    [self moveToListViewByType:WoWangType];
}
- (IBAction)zongLan:(id)sender
{
    [self moveToListViewByType:AllType];
}
- (IBAction)tongJi:(id)sender
{
    GTTongJiViewController *addVC = nil;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {
        addVC = [[GTTongJiViewController alloc] initWithNibName:@"GTTongJiViewController_iPhone" bundle:nil];
    }else
    {
        addVC = [[GTTongJiViewController alloc] initWithNibName:@"GTTongJiViewController_iPad" bundle:nil];
    }
    [self.navigationController pushViewController:addVC animated:YES];
    addVC = nil;
}
- (IBAction)addLiLai:(id)sender
{
    GTAddViewController *addVC = nil;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {
        addVC = [[GTAddViewController alloc] initWithNibName:@"GTAddViewController_iPhone" bundle:nil];
    }else
    {
        addVC = [[GTAddViewController alloc] initWithNibName:@"GTAddViewController_iPad" bundle:nil];
    }
    [addVC setCreationType:LilaiType];
    [self.navigationController pushViewController:addVC animated:YES];
    addVC = nil;
}
- (IBAction)addWoWang:(id)sender
{
    GTAddViewController *addVC = nil;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {
        addVC = [[GTAddViewController alloc] initWithNibName:@"GTAddViewController_iPhone" bundle:nil];
    }else
    {
        addVC = [[GTAddViewController alloc] initWithNibName:@"GTAddViewController_iPad" bundle:nil];
    }
    [addVC setCreationType:WoWangType];
    [self.navigationController pushViewController:addVC animated:YES];
    addVC = nil;
}

-(void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText
{
    NSString *liLaiStr = nil;
    NSString *woWangStr= nil;
    if ([self isPureFloat:searchText])
    {
        liLaiStr = [NSString stringWithFormat:@"(price == %f OR name LIKE '%@*' OR beizhu LIKE '%@*') AND liLaiWoWangType == %i",searchText.floatValue,searchText,searchText,LilaiType];
        woWangStr = [NSString stringWithFormat:@"(price == %f OR name LIKE '%@*' OR beizhu LIKE '%@*') AND liLaiWoWangType == %i",-searchText.floatValue,searchText,searchText,WoWangType];
    }else
    {
        liLaiStr = [NSString stringWithFormat:@"(name LIKE '%@*' OR beizhu LIKE '%@*') AND liLaiWoWangType == %i",searchText,searchText,LilaiType];
        woWangStr = [NSString stringWithFormat:@"(name LIKE '%@*' OR beizhu LIKE '%@*') AND liLaiWoWangType == %i",searchText,searchText,WoWangType];
    }
    
    liLaiArray = [Gift MR_findAllWithPredicate:[NSPredicate predicateWithFormat:liLaiStr]];
    woWangArray = [Gift MR_findAllWithPredicate:[NSPredicate predicateWithFormat:woWangStr]];
}

#pragma mark -
#pragma mark UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

{
    switch (section) {
        case 0:
            return liLaiArray.count;
            break;
        case 1:
            return woWangArray.count;
            break;
        default:
            return 0;
            break;
    }
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *cellIndentifier = @"cellReuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIndentifier];
    }
    __weak Gift *gift = nil;
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy/MM/dd"];
    switch (indexPath.section)
    {
        case 0:
            gift = [liLaiArray objectAtIndex:indexPath.row];
            [cell.textLabel setText:[NSString stringWithFormat:@"%@ %@ %.1f元",[format stringFromDate:gift.date],gift.name,gift.price.floatValue]];
            break;
        case 1:
            gift = [woWangArray objectAtIndex:indexPath.row];
            [cell.textLabel setText:[NSString stringWithFormat:@"%@ %@ %.1f元",[format stringFromDate:gift.date],gift.name,-gift.price.floatValue]];
            break;
        default:
            break;
            
    }
    if (gift.photo)
    {
        [cell.imageView setImage:gift.photo];
    }else
    {
        [cell.imageView setImage:emptyImage];
    }
    cell.detailTextLabel.text = gift.beizhu;

    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;              // Default is 1 if not implemented
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;    // fixed font style. use custom view (UILabel) if you want something different
{
    switch (section)
    {
        case 0:
            return @"礼来记录";
            break;
        case 1:
            return @"我往记录";
            break;
        default:
            return @"";
            break;
    }
}

- (BOOL)isPureFloat:(NSString*)string
{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    
    float val;
    
    return[scan scanFloat:&val] && [scan isAtEnd];
}

- (void)moveToListViewByType:(LiLaiWoWangType)listType
{
    if (listType == AllType)
    {
        GTZongLanViewController *listVC = nil;
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
        {
            listVC = [[GTZongLanViewController alloc] initWithNibName:@"GTZongLanViewController_iPhone" bundle:nil];
        }else
        {
            listVC = [[GTZongLanViewController alloc] initWithNibName:@"GTZongLanViewController_iPad" bundle:nil];
        }
        [self.navigationController pushViewController:listVC animated:YES];
        listVC = nil;
    }
    else
    {
        GTListViewController *listVC = nil;
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
        {
            listVC = [[GTListViewController alloc] initWithNibName:@"GTListViewController_iPhone" bundle:nil];
        }else
        {
            listVC = [[GTListViewController alloc] initWithNibName:@"GTListViewController_iPad" bundle:nil];
        }
        [listVC setLiLaiWoWangType:listType];
        [self.navigationController pushViewController:listVC animated:YES];
        listVC = nil;

    }

}

@end
