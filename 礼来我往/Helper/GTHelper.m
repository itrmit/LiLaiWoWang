//
//  GTHelper.m
//  礼来我往
//
//  Created by Guangtao Li on 3/2/13.
//  Copyright (c) 2013 Grant. All rights reserved.
//

#import "GTHelper.h"
#import "Gift.h"

@interface GTHelper ()
{
    NSMutableDictionary *defaltBeiZhuDict;
    UIImage *emptyImageSmall;
    UIImage *emptyImageLarge;
}
@end


@implementation GTHelper
SYNTHESIZE_SINGLETON_FOR_CLASS(GTHelper)

- (id)init
{
    self = [super init];
    if (self)
    {
        emptyImageSmall = [UIImage imageNamed:@"imageReplacement-Small"];
        emptyImageLarge = [UIImage imageNamed:@"imageReplacement"];
        
        
        defaltBeiZhuDict = [[NSMutableDictionary alloc] init];
        [defaltBeiZhuDict setObject:[NSDictionary dictionaryWithObjectsAndKeys:kBeizhuShengRi,kBeizhuText,[UIImage imageNamed:@"beizhuShengRi.jpg"],kBeizhuPhotoName, nil] forKey:kBeizhuShengRi];
        [defaltBeiZhuDict setObject:[NSDictionary dictionaryWithObjectsAndKeys:kBeizhuHunLi,kBeizhuText,[UIImage imageNamed:@"beizhuHunLi.jpg"],kBeizhuPhotoName, nil] forKey:kBeizhuHunLi];
        [defaltBeiZhuDict setObject:[NSDictionary dictionaryWithObjectsAndKeys:kBeizhuManyue,kBeizhuText,[UIImage imageNamed:@"beizhuManyue.jpg"],kBeizhuPhotoName, nil] forKey:kBeizhuManyue];
        [defaltBeiZhuDict setObject:[NSDictionary dictionaryWithObjectsAndKeys:kBeizhuShengzi,kBeizhuText,[UIImage imageNamed:@"beizhuShengzi.jpg"],kBeizhuPhotoName, nil] forKey:kBeizhuShengzi];
    }
    return self;
}

- (UIImage *)getImageFromGift:(Gift *)gift
{
    if (gift.photo)
    {
        return gift.photo;
    }else
    {
        if (gift.beizhu.length==0)
        {
            return emptyImageLarge;
        }
        NSDictionary *beizhuDict = [defaltBeiZhuDict objectForKey:gift.beizhu];
        if (beizhuDict == nil)
        {
            return emptyImageLarge;
        }else
        {
            return [beizhuDict objectForKey:kBeizhuPhotoName];
        }
    }
}

- (UIImage *)defaultBeizhuImageAtIndex:(NSInteger)index
{
    NSString *beizhuDictKey = [defaltBeiZhuDict.allKeys objectAtIndex:index];
    return [[defaltBeiZhuDict objectForKey:beizhuDictKey] objectForKey:kBeizhuPhotoName];
}

- (NSString *)defaultBeizhuTextAtIndex:(NSInteger)index
{
    NSString *beizhuDictKey = [defaltBeiZhuDict.allKeys objectAtIndex:index];
    NSString *beizhuText = [[defaltBeiZhuDict objectForKey:beizhuDictKey] objectForKey:kBeizhuText];
    return beizhuText;
}

- (NSInteger)defaultBeizhuDictCount
{
    return defaltBeiZhuDict.count;
}

- (BOOL)isDefaultImage:(UIImage *)image
{
    NSArray *allKeys = defaltBeiZhuDict.allKeys;
    for (NSString *key in allKeys)
    {
        NSDictionary *beizhuDict = [defaltBeiZhuDict objectForKey:key];
        if ([beizhuDict objectForKey:kBeizhuPhotoName] == image)
        {
            return YES;
        }
    }
    return NO;
}
@end
