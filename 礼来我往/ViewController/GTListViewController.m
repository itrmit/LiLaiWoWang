//
//  GTListViewController.m
//  礼来我往
//
//  Created by Guangtao Li on 2/16/13.
//  Copyright (c) 2013 Grant. All rights reserved.
//

#import "GTListViewController.h"
#import "Gift.h"
#import "GTListDetailViewController.h"
#import "GTCellStyleOne.h"



@interface GTListViewController ()
@property (strong, nonatomic) NSArray *resultArray;
@property (strong, nonatomic) NSMutableSet *deleteSet;
@end

@implementation GTListViewController

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
    self.deleteSet = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    switch (self.liLaiWoWangType)
    {
        case LilaiType:
            self.title = @"礼来记录";
            break;
        case WoWangType:
            self.title = @"我往记录";
        default:
            break;
    }

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadLiLaiWoWangData];
}

- (void)loadLiLaiWoWangData
{
    self.resultArray = [Gift MR_findByAttribute:@"liLaiWoWangType" withValue:[NSNumber numberWithInt:self.liLaiWoWangType] andOrderBy:@"date" ascending:NO];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    UIBarButtonItem *editBtn = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:(UIBarButtonItemStyleBordered) target:self action:@selector(editBtnDidClicked:)];
    [editBtn setTintColor:[UIColor colorWithRed:71.0/255.0 green:159.0/255.0 blue:35.0/255 alpha:1.0]];
    [self.navigationItem setRightBarButtonItem:editBtn animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText
{
    if (searchText.length==0)
    {
        [self loadLiLaiWoWangData];
        return;
    }
    
    
    NSString *predicateStr = nil;
    if ([self isPureFloat:searchText])
    {
        predicateStr = [NSString stringWithFormat:@"(price = %f OR name LIKE '%@*' OR beizhu LIKE '%@*') AND liLaiWoWangType = %i",searchText.floatValue,searchText,searchText,self.liLaiWoWangType];
    }
    else
    {
        predicateStr = [NSString stringWithFormat:@"(name LIKE '%@*' OR beizhu LIKE '%@*') AND liLaiWoWangType == %i",searchText,searchText,self.liLaiWoWangType];
        
    }

    self.resultArray = [Gift MR_findAllWithPredicate:[NSPredicate predicateWithFormat:predicateStr]];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar;                    // called when cancel button pressed
{
    [self loadLiLaiWoWangData];
}


- (void)editBtnDidClicked:(id)sender
{
    if (self.tableView.editing == YES)
    {
        [self.navigationItem.rightBarButtonItem setTitle:@"编辑"];
        [self.navigationItem.rightBarButtonItem setTintColor:nil];
        
        NSMutableArray *tempResultArray = nil;
        NSMutableArray *indexArray = nil;
        for (Gift *deletingGift in self.deleteSet)
        {
            if (tempResultArray == nil)
            {
                tempResultArray = [NSMutableArray arrayWithArray:self.resultArray];
                indexArray = [NSMutableArray arrayWithCapacity:1];
            }
            
            [deletingGift MR_deleteEntity];
            [tempResultArray removeObject:deletingGift];
            NSUInteger index = [self.resultArray indexOfObject:deletingGift];
            [indexArray addObject:[NSIndexPath indexPathForRow:index inSection:0]];
        }
        self.deleteSet = nil;
        if (tempResultArray)
        {
            self.resultArray = tempResultArray;

            [[HUDHandler shareHandler] showWhileExecuting:@selector(MR_saveToPersistentStoreAndWait) onTarget:[NSManagedObjectContext MR_defaultContext] withObject:nil animated:YES];
            
            [self.tableView deleteRowsAtIndexPaths:indexArray withRowAnimation:(UITableViewRowAnimationFade)];
            tempResultArray = nil;
            indexArray = nil;
        }
        
        
    }else
    {
        [self.navigationItem.rightBarButtonItem setTitle:@"删除"];
        [self.navigationItem.rightBarButtonItem setTintColor:[UIColor redColor]];
        self.deleteSet = [[NSMutableSet alloc] initWithCapacity:1];
    }
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    
}

#pragma mark -
#pragma mark UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

{
    return self.resultArray.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *cellIndentifier = @"cellReuseIdentifier1";
    GTCellStyleOne *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"GTCellStyleOne" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    
    __weak Gift *gift = [self.resultArray objectAtIndex:indexPath.row];
    __weak NSString *priceStr = nil;
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy/MM/dd"];
    switch (self.liLaiWoWangType)
    {
        case LilaiType:
            priceStr = [NSString stringWithFormat:@"%.1f 元",[gift.price floatValue]];
            break;
        case WoWangType:
            priceStr = [NSString stringWithFormat:@"%.1f 元",-[gift.price floatValue]];
            break;
        default:
            break;
            
    }
    
    [cell.mainTextLabel setText:[NSString stringWithFormat:@"%@ %@",[format stringFromDate:gift.date],gift.name]];
    [cell.priceTextLabel setText:priceStr];
    
    cell.beizhulLabel.text = gift.beizhu;
    [cell.photoView setImage:[[GTHelper sharedGTHelper] getImageFromGift:gift]];

    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;              // Default is 1 if not implemented
{
    return 1;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        __weak Gift *gift = [self.resultArray objectAtIndex:indexPath.row];
        [gift MR_deleteEntity];
        
        NSMutableArray *tempResultArray = [NSMutableArray arrayWithArray:self.resultArray];
        [tempResultArray removeObjectAtIndex:indexPath.row];
        self.resultArray = tempResultArray;
//        [self loadLiLaiWoWangData];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationMiddle];
        [[HUDHandler shareHandler] showWhileExecuting:@selector(MR_saveToPersistentStoreAndWait) onTarget:[NSManagedObjectContext MR_defaultContext] withObject:nil animated:YES];
    }

}


#pragma mark -
#pragma mark UITableViewDelegate Methods


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 71.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Gift *chooesedGift = [self.resultArray objectAtIndex:indexPath.row];
    if (tableView.editing == YES)
    {

        if ([self.deleteSet containsObject:chooesedGift] == NO)
        {
            [self.deleteSet addObject:chooesedGift];
        }
        return;
    }
    GTListDetailViewController *detailVC = nil;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {
        detailVC = [[GTListDetailViewController alloc] initWithNibName:@"GTListDetailViewController_iPhone" bundle:nil];
    }else
    {
        detailVC = [[GTListDetailViewController alloc] initWithNibName:@"GTListDetailViewController_iPad" bundle:nil];
    }
    [detailVC setGift:chooesedGift];
    chooesedGift = nil;
    [self.navigationController pushViewController:detailVC animated:YES];
    detailVC = nil;
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Gift *chooesedGift = [self.resultArray objectAtIndex:indexPath.row];
    if (tableView.editing == YES)
    {
        if ([self.deleteSet containsObject:chooesedGift])
        {
            [self.deleteSet removeObject:chooesedGift];
        }
    }
}


- (BOOL)isPureFloat:(NSString*)string
{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    
    float val;
    
    return[scan scanFloat:&val] && [scan isAtEnd];
}

@end
