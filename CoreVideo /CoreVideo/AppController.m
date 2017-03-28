//
//  AppController.m
//  CoreVideo
//
//  Created by apple on 15/9/26.
//  Copyright (c) 2015年 yangyu   QQ：623240480. All rights reserved.
//

#import "AppController.h"
#import "PreferenceController.h"
#import "AboutWindowView.h"
@implementation AppController



- (IBAction)showPreferencePanel:(id)sender {
    NSLog(@"AppController showPreferencePanel");
    if(!preferenceController){
        preferenceController=[[PreferenceController alloc] init];
    }
    
    [preferenceController showWindow:self];
}

- (IBAction)version:(id)sender {
    NSLog(@"versionversion--------------------");
    if(!aboutWindow){
        aboutWindow=[[AboutWindowView alloc] init];
    }
    
    [aboutWindow showWindow:self];
    
}

@end
//Player(MPH&KMH Version)
