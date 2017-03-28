//
//  AppUserDefaults.h
//  CoreVideo
//
//  Created by apple on 15/9/26.
//  Copyright (c) 2015年 yangyu   QQ：623240480. All rights reserved.
//

#import <Foundation/Foundation.h>
extern const NSString* KMPH;
extern const NSString* MILEPH;
extern   const NSString* GOOGLE;
extern   const  NSString* STREET;
@interface AppUserDefaults : NSObject


+(NSString *)initSpeedUnitUserDefault;

+(BOOL)isKMPH;

+(void)setSpeedUnit:(NSString *)unit;
+(void)setChangeMap:(NSString *)map;


@end
