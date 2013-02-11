//
//  GTAddViewController.m
//  礼来我往
//
//  Created by Guangtao Li on 2/15/13.
//  Copyright (c) 2013 Grant. All rights reserved.
//

#import "GTAddViewController.h"
#import "Gift.h"

#define FIELDS_COUNT            3


@interface GTAddViewController ()
{
    UIActionSheet *_pickerViewPopup;
	UIPickerView *_pickerView;
}

@property (strong, nonatomic) LocationManager * locationManager;
@property (nonatomic) BOOL isNoFirstShow;
@property (strong, nonatomic) UIToolbar *keyboardToolbar;
@end

@implementation GTAddViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        
        switch (self.gift.liLaiWoWangType.intValue)
        {
            case LilaiType:
                self.title = @"编辑礼来";
                break;
            case WoWangType:
                self.title = @"编辑我往";
                break;
            default:
                break;
        }
        self.creationType = AllType;
        
    }
    return self;
}

- (void)dealloc
{
    XLOG(@"dealloc: %@",[self class]);
    self.locationManager = nil;
    self.keyboardToolbar = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // Keyboard toolbar
    if (self.keyboardToolbar == nil)
    {
        self.keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 38.0f)];
        self.keyboardToolbar.barStyle = UIBarStyleBlackTranslucent;
        
        UIBarButtonItem *previousBarItem = [[UIBarButtonItem alloc] initWithTitle:@"前一个"
                                                                            style:UIBarButtonItemStyleBordered
                                                                           target:self
                                                                           action:@selector(previousField:)];
        
        UIBarButtonItem *nextBarItem = [[UIBarButtonItem alloc] initWithTitle:@"下一个"
                                                                        style:UIBarButtonItemStyleBordered
                                                                       target:self
                                                                       action:@selector(nextField:)];
        
        UIBarButtonItem *spaceBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                      target:nil
                                                                                      action:nil];
        
        UIBarButtonItem *doneBarItem = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                        style:UIBarButtonItemStyleDone
                                                                       target:self
                                                                       action:@selector(resignKeyboard:)];
        
        [self.keyboardToolbar setItems:[NSArray arrayWithObjects:previousBarItem, nextBarItem, spaceBarItem, doneBarItem, nil]];
        
        self.personNameField.inputAccessoryView = self.keyboardToolbar;
        self.valueField.inputAccessoryView = self.keyboardToolbar;
        self.beizhuView.inputAccessoryView = self.keyboardToolbar;
    }

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
// for modification only
    
    if (self.isNoFirstShow)// 由于选择名字而产生的Appear
    {
        self.isNoFirstShow = NO;
        return;
    }
    NSString *priceStr = nil;

    if (self.gift.liLaiWoWangType.intValue == LilaiType)
    {
        priceStr = [NSString stringWithFormat:@"%.1f",self.gift.price.floatValue];

    }else if(self.gift.liLaiWoWangType.intValue == WoWangType)
    {
        priceStr = [NSString stringWithFormat:@"%.1f",-self.gift.price.floatValue];
    }
    if (self.gift.name.length>0)
    {
        [self.personNameField setText:self.gift.name];
    }
    
    if (self.gift.beizhu.length>0)
    {
        [self.beizhuView setText:self.gift.beizhu];
    }
    
    if (priceStr.length>0)
    {
        [self.valueField setText:priceStr];
    }

    if (self.gift.date)
    {
        [self.datePicker setDate:self.gift.date animated:NO];
    }

    if (self.gift.photo)
    {
        [self.photoView setImage:self.gift.photo];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnDidClicked:)];
    [rightBtn setTintColor:[UIColor colorWithRed:71.0/255.0 green:159.0/255.0 blue:35.0/255 alpha:1.0]];
    [self.navigationItem setRightBarButtonItem:rightBtn animated:YES];
    [self.personNameField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)doneEditForAllField:(id)sender
{
    [self.personNameField resignFirstResponder];
    [self.valueField resignFirstResponder];
    [self.beizhuView resignFirstResponder];
}

- (IBAction)chooseNameFromContect:(id)sender
{
    [self doneEditForAllField:nil];
    ABPeoplePickerNavigationController *picker =
    [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    self.isNoFirstShow = YES;
    [self presentViewController:picker animated:YES completion:^{
    }];
}

- (IBAction)locationBtnDidClicked:(id)sender
{
    if ([CLLocationManager locationServicesEnabled] == NO)
    {
        
        [[HUDHandler shareHandler] showHUDWithTitle:@"未启用地理位置获取功能。" afterDelay:2 withTick:NO];
        return;
    }
    
    
    if (self.locationManager == nil)
    {
        self.locationManager = [[LocationManager alloc] init];
        self.locationManager.delegate = self;
    }
#warning for test

    [self.locationManager startUpdatingLocation];

}

- (IBAction)rightBtnDidClicked:(id)sender
{    
    if (![self isPureFloat:self.valueField.text])
    {
        return;
    }

    if (!(self.personNameField.text.length>0))
    {
        return;
    }
    float price = [self.valueField.text floatValue];
    NSString *name = self.personNameField.text;
    NSString *beizhu = self.beizhuView.text;
    
    
    if (self.creationType == LilaiType)
    {
        self.gift = [Gift MR_createEntity];
        self.gift.liLaiWoWangType = [NSNumber numberWithInt:LilaiType];
    }else if (self.creationType == WoWangType)
    {
        self.gift = [Gift MR_createEntity];
        self.gift.liLaiWoWangType = [NSNumber numberWithInt:WoWangType];
    }
    
    switch (self.gift.liLaiWoWangType.intValue)
    {
        case LilaiType:
            self.gift.price = [NSNumber numberWithFloat:price];
            break;
        case WoWangType:
            self.gift.price = [NSNumber numberWithFloat:-price];
            break;
        default:
            break;
    }
    
    [self.gift setName:name];
    if (self.locationManager)
    {
        [self.gift setLat:[NSNumber numberWithDouble:self.locationManager.locationManager.location.coordinate.latitude]];
        [self.gift setLon:[NSNumber numberWithDouble:self.locationManager.locationManager.location.coordinate.longitude]];
    }
    [self.gift setPhoto:self.photoView.image];
    [self.gift setDate:self.datePicker.date];
    [self.gift setBeizhu:beizhu];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didFinishSaveGift:)])
    {
        [self.delegate didFinishSaveGift:self.gift];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pickImageFromCamera
{
    [self pickImageFrom:UIImagePickerControllerSourceTypeCamera];
}
- (void)pickImageFromLibrary
{
    [self pickImageFrom:UIImagePickerControllerSourceTypePhotoLibrary];
}


#pragma mark -
#pragma mark ABPeoplePickerNavigationControllerDelegate Methods
- (void)peoplePickerNavigationControllerDidCancel:
(ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    
    [self displayPerson:person];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    return NO;
}

- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{
    return NO;
}

#pragma mark -
#pragma mark Own Methods
- (void)displayPerson:(ABRecordRef)person
{
    NSString* firstName = (__bridge_transfer NSString*)ABRecordCopyValue(person,
                                                                    kABPersonFirstNameProperty);
    NSString* lastName = (__bridge_transfer NSString*)ABRecordCopyValue(person,
                                                                         kABPersonLastNameProperty);
    [self.personNameField setText:[NSString stringWithFormat:@"%@%@",lastName?lastName:@"",firstName?firstName:@""]];
}
- (BOOL)isPureFloat:(NSString*)string
{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    
    float val;
    
    return[scan scanFloat:&val] && [scan isAtEnd];
}
- (void)pickImageFrom:(UIImagePickerControllerSourceType)sourceType
{
    [self doneEditForAllField:nil];
    __block UIImagePickerController *pickerC = [[UIImagePickerController alloc] init];
    pickerC.sourceType = sourceType;
    [pickerC setAllowsEditing:YES];
    pickerC.delegate = self;
    if (sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        [pickerC setCameraCaptureMode:(UIImagePickerControllerCameraCaptureModePhoto)];
    }
    self.isNoFirstShow = YES;
    [self presentViewController:pickerC animated:YES completion:^{
        pickerC = nil;
    }];
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self.photoView setImage:[info objectForKey:UIImagePickerControllerEditedImage]];
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark -
#pragma mark LocationManagerDelegate Methods
- (void)didGetLocationWithLocation:(CLLocation *)location;
{
    [[HUDHandler shareHandler] showHUDWithTitle:@"地理位置获取成功！" afterDelay:1 withTick:YES];
    
}

- (void)didFailedToGetLoaction
{
    NSLog(@"didFailedToGetLoaction");
    [[HUDHandler shareHandler] showHUDWithTitle:@"地理位置获取失败！" afterDelay:2 withTick:NO];
}



#pragma mark -
#pragma UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [[GTHelper sharedGTHelper] defaultBeizhuDictCount];
}

#pragma mark -
#pragma UIPickerViewDelegate

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    if (!view)
    {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 30)];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(60, 3, 245, 24)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        [view addSubview:label];
        
        UIImageView *flagView = [[UIImageView alloc] initWithFrame:CGRectMake(60, -5, 40, 40)];
        flagView.contentMode = UIViewContentModeScaleToFill;
        [view addSubview:flagView];
    }
    
    [(UILabel *)[view.subviews objectAtIndex:0] setText:[[GTHelper sharedGTHelper] defaultBeizhuTextAtIndex:row]];
    [(UIImageView *)[view.subviews objectAtIndex:1] setImage:[[GTHelper sharedGTHelper] defaultBeizhuImageAtIndex:row]];
    
    return view;
}

#pragma mark -

- (void)doneButtonPressed:(id)sender
{
    NSString *chooesedText = [[GTHelper sharedGTHelper] defaultBeizhuTextAtIndex:[_pickerView selectedRowInComponent:0]];
    [self.beizhuView setText:chooesedText];
    if (self.photoView.image == nil||[[GTHelper sharedGTHelper] isDefaultImage:self.photoView.image])
    {
        [self.photoView setImage:[[GTHelper sharedGTHelper] defaultBeizhuImageAtIndex:[_pickerView selectedRowInComponent:0]]];
    }
    
    [_pickerViewPopup dismissWithClickedButtonIndex:1 animated:YES];
    _pickerView = nil;
    _pickerViewPopup = nil;
    
    [self resignKeyboard:self.beizhuView];

}

- (void)cancelButtonPressed:(id)sender
{
    [_pickerViewPopup dismissWithClickedButtonIndex:1 animated:YES];
    _pickerView = nil;
    _pickerViewPopup = nil;
}

- (IBAction)photoViewClicked:(id)sender
{
    NSString *destructiveButtonTitle = nil;
    if (self.photoView.image)
    {
        destructiveButtonTitle = @"删除当前照片";
    }
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:destructiveButtonTitle
                                  otherButtonTitles:@"拍照", @"图片库",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
    actionSheet = nil;

}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.photoView.image)
    {
        if (buttonIndex == 0)
        {
            self.photoView.image = nil;
        }
        else if (buttonIndex == 1)
        {
            [self pickImageFromCamera];
        }else if(buttonIndex == 2)
        {
            [self pickImageFromLibrary];
        }
    }
    else
    {
        if (buttonIndex == 0)
        {
            [self pickImageFromCamera];
        }else if(buttonIndex == 1)
        {
            [self pickImageFromLibrary];
        }
    }
    

}

- (void)resignKeyboard:(id)sender
{
    id firstResponder = [self getFirstResponder];
    if ([firstResponder isKindOfClass:[UITextField class]] || [firstResponder isKindOfClass:[UITextView class]]) {
        [firstResponder resignFirstResponder];
        [self animateView:1];
        [self resetLabelsColors];
    }
}

- (void)previousField:(id)sender
{
    id firstResponder = [self getFirstResponder];
    if ([firstResponder isKindOfClass:[UITextField class]] || [firstResponder isKindOfClass:[UITextView class]]) {
        NSUInteger tag = [firstResponder tag];
        NSUInteger previousTag = tag == 1 ? 1 : tag - 1;
        [self checkBarButton:previousTag];
        [self animateView:previousTag];
        UITextField *previousField = (UITextField *)[self.view viewWithTag:previousTag];
        [previousField becomeFirstResponder];
        UILabel *nextLabel = (UILabel *)[self.view viewWithTag:previousTag + 10];
        if (nextLabel) {
            [self resetLabelsColors];
            [nextLabel setTextColor:[GTAddViewController labelSelectedColor]];
        }
    }
}

- (void)nextField:(id)sender
{
    id firstResponder = [self getFirstResponder];
    if ([firstResponder isKindOfClass:[UITextField class]] || [firstResponder isKindOfClass:[UITextView class]]) {
        NSUInteger tag = [firstResponder tag];
        NSUInteger nextTag = tag == FIELDS_COUNT ? FIELDS_COUNT : tag + 1;
        [self checkBarButton:nextTag];
        [self animateView:nextTag];
        UITextField *nextField = (UITextField *)[self.view viewWithTag:nextTag];
        [nextField becomeFirstResponder];
        UILabel *nextLabel = (UILabel *)[self.view viewWithTag:nextTag + 10];
        if (nextLabel)
        {
            [self resetLabelsColors];
            [nextLabel setTextColor:[GTAddViewController labelSelectedColor]];
        }
    }
}

- (void)animateView:(NSUInteger)tag
{
    CGRect rect = self.view.frame;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    if (tag > 3) {
        rect.origin.y = -44.0f * (tag - 3);
    } else {
        rect.origin.y = 0;
    }
    self.view.frame = rect;
    [UIView commitAnimations];
}

- (void)checkBarButton:(NSUInteger)tag
{
    UIBarButtonItem *previousBarItem = (UIBarButtonItem *)[[self.keyboardToolbar items] objectAtIndex:0];
    UIBarButtonItem *nextBarItem = (UIBarButtonItem *)[[self.keyboardToolbar items] objectAtIndex:1];
    
    [previousBarItem setEnabled:tag == 1 ? NO : YES];
    [nextBarItem setEnabled:tag == FIELDS_COUNT ? NO : YES];
}

- (id)getFirstResponder
{
    NSUInteger index = 0;
    while (index <= FIELDS_COUNT) {
        UITextField *textField = (UITextField *)[self.view viewWithTag:index];
        if ([textField isFirstResponder]) {
            return textField;
        }
        index++;
    }
    
    return NO;
}
#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSUInteger tag = [textField tag];
    [self animateView:tag];
    [self checkBarButton:tag];
    UILabel *label = (UILabel *)[self.view viewWithTag:tag + 10];
    if (label) {
        [self resetLabelsColors];
        [label setTextColor:[GTAddViewController labelSelectedColor]];
    }
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    NSUInteger tag = [textView tag];
    [self animateView:tag];
    [self checkBarButton:tag];
    UILabel *label = (UILabel *)[self.view viewWithTag:tag + 10];
    if (label) {
        [self resetLabelsColors];
        [label setTextColor:[GTAddViewController labelSelectedColor]];
    }
    _pickerViewPopup = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 44.0, 0.0, 0.0)];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    _pickerView.hidden = NO;
    _pickerView.showsSelectionIndicator = YES;
    
    UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 44.0)];
    pickerToolbar.barStyle = UIBarStyleBlackOpaque;
    [pickerToolbar sizeToFit];
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems addObject:flexSpace];
    
    UIBarButtonItem *pickerDoneBtn = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:(UIBarButtonItemStyleBordered) target:self action:@selector(doneButtonPressed:)];
    [barItems addObject:pickerDoneBtn];
    [pickerDoneBtn setTintColor:[UIColor grayColor]];
    
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消或自定义输入" style:(UIBarButtonItemStyleBordered) target:self action:@selector(cancelButtonPressed:)];
    [barItems addObject:cancelBtn];
    
    [pickerToolbar setItems:barItems animated:YES];
    
    [_pickerViewPopup addSubview:pickerToolbar];
    [_pickerViewPopup addSubview:_pickerView];
    [_pickerViewPopup showInView:self.view];
    [_pickerViewPopup setBounds:CGRectMake(0.0, 0.0, 320.0, 464.0)];
}

- (void)resetLabelsColors
{
    self.personNameField.textColor = [GTAddViewController labelNormalColor];
    self.valueField.textColor = [GTAddViewController labelNormalColor];
    self.beizhuView.textColor = [GTAddViewController labelNormalColor];
}


+ (UIColor *)labelNormalColor
{
    return [UIColor colorWithRed:0.016 green:0.216 blue:0.286 alpha:1.000];
}

+ (UIColor *)labelSelectedColor
{
    return [UIColor colorWithRed:0.114 green:0.600 blue:0.737 alpha:1.000];
}

@end
