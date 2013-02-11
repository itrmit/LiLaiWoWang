//
//  GTTongJiViewController.h
//  礼来我往
//
//  Created by Guangtao Li on 2/16/13.
//  Copyright (c) 2013 Grant. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface GTTongJiViewController : UIViewController<NSFetchedResultsControllerDelegate>
- (IBAction)chooesStartTime:(id)sender;
- (IBAction)chooesEndTime:(id)sender;
- (IBAction)tongJiBtnClicked:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *startTimeBtn;
@property (weak, nonatomic) IBOutlet UIButton *endTimeBtn;
@end
