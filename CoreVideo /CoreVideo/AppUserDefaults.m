//
//  AppUserDefaults.m
//  CoreVideo
//
//  Created by apple on 15/9/26.
//  Copyright (c) 2015年 yangyu   QQ：623240480. All rights reserved.
//pyy code

#import "AppUserDefaults.h"
const NSString* KMPH=@"kmph";
const  NSString* MILEPH=@"mileph";
const NSString* GOOGLE=@"google";//google map
const  NSString* STREET=@"street";//open strees map
@implementation AppUserDefaults


+(NSString *)initSpeedUnitUserDefault{
    
    NSString* speedUNIT=[[NSUserDefaults standardUserDefaults] objectForKey:@"speed_unit"];
  
    if([speedUNIT isEqualToString:MILEPH]){
        [[NSUserDefaults standardUserDefaults] setObject:MILEPH forKey:@"speed_unit"];

        
    }else if([speedUNIT isEqualToString:KMPH]){
  
        [[NSUserDefaults standardUserDefaults] setObject:KMPH forKey:@"speed_unit"];

        
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:KMPH forKey:@"speed_unit"];

    }

    
    return speedUNIT;

}
+(BOOL)isKMPH{
    NSString* speedUNIT=[self initSpeedUnitUserDefault];
    
    if([speedUNIT isEqualToString:KMPH]){
        return YES;
    }else{
        return NO;
    }
}
+(void)setSpeedUnit:(NSString *)unit{
     [[NSUserDefaults standardUserDefaults] setObject:unit forKey:@"speed_unit"];
}

//+(NSString *)initChangeMapUserDefault{
//    
//    NSString* speedUNIT=[[NSUserDefaults standardUserDefaults] objectForKey:@"change_map"];
//    
//    if([speedUNIT isEqualToString:GOOGLE]){
//        [[NSUserDefaults standardUserDefaults] setObject:GOOGLE forKey:@"change_map"];
//        
//        
//    }else if([speedUNIT isEqualToString:STREET]){
//        
//        [[NSUserDefaults standardUserDefaults] setObject:STREET forKey:@"change_map"];
//        
//        
//    }else{
//        [[NSUserDefaults standardUserDefaults] setObject:STREET forKey:@"change_map"];
//        
//    }
//    
//    
//    return speedUNIT;
//    
//}
//+(BOOL)isKMPH{
//    NSString* speedUNIT=[self initSpeedUnitUserDefault];
//    
//    if([speedUNIT isEqualToString:KMPH]){
//        return YES;
//    }else{
//        return NO;
//    }
//}
+(void)setChangeMap:(NSString *)map{
    [[NSUserDefaults standardUserDefaults] setObject:map forKey:@"change_map"];
}

@end
