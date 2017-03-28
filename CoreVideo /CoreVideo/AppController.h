//
//  AppController.h
//  CoreVideo
//
//  Created by apple on 15/9/26.
//  Copyright (c) 2015年 yangyu   QQ：623240480. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PreferenceController;
@class AboutWindowView;
@interface AppController : NSObject{
    PreferenceController *preferenceController;
    AboutWindowView    *aboutWindow;
}
- (IBAction)showPreferencePanel:(id)sender;
- (IBAction)version:(id)sender;



@end
