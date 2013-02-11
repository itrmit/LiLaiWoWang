//
//  GTDoorViewController.m
//  礼来我往
//
//  Created by Guangtao Li on 2/24/13.
//  Copyright (c) 2013 Grant. All rights reserved.
//

#import "GTDoorViewController.h"

@interface GTDoorViewController ()

@end

@implementation GTDoorViewController

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
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.liLaiWoWangBtn setImage:[UIImage imageNamed:@"liLaiWowangBtnHigh"] forState:UIControlStateHighlighted];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)liLaiWoWangBtnClicked:(id)sender
{
    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"用户验证" message:@"请输入密码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    [alert setAlertViewStyle:(UIAlertViewStyleSecureTextInput)];
//    [alert show];
//    alert = nil;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(allowComein)])
    {
        [self.delegate allowComein];
    }
}

@end
