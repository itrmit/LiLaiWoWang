//
//  Gift.h
//  礼来我往
//
//  Created by Guangtao Li on 2/25/13.
//  Copyright (c) 2013 Grant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Gift : NSManagedObject

@property (nonatomic, retain) NSString * beizhu;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * lat;
@property (nonatomic, retain) NSNumber * lon;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) UIImage  *photo;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSNumber * liLaiWoWangType;

@end
