//
//  GTListDetailViewController.m
//  礼来我往
//
//  Created by Guangtao Li on 2/19/13.
//  Copyright (c) 2013 Grant. All rights reserved.
//

#import "GTListDetailViewController.h"

@interface GTListDetailViewController ()
@property (nonatomic,strong) CLLocation *location;
@end

@implementation GTListDetailViewController

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
    self.location = nil;
    self.gift = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadLiLaiWoWangDetailData];
}

- (void)loadLiLaiWoWangDetailData
{
    if (self.gift.liLaiWoWangType.intValue == LilaiType)
    {
        self.title = [NSString stringWithFormat:@"礼来-%@",self.gift.name];
        [self.valueLabel setText:[NSString stringWithFormat:@"%.1f 元",[self.gift.price floatValue]]];
    }
    else if(self.gift.liLaiWoWangType.intValue == WoWangType)
    {
        self.title = [NSString stringWithFormat:@"我往-%@",self.gift.name];
        [self.valueLabel setText:[NSString stringWithFormat:@"%.1f 元",-[self.gift.price floatValue]]];
    }
    
    [self.nameLabel setText:self.gift.name];

    [self.photoView setImage:[[GTHelper sharedGTHelper] getImageFromGift:self.gift]];
    
    [self.beizhuTextView setText:self.gift.beizhu];
    
    if (self.gift.lat.floatValue!=0.0 && self.gift.lon.floatValue!=0.0)
    {
        _location = [[CLLocation alloc] initWithLatitude:self.gift.lat.doubleValue longitude:self.gift.lon.doubleValue];
        
        MKCoordinateRegion region =
        MKCoordinateRegionMakeWithDistance(self.location.coordinate, 80000, 80000);
        [self.mapView setHidden:NO];
        [self.mapView setRegion:region animated:NO];
    }else
    {
        [self.mapView setHidden:YES];
    }
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if (_location)
    {
        MKCoordinateRegion region =
        MKCoordinateRegionMakeWithDistance(self.location.coordinate, 600, 600);
        [self.mapView setRegion:region animated:YES];
    }
    
    UIBarButtonItem *editBtn = [[UIBarButtonItem alloc] initWithTitle:@"修改" style:(UIBarButtonItemStyleBordered) target:self action:@selector(editBtnDidClicked:)];
    [editBtn setTintColor:[UIColor colorWithRed:71.0/255.0 green:159.0/255.0 blue:35.0/255 alpha:1.0]];
    [self.navigationItem setRightBarButtonItem:editBtn animated:YES];

}

- (void)editBtnDidClicked:(id)sender
{
    GTAddViewController *addVC = nil;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {
        addVC = [[GTAddViewController alloc] initWithNibName:@"GTAddViewController_iPhone" bundle:nil];
    }else
    {
        addVC = [[GTAddViewController alloc] initWithNibName:@"GTAddViewController_iPad" bundle:nil];
    }

    [addVC setGift:self.gift];
    addVC.delegate = self;
    [self.navigationController pushViewController:addVC animated:YES];
    addVC = nil;
}

- (CLLocationCoordinate2D)coordinate;
{
    return self.location.coordinate;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if (animated)
    {
        [self.mapView addAnnotation:self];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    
    MKPinAnnotationView *customPinView = [[MKPinAnnotationView alloc]
                                          initWithAnnotation:annotation reuseIdentifier:nil];
    customPinView.pinColor = MKPinAnnotationColorRed;
    customPinView.animatesDrop = YES;
    customPinView.canShowCallout = NO;
    return customPinView;
}
#pragma mark -
#pragma mark GTAddViewControllerDelegate
- (void)didFinishSaveGift:(Gift *)gift
{
    self.gift = gift;
}

@end
