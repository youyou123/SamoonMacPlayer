//
//  CVWindowController.m
//  CoreVideo
//
//  Created by apple on 15/9/13.
//  Copyright (c) 2015年 yangyu   QQ：623240480. All rights reserved.
//

#import "CVWindowController.h"
#import "AppDelegate.h"
const NSString *notification_full_screen=@"window_full_change";
const float FIX_SIZE=0.7;
@interface CVWindowController ()

@end

static CGFloat  winWidth=1280;//1280;
static CGFloat  winHeight=760;//760;
@implementation CVWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    AppDelegate *delegate=[[NSApplication sharedApplication] delegate];
    
    delegate.windowVC=self;
    NSRect mainScreen=[[NSScreen mainScreen] frame];
    
    winWidth=mainScreen.size.width*FIX_SIZE;
    winHeight=mainScreen.size.height*FIX_SIZE;
    
    NSLog(@"CVWindowController windowDidLoad...winWidth=%f,winHeight=%f",winWidth,winHeight);
   
    NSString *appName= NSLocalizedStringFromTable(@"CFBundleDisplayName",@"InfoPlist", nil);
    [self.window setTitle:@" "];
 //[self.window set] Player(MPH&KMH Version)

    // 自定义一个view
  
 
 
    
    

    
   // [self.window setMiniwindowImage:[NSImage imageNamed:@"main_bg.png"]];//[NSImage imageNamed:@"speaker_on"]];
    [self.window setMiniwindowTitle:appName];
    [[self.window standardWindowButton:NSWindowZoomButton] setHidden:YES];
    
    CGFloat screenW=[[NSScreen mainScreen] frame].size.width;
    CGFloat screenH=[[NSScreen mainScreen] frame].size.height;
    
    [self.window setFrame:NSMakeRect((screenW-winWidth)/2,(screenH-winHeight)/2, winWidth, winHeight) display:YES];
    
    
    [self.window setContentMaxSize:NSMakeSize(winWidth,winHeight)];
    [self.window setContentMinSize:NSMakeSize(winWidth,winHeight)];
    
    self.window.delegate=self;
    NSLog(@"windows.w = %f,h=%f",self.window.frame.size.width,self.window.frame.size.height);
   
    
}
- (void)windowWillLoad{
    NSLog(@"windowWillLoad...");
}

- (void)windowWillEnterFullScreen:(NSNotification *)notification   NS_AVAILABLE_MAC(10_7){
    //NSLog(@"windowWillEnterFullScreen");
}
- (void)windowDidEnterFullScreen:(NSNotification *)notification   NS_AVAILABLE_MAC(10_7){
    NSLog(@"windowDidEnterFullScreen");
    [[NSNotificationCenter defaultCenter] postNotificationName:notification_full_screen object:nil];
}
- (void)windowWillExitFullScreen:(NSNotification *)notification   NS_AVAILABLE_MAC(10_7){
    //NSLog(@"windowWillExitFullScreen");
}
- (void)windowDidExitFullScreen:(NSNotification *)notification{
    NSLog(@"windowDidExitFullScreen");
     [[NSNotificationCenter defaultCenter] postNotificationName:notification_full_screen object:nil];
}


@end
