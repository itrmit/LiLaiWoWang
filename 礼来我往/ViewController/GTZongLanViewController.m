//
//  GTZongLanViewController.m
//  礼来我往
//
//  Created by Guangtao Li on 2/16/13.
//  Copyright (c) 2013 Grant. All rights reserved.
//

#import "GTZongLanViewController.h"
#import "GTListDetailViewController.h"
#import "Gift.h"
@interface GTZongLanViewController ()
{
    UIActionSheet *_pickerViewPopup;
	UIDatePicker *_pickerView;
    UIBarButtonItem *_pickerDoneBtn;
}
@property (strong, nonatomic) NSArray *liLaiArray;
@property (strong, nonatomic) NSArray *woWangArray;
@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *endDate;
@end

@implementation GTZongLanViewController

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
    self.liLaiArray = nil;
    self.woWangArray = nil;
    self.liLaiArray = nil;
    self.startDate = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"来往总览";

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadLiLaiWoWangZongLanData];
}

- (void)loadLiLaiWoWangZongLanData
{
    self.liLaiArray = [Gift MR_findByAttribute:@"liLaiWoWangType" withValue:[NSNumber numberWithInt:LilaiType] andOrderBy:@"date" ascending:NO];
    self.woWangArray = [Gift MR_findByAttribute:@"liLaiWoWangType" withValue:[NSNumber numberWithInt:WoWangType] andOrderBy:@"date" ascending:NO];
    [self.liLaitableView reloadData];
    [self.wowangtableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"搜索日期" style:UIBarButtonItemStyleBordered target:self action:@selector(rightBtnDidClicked:)];
    [rightBtn setTintColor:[UIColor colorWithRed:71.0/255.0 green:159.0/255.0 blue:35.0/255 alpha:1.0]];
    [self.navigationItem setRightBarButtonItem:rightBtn animated:YES];
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
        [self loadLiLaiWoWangZongLanData];
        return;
    }
    
    NSString *liLaiStr = nil;
    NSString *woWangStr = nil;
    if ([self isPureFloat:searchText])
    {
        liLaiStr = [NSString stringWithFormat:@"(price == %f OR name LIKE '%@*' OR beizhu LIKE '%@*') AND liLaiWoWangType == %i",searchText.floatValue,searchText,searchText,LilaiType];
        woWangStr = [NSString stringWithFormat:@"(price == %f OR name LIKE '%@*' OR beizhu LIKE '%@*') AND liLaiWoWangType == %i",-searchText.floatValue,searchText,searchText,WoWangType];
    }else
    {
        liLaiStr = [NSString stringWithFormat:@"(name LIKE '%@*' OR beizhu LIKE '%@*') AND liLaiWoWangType == %i",searchText,searchText,LilaiType];
        woWangStr = [NSString stringWithFormat:@"(name LIKE '%@*' OR beizhu LIKE '%@*') AND liLaiWoWangType == %i",searchText,searchText,WoWangType];
    }
    
    self.liLaiArray = [Gift MR_findAllWithPredicate:[NSPredicate predicateWithFormat:liLaiStr]];
    self.woWangArray = [Gift MR_findAllWithPredicate:[NSPredicate predicateWithFormat:woWangStr]];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar;                    // called when cancel button pressed
{
    [self loadLiLaiWoWangZongLanData];
}


#pragma mark -
#pragma mark UITableViewDelegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GTListDetailViewController *detailVC = nil;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {
        detailVC = [[GTListDetailViewController alloc] initWithNibName:@"GTListDetailViewController_iPhone" bundle:nil];
    }else
    {
        detailVC = [[GTListDetailViewController alloc] initWithNibName:@"GTListDetailViewController_iPad" bundle:nil];
    }
    if (indexPath.section == 0)
    {
        if (tableView == self.liLaitableView)
        {
            [detailVC setGift:[self.liLaiArray objectAtIndex:indexPath.row]];
        }
        else if (tableView == self.wowangtableView)
        {
            [detailVC setGift:[self.woWangArray objectAtIndex:indexPath.row]];
        }
        else
            [detailVC setGift:[self.liLaiArray objectAtIndex:indexPath.row]];
    }
    else if(indexPath.section == 1)
    {   [detailVC setGift:[self.woWangArray objectAtIndex:indexPath.row]];
        
    }
    [self.navigationController pushViewController:detailVC animated:YES];
    detailVC = nil;
}

#pragma mark -
#pragma mark UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

{
    switch (section)
    {
        case 0:
            if (tableView == self.liLaitableView)
            {
                return self.liLaiArray.count;
            }else if(tableView == self.wowangtableView)
            {
                return self.woWangArray.count;
            }else
                return self.liLaiArray.count;
            break;
        case 1:
            return self.woWangArray.count;
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
    static NSString *liLaicellIndentifier = @"liLaiCellIndentifier";
    static NSString *wowangCellIndentifier = @"wowangCellIndentifier";
    NSString *tableReuseId = nil;
    if (tableView == self.wowangtableView)
    {
        tableReuseId = wowangCellIndentifier;
    }else
        tableReuseId = liLaicellIndentifier;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableReuseId];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:tableReuseId];
    }
    __weak Gift *gift = nil;
    __weak NSString *entityStr = nil;
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy/MM/dd"];
    switch (indexPath.section)
    {
        case 0:
            if (tableView != self.wowangtableView)
            {
                gift = [self.liLaiArray objectAtIndex:indexPath.row];
                entityStr = [NSString stringWithFormat:@"%@ %@ %.1f元",[format stringFromDate:gift.date],gift.name,gift.price.floatValue];
                break;
            }
            else
                ;
            
        case 1:
            gift = [self.woWangArray objectAtIndex:indexPath.row];
            entityStr = [NSString stringWithFormat:@"%@ %@ %.1f元",[format stringFromDate:gift.date],gift.name,-gift.price.floatValue];
            break;
        default:
            break;
            
    }
    [cell.imageView setImage:[[GTHelper sharedGTHelper] getImageFromGift:gift]];
    cell.detailTextLabel.text = gift.beizhu;
    [cell.textLabel setText:entityStr];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;              // Default is 1 if not implemented
{
    if (tableView == self.liLaitableView)
    {
        return 1;
    }
    else if(tableView == self.wowangtableView)
    {
        return 1;
    }
    else
        return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;    // fixed font style. use custom view (UILabel) if you want something different
{
    switch (section)
    {
        case 0:
            if (tableView == self.liLaitableView)
            {
                return @"礼来记录";
            }else if(tableView == self.wowangtableView)
            {
                return @"我往记录";
            }else
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

- (void)rightBtnDidClicked:(id)sender
{
    UIButton *invisibleBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-20, -20, 40, 20)];
    [self.view addSubview:invisibleBtn];
    
//    PMCalendarController *pmCC = [[PMCalendarController alloc] init];
//    pmCC.delegate = self;
//    pmCC.mondayFirstDayOfWeek = YES;
//    [pmCC setAllowsPeriodSelection:NO];
//    
//    [pmCC presentCalendarFromView:invisibleBtn
//         permittedArrowDirections:PMCalendarArrowDirectionAny
//                         animated:YES];
    /*    [pmCC presentCalendarFromRect:[sender frame]
     inView:[sender superview]
     permittedArrowDirections:PMCalendarArrowDirectionAny
     animated:YES];*/
//    [self calendarController:pmCC didChangePeriod:pmCC.period];
    
    
    _pickerViewPopup = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    
    _pickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 44.0, 0.0, 0.0)];
    [_pickerView setMinimumDate:self.startDate];
    _pickerView.datePickerMode = UIDatePickerModeDate;
    _pickerView.hidden = NO;
    _pickerView.date = [NSDate date];
    [_pickerView setAccessibilityLanguage:@"Chinese"];
    
    UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 44.0)];
    pickerToolbar.barStyle = UIBarStyleBlackOpaque;
    [pickerToolbar sizeToFit];
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems addObject:flexSpace];
    
    _pickerDoneBtn = [[UIBarButtonItem alloc] initWithTitle:@"选择开始日期" style:(UIBarButtonItemStyleBordered) target:self action:@selector(doneButtonPressed:)];
    [barItems addObject:_pickerDoneBtn];
    [_pickerDoneBtn setTintColor:[UIColor grayColor]];
    
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:(UIBarButtonItemStyleBordered) target:self action:@selector(cancelButtonPressed:)];
    [barItems addObject:cancelBtn];
    
    [pickerToolbar setItems:barItems animated:YES];
    
    [_pickerViewPopup addSubview:pickerToolbar];
    [_pickerViewPopup addSubview:_pickerView];
    [_pickerViewPopup showInView:self.view];
    [_pickerViewPopup setBounds:CGRectMake(0.0, 0.0, 320.0, 464.0)];
    
    
    if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"开始日期"])
    {
        [self.navigationItem.rightBarButtonItem setTitle:@"结束日期"];
    }else
    {
        [self.navigationItem.rightBarButtonItem setTitle:@"开始日期"];
    }
}

#pragma mark PMCalendarControllerDelegate methods

- (void)calendarController:(PMCalendarController *)calendarController didChangePeriod:(PMPeriod *)newPeriod
{
    if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"结束日期"])
    {
        self.endDate = [newPeriod.endDate dateByAddingDays:1];
        [self.navigationItem.rightBarButtonItem setTitle:@"搜索日期"];
        [calendarController dismissCalendarAnimated:YES];
        
        NSPredicate *liLaiPredicate = [NSPredicate predicateWithFormat:@"(date >= %@) AND (date <= %@) AND liLaiWoWangType == %i", self.startDate, self.endDate,LilaiType];
        NSPredicate *woWangPredicate = [NSPredicate predicateWithFormat:@"(date >= %@) AND (date <= %@) AND liLaiWoWangType == %i", self.startDate, self.endDate,WoWangType];
        
        self.liLaiArray = [Gift MR_findAllWithPredicate:liLaiPredicate];
        self.woWangArray = [Gift MR_findAllWithPredicate:woWangPredicate];
        [self.liLaitableView reloadData];
        [self.wowangtableView reloadData];
    }
    else
    {
        self.startDate = newPeriod.startDate;
        [self.navigationItem.rightBarButtonItem setTitle:@"结束日期"];
    }
    

}


#pragma mark -

- (void)doneButtonPressed:(id)sender
{
    if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"结束日期"])
    {
        self.endDate = _pickerView.date;
        [self.navigationItem.rightBarButtonItem setTitle:@"搜索日期"];
        
        NSPredicate *liLaiPredicate = [NSPredicate predicateWithFormat:@"(date >= %@) AND (date <= %@) AND liLaiWoWangType == %i", self.startDate, self.endDate,LilaiType];
        NSPredicate *woWangPredicate = [NSPredicate predicateWithFormat:@"(date >= %@) AND (date <= %@) AND liLaiWoWangType == %i", self.startDate, self.endDate,WoWangType];
        
        self.liLaiArray = [Gift MR_findAllWithPredicate:liLaiPredicate];
        self.woWangArray = [Gift MR_findAllWithPredicate:woWangPredicate];
        [self.liLaitableView reloadData];
        [self.wowangtableView reloadData];
        
        [_pickerViewPopup dismissWithClickedButtonIndex:1 animated:YES];
        _pickerView = nil;
        _pickerViewPopup = nil;
    }
    else
    {
        self.startDate = _pickerView.date;
        [self.navigationItem.rightBarButtonItem setTitle:@"结束日期"];
        [_pickerView setMinimumDate:self.startDate];
        [_pickerDoneBtn setTitle:@"选择结束日期"];
        [_pickerDoneBtn setTintColor:[UIColor blueColor]];
    }
}

- (void)cancelButtonPressed:(id)sender
{
	[self.navigationItem.rightBarButtonItem setTitle:@"搜索日期"];
    [_pickerViewPopup dismissWithClickedButtonIndex:1 animated:YES];
	[_pickerView removeTarget:self action:@selector(dateChanged) forControlEvents:UIControlEventValueChanged];
    _pickerView = nil;
    _pickerViewPopup = nil;
}

@end
