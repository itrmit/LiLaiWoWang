//
//  HUDHandler.m
//  ClothesShow
//
//  Created by 李广韬 on 5/07/12.
//  Copyright (c) 2012 Grant. All rights reserved.
//

#import "HUDHandler.h"

static HUDHandler *_HUDHandler = nil;


@interface HUDHandler ()
@property (nonatomic, strong) MBProgressHUD *HUD;
@property (nonatomic, strong) UIImageView *tickView;
@end


@implementation HUDHandler
@synthesize HUD = _HUD;
@synthesize tickView = _tickView;

+ (HUDHandler *)shareHandler
{
    @synchronized(self)
    {
        if(_HUDHandler == nil)
            _HUDHandler = [[HUDHandler alloc] init];
    }
    return _HUDHandler;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if(_HUDHandler == nil)
            _HUDHandler = [super allocWithZone:zone];
    }
    return _HUDHandler;
}

- (id)init
{
    self = [super init];
    if(self)
    {
        _HUD = [[MBProgressHUD alloc] initWithWindow:[[UIApplication sharedApplication] keyWindow]];
        [_HUD setRemoveFromSuperViewOnHide:YES];
        _HUD.delegate = self;
        _tickView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    }
    return self;
}


-(void)showHUDWithTitle:(NSString *)title afterDelay:(NSTimeInterval) delay withTick:(BOOL)withTick
{



    if (![NSThread isMainThread]) 
    {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showHUDWithTitle:title afterDelay:delay withTick:withTick];
        });
    }
    else
    {
        [_HUD show:YES];
        [[[UIApplication sharedApplication] keyWindow] addSubview:_HUD];
//        [_HUD setDimBackground:YES];
        _HUD.labelText = title;
        if (withTick) 
        {
            _HUD.mode = MBProgressHUDModeCustomView;
            _HUD.customView = _tickView;
        }else {
            _HUD.mode = MBProgressHUDModeIndeterminate;
        }
        
        if (delay > 0)
        {
            [_HUD hide:YES afterDelay:delay];
        }else {

            [_HUD hide:YES afterDelay:20];
        }
    }
}

- (void)setProgress:(float)value
{
    if (![NSThread isMainThread])
    {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setProgress:value];
        });
    }
    else
    {
        XLOG(@"%f",value);
        if (value == 1.0)
        {   
            //[_HUD setLabelText:@"100%发送!"];
            //[_HUD hide:YES afterDelay:2];
        }
        
        else
        {
            if (_HUD.mode != MBProgressHUDModeAnnularDeterminate)
            {
                _HUD.mode = MBProgressHUDModeAnnularDeterminate;
            }
//            if ([_HUD isHidden])
//            {
                [_HUD show:YES];
//            }

        }

        if([_HUD superview] != [[UIApplication sharedApplication] keyWindow])
        {
            [[[UIApplication sharedApplication] keyWindow] addSubview:_HUD];
        }
        

        [_HUD setProgress:value];
    }
}

- (void)setLabelText:(NSString *)labelText
{
    if (_HUD)
    {
        [_HUD setLabelText:labelText];
    }
}

- (void)hide:(BOOL)isHide afterDelay:(NSTimeInterval)delay
{
    if (_HUD)
    {
        [_HUD show:YES];
        [_HUD hide:isHide afterDelay:delay];
    }
}


- (void)showWhileExecuting:(SEL)method onTarget:(id)target withObject:(id)object animated:(BOOL)animated
{
    [_HUD setHidden:NO];
    [[[UIApplication sharedApplication] keyWindow] addSubview:_HUD];
    [_HUD showWhileExecuting:method onTarget:target withObject:object animated:animated];
}


-(void)setHide
{
    [_HUD setHidden:YES];
}
@end
