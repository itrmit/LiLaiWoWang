//
//  GTHelper.h
//  礼来我往
//
//  Created by Guangtao Li on 3/2/13.
//  Copyright (c) 2013 Grant. All rights reserved.
//

#import "ARCSingletonTemplate.h"

#define kBeizhuShengRi   @"生日"
#define kBeizhuHunLi     @"婚礼"
#define kBeizhuManyue    @"满月"
#define kBeizhuShengzi   @"生子"

#define kBeizhuText  @"kBeizhuText"
#define kBeizhuPhotoName @"kBeizhuPhotoName"


@class Gift;
@interface GTHelper : NSObject
SYNTHESIZE_SINGLETON_FOR_HEADER(GTHelper)

- (UIImage *)getImageFromGift:(Gift *)gift;

- (UIImage *)defaultBeizhuImageAtIndex:(NSInteger)index;

- (NSString *)defaultBeizhuTextAtIndex:(NSInteger)index;

- (NSInteger)defaultBeizhuDictCount;

- (BOOL)isDefaultImage:(UIImage *)image;

@end
