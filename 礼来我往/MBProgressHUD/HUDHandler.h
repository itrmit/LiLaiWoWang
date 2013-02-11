//
//  HUDHandler.h
//  ClothesShow
//
//  Created by 李广韬 on 5/07/12.
//  Copyright (c) 2012 Grant. All rights reserved.
//

#import "MBProgressHUD.h"
@interface HUDHandler : NSObject<MBProgressHUDDelegate>


+ (HUDHandler *)shareHandler;

-(void)showHUDWithTitle:(NSString *)title afterDelay:(NSTimeInterval) delay withTick:(BOOL)withTick;
-(void)setHide;
- (void)setProgress:(float)value;
- (void)showWhileExecuting:(SEL)method onTarget:(id)target withObject:(id)object animated:(BOOL)animated;

- (void)setLabelText:(NSString *)labelText;
- (void)hide:(BOOL)isHide afterDelay:(NSTimeInterval)delay;
@end
