//
//  AppDelegate.h
//  CoreVideo
//
//  Created by admin on 15/9/11.
//  Copyright (c) 2015年 yangyu   QQ：623240480. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "VideoViewController.h"
#import "CVWindowController.h"
#import "PlayListViewController.h"
#import "CVWebViewController.h"
#import "CVLayoutViewController.h"
#import "CVModuleProtocol.h"



@interface AppDelegate : NSObject <NSApplicationDelegate>

@property(nonatomic,strong) VideoViewController *videoVC;
@property(nonatomic,strong) CVWindowController  *windowVC;
@property(nonatomic,strong) PlayListViewController  *playlistVC;
@property(nonatomic,strong) CVWebViewController  *webVC;

@property(nonatomic,weak) id<CVModuleProtocol> zoomInDelegate;
@property (weak) IBOutlet NSMenuItem *menuitemmph;



@property (weak) IBOutlet NSMenuItem *spdkmh;
@property (weak) IBOutlet NSMenuItem *googleMapsItem;

@property (weak) IBOutlet NSMenuItem *openstreetItem;
- (IBAction)googleAction:(id)sender;
- (IBAction)openstreetAction:(id)sender;


- (IBAction)showversion:(id)sender;


- (IBAction)openFile:(id)sender;

- (IBAction)watchvideo:(id)sender;

- (IBAction)website:(id)sender;
- (IBAction)shop:(id)sender;

- (IBAction)mphspd:(id)sender;

//- (IBAction)mphspd:(id)sender;
- (IBAction)kmhspd:(id)sender;

//help
@property (weak) IBOutlet NSMenuItem *tutorialvideo;

- (IBAction)visitwebsite:(id)sender;
- (IBAction)visitshop:(id)sender;
- (IBAction)tutorialvideo:(id)sender;

- (IBAction)visitabout:(id)sender;

//help


-(void)activeCurrentPlayIndex:(int)index;


@end

