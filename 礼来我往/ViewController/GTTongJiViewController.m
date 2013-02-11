//
//  GTTongJiViewController.m
//  礼来我往
//
//  Created by Guangtao Li on 2/16/13.
//  Copyright (c) 2013 Grant. All rights reserved.
//

#import "GTTongJiViewController.h"
#import "GTTongJiResultViewController.h"
#import "Gift.h"
typedef NS_ENUM(NSUInteger, TimeType)
{
    GTStartTime,
    GTEndTime
};
@interface GTTongJiViewController ()
{
    UIActionSheet *_pickerViewPopup;
	UIDatePicker *_pickerView;
	NSDate *_dt;
    UIButton *_currentBtn;

}
@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *endDate;
@end

@implementation GTTongJiViewController

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
    self.startDate = nil;
    self.endDate = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"来往统计";

    
//    PMCalendarController *pmCC = [[PMCalendarController alloc] init];
//    [pmCC setTimeType:GTEndTime];
//    pmCC.delegate = self;
//    pmCC.mondayFirstDayOfWeek = YES;
//    [pmCC setAllowsPeriodSelection:NO];
//    
//    [pmCC presentCalendarFromView:self.endTimeBtn
//         permittedArrowDirections:PMCalendarArrowDirectionAny
//                         animated:YES];
//    [self calendarController:pmCC didChangePeriod:pmCC.period];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.startDate = [NSDate dateWithTimeIntervalSince1970:0];
    self.endDate = [NSDate dateWithTimeIntervalSinceNow:0];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
	[df setDateFormat:@"yyyy年MM月dd日"];
    [self.endTimeBtn setTitle:[df stringFromDate:self.endDate] forState:UIControlStateNormal];
    df = nil;
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
- (IBAction)chooesStartTime:(UIButton *)sender;
{
    [self beginChooseDate:sender];
//    PMCalendarController *pmCC = [[PMCalendarController alloc] init];
//    [pmCC setTimeType:GTStartTime];
//    pmCC.delegate = self;
//    pmCC.mondayFirstDayOfWeek = YES;
//    [pmCC setAllowsPeriodSelection:NO];
//    
//    [pmCC presentCalendarFromView:sender
//         permittedArrowDirections:PMCalendarArrowDirectionAny
//                         animated:YES];
}
- (IBAction)chooesEndTime:(id)sender
{
    [self beginChooseDate:sender];
//    PMCalendarController *pmCC = [[PMCalendarController alloc] init];
//    [pmCC setTimeType:GTEndTime];
//    pmCC.delegate = self;
//    pmCC.mondayFirstDayOfWeek = YES;
//    [pmCC setAllowsPeriodSelection:NO];
//    
//    [pmCC presentCalendarFromView:sender
//         permittedArrowDirections:PMCalendarArrowDirectionAny
//                         animated:YES];
}

- (IBAction)tongJiBtnClicked:(id)sender
{
    GTTongJiResultViewController *resultVC = nil;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {
        resultVC = [[GTTongJiResultViewController alloc] initWithNibName:@"GTTongJiResultViewController_iPhone" bundle:nil];
    }else
    {
        resultVC = [[GTTongJiResultViewController alloc] initWithNibName:@"GTTongJiResultViewController_iPad" bundle:nil];
    }
    resultVC.resultArray = [self tongJi:resultVC];
    resultVC.startDate = self.startDate;
    resultVC.endDate = self.endDate;
    [self.navigationController pushViewController:resultVC animated:YES];
}

- (NSArray *)tongJi:(GTTongJiResultViewController *)resultVC
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(date >= %@) AND (date <= %@)", self.startDate, self.endDate];
    NSExpressionDescription* ex = [[NSExpressionDescription alloc] init];
    [ex setName:@"total"];
    [ex setExpression:[NSExpression expressionWithFormat:@"@sum.price"]];
    [ex setExpressionResultType:NSDecimalAttributeType];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[Gift MR_entityDescription]];
    [fetchRequest setPropertiesToFetch:[NSArray arrayWithObjects:@"name", ex, nil]];
    [fetchRequest setPropertiesToGroupBy:[NSArray arrayWithObject:@"name"]];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setResultType:NSDictionaryResultType];
    NSArray *personTotalArray = [Gift MR_executeFetchRequest:fetchRequest];
    
    

    float selfTotal = [[Gift MR_aggregateOperation:@"sum:" onAttribute:@"price" withPredicate:predicate] floatValue];
    
    NSMutableArray *zongShuArray = [[NSMutableArray alloc] initWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"我",@"name",[NSNumber numberWithFloat:selfTotal],@"total", nil], nil];

    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:1];
    NSDictionary *personTotalDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"按姓名统计",kTongJiSectionTitle,personTotalArray,kTongJiSectionRows, nil];
    NSDictionary *zongShuDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"总数",kTongJiSectionTitle,zongShuArray,kTongJiSectionRows, nil];
    
    [result addObject:zongShuDict];
    [result addObject:personTotalDict];
    
    return result;
}



- (void)beginChooseDate:(UIButton *)btn
{
    _currentBtn = btn;
	_pickerViewPopup = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
	
	_pickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 44.0, 0.0, 0.0)];
    [_pickerView setMinimumDate:self.startDate];
	_pickerView.datePickerMode = UIDatePickerModeDate;
	_pickerView.hidden = NO;
	_pickerView.date = [NSDate date];
	[_pickerView setAccessibilityLanguage:@"Chinese"];
	[_pickerView addTarget:self action:@selector(dateChanged) forControlEvents:UIControlEventValueChanged];
	
	UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 44.0)];
	pickerToolbar.barStyle = UIBarStyleBlackOpaque;
	[pickerToolbar sizeToFit];
	
	NSMutableArray *barItems = [[NSMutableArray alloc] init];
	
	UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
	[barItems addObject:flexSpace];
	
	UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed:)];
	[barItems addObject:doneBtn];
	
	UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonPressed:)];
	[barItems addObject:cancelBtn];
	
	[pickerToolbar setItems:barItems animated:YES];
	
	[_pickerViewPopup addSubview:pickerToolbar];
	[_pickerViewPopup addSubview:_pickerView];
    [_pickerViewPopup showInView:self.view];
    [_pickerViewPopup setBounds:CGRectMake(0.0, 0.0, 320.0, 464.0)];
}

#pragma mark -

- (void)doneButtonPressed:(id)sender
{
	self.dt = [_pickerView date];
    if (_currentBtn == self.startTimeBtn)
    {
        self.startDate = _dt;

        if ([self.startDate compare:self.endDate] == NSOrderedDescending)//date1 is later than date2
        {
            self.endDate = self.startDate;
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"yyyy年MM月dd日"];
            [self.endTimeBtn setTitle:[df stringFromDate:self.endDate] forState:UIControlStateNormal];
            df = nil;
        }
    }else
    {
        self.startDate = _dt;
    }
    [_pickerViewPopup dismissWithClickedButtonIndex:1 animated:YES];
	[_pickerView removeTarget:self action:@selector(dateChanged) forControlEvents:UIControlEventValueChanged];
    _pickerView = nil;
    _pickerViewPopup = nil;
}

- (void)cancelButtonPressed:(id)sender
{
	if (_currentBtn == self.startTimeBtn)
    {
        self.dt = self.startDate;
    }else
    {
        self.dt = self.endDate;
    }
	
    [_pickerViewPopup dismissWithClickedButtonIndex:1 animated:YES];
	[_pickerView removeTarget:self action:@selector(dateChanged) forControlEvents:UIControlEventValueChanged];
    _pickerView = nil;
    _pickerViewPopup = nil;
}

- (void)dateChanged
{
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	[df setDateFormat:@"yyyy年MM月dd日"];
    [_currentBtn setTitle:[df stringFromDate:[_pickerView date]] forState:UIControlStateNormal];
    df = nil;
}

- (void)setDt:(NSDate *)dt
{
	_dt = dt;
	
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	[df setDateFormat:@"yyyy年MM月dd日"];
    [_currentBtn setTitle:[df stringFromDate:_dt] forState:UIControlStateNormal];
    df = nil;
}
@end
