//
//  GTListDetailViewController.h
//  礼来我往
//
//  Created by Guangtao Li on 2/19/13.
//  Copyright (c) 2013 Grant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Gift.h"
#import "GTAddViewController.h"
@interface GTListDetailViewController : UIViewController<MKMapViewDelegate,MKAnnotation,GTAddViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UITextView *beizhuTextView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) Gift  *gift;
@end
