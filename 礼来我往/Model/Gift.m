//
//  Gift.m
//  礼来我往
//
//  Created by Guangtao Li on 2/25/13.
//  Copyright (c) 2013 Grant. All rights reserved.
//

#import "Gift.h"
#import "UIImageToDataTransformer.h"

@implementation Gift

@dynamic beizhu;
@dynamic date;
@dynamic lat;
@dynamic lon;
@dynamic name;
@dynamic photo;
@dynamic price;
@dynamic liLaiWoWangType;
+ (void)initialize {
    if (self == [Gift class]) {
        UIImageToDataTransformer *transformer = [[UIImageToDataTransformer alloc] init];
        [NSValueTransformer setValueTransformer:transformer forName:@"UIImageToDataTransformer"];
    }
}
@end
