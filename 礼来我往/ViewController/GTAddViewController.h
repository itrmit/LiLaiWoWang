//
//  GTAddViewController.h
//  礼来我往
//
//  Created by Guangtao Li on 2/15/13.
//  Copyright (c) 2013 Grant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>
#import "LocationManager.h"
@class Gift;

@protocol GTAddViewControllerDelegate <NSObject>

- (void)didFinishSaveGift:(Gift *)gift;

@end

@interface GTAddViewController : UIViewController<ABPeoplePickerNavigationControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,LocationManagerDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIActionSheetDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *personNameField;
@property (weak, nonatomic) IBOutlet UITextField *valueField;
@property (weak, nonatomic) IBOutlet UITextView *beizhuView;
@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) id<GTAddViewControllerDelegate> delegate;

@property (strong, nonatomic) Gift *gift;
@property (nonatomic) LiLaiWoWangType creationType;

- (IBAction)chooseNameFromContect:(id)sender;
- (IBAction)locationBtnDidClicked:(id)sender;
- (IBAction)photoViewClicked:(id)sender;


+ (UIColor *)labelNormalColor;
+ (UIColor *)labelSelectedColor;


@end
