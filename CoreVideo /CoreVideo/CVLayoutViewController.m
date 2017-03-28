//
//  CVLayoutViewController.m
//  CoreVideo
//
//  Created by admin on 15/9/16.
//  Copyright (c) 2015年 yangyu   QQ：623240480. All rights reserved.
//

//holding priorities left=384 right=250


#import "CVLayoutViewController.h"
#import "VideoViewController.h"
#import "PlayListViewController.h"
#import "CVWebViewController.h"
#import "CVDisplayViewController.h"
#import "CVModuleProtocol.h"
#import "AppColorManager.h"
#import "GpsViewController.h"
#import <objc/runtime.h>

@interface CVLayoutViewController ()<CVModuleProtocol>{
    VideoViewController     *videoVC ;
    CVWebViewController     *webVC ;
    PlayListViewController  *playlistVC;
    CVDisplayViewController *displayVC;
    GpsViewController       *gpsVC;
    
    
    NSRect globalView1Rect;
    NSRect globalView0Rect;
    NSRect globalView2Rect;
    
    NSRect leftView1Rect;
    NSRect leftView0Rect;
    
    NSRect rightView1Rect;
    NSRect rightView0Rect;
    
    BOOL videoZoomStateMAX;
    BOOL mapZoomStateMAX;
    
    CGFloat global_position0;
    CGFloat global_position1;
    
}
@property (weak) IBOutlet NSSplitView *globalSplitView;
@property (weak) IBOutlet NSSplitView *leftSplitView;
@property (weak) IBOutlet NSSplitView *rightSplitView;
//@property (weak) IBOutlet NSView *gmapWebView;


@property (weak) IBOutlet NSView *playListView;
@property (weak) IBOutlet NSView *videoView;
@property (weak) IBOutlet NSView *displayView;
@property (weak) IBOutlet NSView *mapInfoView;




@end

@implementation CVLayoutViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowFullScreenChange:) name:notification_full_screen object:nil];
    
    
    [self.view setWantsLayer:YES];
    
    
    [self.view.layer setBackgroundColor:[[AppColorManager appBackgroundColor] CGColor]];
    
    videoZoomStateMAX=NO;
    mapZoomStateMAX=NO;
    
    // Do view setup here.
    
    displayVC =[[NSStoryboard storyboardWithName:@"Main" bundle:nil] instantiateControllerWithIdentifier:@"displayVC"];
    
    webVC      =[[NSStoryboard storyboardWithName:@"Main" bundle:nil] instantiateControllerWithIdentifier:@"webVC"];
    webVC.distanceDelegate=displayVC;
    webVC.zoomInOutDelegate=self;
    //NSLog(@"webVC.zoomInOutDelegate===%@",webVC.zoomInOutDelegate);
    
    gpsVC=[[NSStoryboard storyboardWithName:@"Main" bundle:nil] instantiateControllerWithIdentifier:@"gpsVC"];
    
    playlistVC =[[NSStoryboard storyboardWithName:@"Main" bundle:nil] instantiateControllerWithIdentifier:@"playlistVC"];
    
    videoVC    =[[NSStoryboard storyboardWithName:@"Main" bundle:nil] instantiateControllerWithIdentifier:@"videoVC"];
    
    videoVC.zoomInDelegate=self;
    videoVC.gpsDelegate=webVC;
    videoVC.speedDelegate=displayVC;
    videoVC.gpsInfoDelegate=playlistVC;       //gpsVC;
    videoVC.videoEndDelegate=playlistVC;
    
    
    
    //leftRect0:x:0.000000 y:0.000000 w:1013.000000 h:422.000000 leftRect1:x:0.000000 y:0.000000 w:1013.000000 h:328.000000 rightRect0:x:0.000000 y:0.000000 w:266.000000 h:423.000000 rightRect1:x:0.000000 y:0.000000 w:266.000000 h:327.000000
    
    
    
    
    
    [self.videoView addSubview:videoVC.view];
    [self.playListView addSubview:playlistVC.view];
    [self.mapInfoView addSubview:webVC.view];//gps
    [self.displayView addSubview:displayVC.view];
    // [self.gmapWebView addSubview:webVC.view];
    // self.displayView.hidden=YES;
    // self.gmapWebView.hidden=YES;
    
    //  self.gmapWebView.accessibilityEdited=NO;
    
    
    
    //[self updateViewLetfView0:_videoView view1:_displayView rightView0:_mapView view1:_playListView];
    
    [[[_globalSplitView subviews] objectAtIndex:0] setFrame:NSMakeRect(0,0,1280,760)];//1014，760//840//1600,900//800
    [[[_globalSplitView subviews] objectAtIndex:1] setFrame:NSMakeRect(0,0,640,460)];//266
    // [[[_globalSplitView subviews] objectAtIndex:2] setFrame:NSMakeRect(0,0,0,0)];
    
    
    [[[_leftSplitView subviews] objectAtIndex:0] setFrame:NSMakeRect(0,0,1280,600)];
    
    [[[_leftSplitView subviews] objectAtIndex:1] setFrame:NSMakeRect(0,0,1280,160)];//220
    
    [[[_rightSplitView subviews] objectAtIndex:0] setFrame:NSMakeRect(0,0,640,320)];//460
    [[[_rightSplitView subviews] objectAtIndex:1] setFrame:NSMakeRect(0,0,640,440)];
    
    [[[_rightSplitView subviews] objectAtIndex:1] setFrame:NSMakeRect(0,0,640,440)];//460
    
    
    
    [_globalSplitView  setDelegate:self];
    [_leftSplitView    setDelegate:self];
    [_rightSplitView   setDelegate:self];
    [self nssplitViewDivideInit:_globalSplitView];
    [self nssplitViewDivideInit:_leftSplitView];
    [self nssplitViewDivideInit:_rightSplitView];
 
    //
    
    
    //    NSView *left = [[_globalSplitView subviews] objectAtIndex:0];
    //    NSView   *right = [[ _globalSplitView subviews] objectAtIndex:1];
    //
    //    NSRect rightFrame = [right frame];
    //
    //    NSRect leftFrame = [left frame];
    //
    //    NSRect overallFrame = [_globalSplitView frame];
    //    NSView *left1= [[_leftSplitView subviews] objectAtIndex:0];
    //    NSView   *left2 = [[ _leftSplitView subviews] objectAtIndex:1];
    //
    //    NSView *right1= [[_rightSplitView subviews] objectAtIndex:0];
    //    NSView   *right2 = [[ _rightSplitView subviews] objectAtIndex:1];
    //
    //     [left setFrameSize:NSMakeSize(overallFrame.size.width,leftFrame.size.height)];
    //
    //    [right setFrameSize:NSMakeSize(overallFrame.size.width/2,rightFrame.size.height/2)];
    //
    //    [_globalSplitView adjustSubviews];
    
    
    
}
- (BOOL)splitView:(NSSplitView *)splitView shouldHideDividerAtIndex:(NSInteger)dividerIndex NS_AVAILABLE_MAC(10_5){
    return  YES;
}

-(NSString *)currentSplitView:(NSSplitView *)splitview{
    if(splitview==_globalSplitView){
        return @"_globalSplitView";
    }else if(splitview==_leftSplitView){
        return @"_leftSplitView";
    }else if(splitview==_rightSplitView){
        return @"_rightSplitView";
    }
    return nil;
}
-(void)windowFullScreenChange:(NSNotification *)notification{
    NSLog(@"windowFullScreenChange=======");
    global_position0=0;
    global_position1=0;
}

- (CGFloat)splitView:(NSSplitView *)splitView constrainMinCoordinate:(CGFloat)proposedMinimumPosition ofSubviewAt:(NSInteger)dividerIndex{
    
    //NSLog(@"splitView %@ proposedMinimumPosition %f  dividerIndex %ld",[self currentSplitView:splitView],proposedMinimumPosition,dividerIndex);
    NSLog(@"min proposedMinimumPosition=%f",proposedMinimumPosition);
    
    if(splitView==_globalSplitView){
        //NSLog(@"splitView==_globalSplitView===dividerIndex==%ld,global_position0=%f",dividerIndex,global_position0);
        if(dividerIndex==1){
            
            if(global_position0>0){
                return global_position0;
            }
            global_position0=proposedMinimumPosition;
            //NSLog(@"global_position0===%f",global_position0);
        }
    }else if (splitView== _rightSplitView){
        //NSLog(@"splitView == _rightSplitView,constrainMinCoordinate=%f",proposedMinimumPosition);
        return 160;
    }else if(splitView== _leftSplitView){
        //NSLog(@"splitView == _rightSplitView,constrainMinCoordinate=%f",proposedMinimumPosition);
        return 460;
    }
    
    //return proposedMinimumPosition;
    //modify by chenjian
    return 600;
}

- (CGFloat)splitView:(NSSplitView *)splitView constrainMaxCoordinate:(CGFloat)proposedMaximumPosition ofSubviewAt:(NSInteger)dividerIndex{
    //NSLog(@"splitView %@ proposedMaximumPosition %f  dividerIndex %ld",[self currentSplitView:splitView],proposedMaximumPosition,dividerIndex);
    NSLog(@"max proposedMaximumPosition=%f",proposedMaximumPosition);
    
    if(splitView==_globalSplitView){
        if(dividerIndex==0){
            if(global_position1>0){
                return global_position1;
            }
            global_position1=proposedMaximumPosition;
        }
    }else if (splitView==_leftSplitView){
        //NSLog(@"splitView == _leftSplitView,constrainMaxCoordinate=%f",proposedMaximumPosition);
        return 420.0;
    }else if (splitView==_rightSplitView){
        //NSLog(@"splitView == _rightSplitView,constrainMaxCoordinate=%f",proposedMaximumPosition);
        return 470.0;
    }
    
    return proposedMaximumPosition;
}

- (CGFloat)splitView:(NSSplitView *)splitView constrainSplitPosition:(CGFloat)proposedPosition ofSubviewAt:(NSInteger)dividerIndex{
    
    //NSLog(@"splitView %@ proposedPosition %f  dividerIndex %ld",[self currentSplitView:splitView],proposedPosition,dividerIndex);
    if(splitView==_globalSplitView){
        if(dividerIndex==0){
            return global_position0;
        }else if(dividerIndex==1){
            return global_position1;
        }
    }else if (splitView==_leftSplitView){
        //NSLog(@"splitView == _leftSplitView,constrainSplitPosition=%f",proposedPosition);
        return 420;
    }else if (splitView==_rightSplitView){
        //NSLog(@"splitView == _rightSplitView,constrainSplitPosition=%f",proposedPosition);
        return 219;
    }
    
    return proposedPosition;
    
}

/*
 -(void)splitView:(NSSplitView *)sender resizeSubviewsWithOldSize: (NSSize)oldSize
 {
 
 }*/

- (void)splitViewWillResizeSubviews:(NSNotification *)notification{
    //NSLog(@"splitViewWillResizeSubviews %@",notification.userInfo);
}



- (void)splitViewDidResizeSubviews:(NSNotification *)notification{
    // NSArray *splitViews = [self.globalSplitView subviews];
    
    NSArray *leftViews  = [self.leftSplitView subviews];
    NSArray *rightViews = [self.rightSplitView subviews];
    
    //    NSView *map_webView=[[_globalSplitView subviews] objectAtIndex:2];
    
    
    
    NSView *leftView0=[leftViews objectAtIndex:0];
    NSView *leftView1=[leftViews objectAtIndex:1];
    
    NSView *rightView0=[rightViews objectAtIndex:0];
    NSView *rightView1=[rightViews objectAtIndex:1];
    
    
    [self updateViewLetfView0:leftView0 view1:leftView1 rightView0:rightView0 view1:rightView1 webView:rightView0];//:rightView0//rightView0:rightView0
    
    
    
    
}


-(void)updateViewLetfView0:(NSView *)leftView0 view1:(NSView *)leftView1 rightView0:(NSView *)rightView0 view1:(NSView *)rightView1 webView:(NSView *)map_webView{
    
    [self updateViewLetfRect0:leftView0.bounds rect1:leftView1.bounds rightRect0:rightView0.bounds rect1:rightView1.bounds mapRect:map_webView.bounds];
}

-(void)updateViewLetfRect0:(NSRect)leftRect0 rect1:(NSRect)leftRect1 rightRect0:(NSRect)rightRect0 rect1:(NSRect)rightRect1 mapRect:(NSRect)mRect{
    
    //NSLog(@"leftRect0:%@ leftRect1:%@ rightRect0:%@ rightRect1:%@",[self nsRectToString:leftRect0],[self nsRectToString:leftRect1],[self nsRectToString:rightRect0],[self nsRectToString:rightRect1]);
    
    
    [videoVC.view setFrame:leftRect0];
    [displayVC.view setFrame:leftRect1];
    
    [playlistVC.view setFrame:rightRect1];
    [gpsVC.view setFrame:rightRect0];
    
    
    
    [webVC.view setFrame:mRect];
    
    [webVC.webview setFrame:webVC.view.bounds];
    
}

-(NSString *)nsRectToString:(NSRect)rect{
    return [NSString stringWithFormat:@"x:%f y:%f w:%f h:%f",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height];
}

- (BOOL)splitView:(NSSplitView *)splitView shouldAdjustSizeOfSubview:(NSView *)view NS_AVAILABLE_MAC(10_6){
    return YES;
}


#pragma mark delegate Window Zoom IN Out

-(NSInteger)zoomInMapWindow:(NSInteger)state{
    
    //NSLog(@"zoomInMapWindow======state=%ld",state);
    if(videoZoomStateMAX||(!mapZoomStateMAX&&state==1)){
        state=0;
    }
    //NSLog(@"CVLayoutViewController zoomInMapWindow======state2=%ld",state);
    
    if(state==0){
        
        //全屏
        //NSLog(@"全屏全屏全屏全屏全屏全屏全屏全屏");
        
        [[[_globalSplitView subviews] objectAtIndex:0] setFrame:NSMakeRect(0,0,1014,760)];
        [[[_globalSplitView subviews] objectAtIndex:1] setFrame:NSMakeRect(0,0,0,0)];
        [[[_globalSplitView subviews] objectAtIndex:2] setFrame:NSMakeRect(0,0,532,760)];
        
        [[[_leftSplitView subviews] objectAtIndex:0] setFrame:NSMakeRect(0,0,1014,540)];
        [[[_leftSplitView subviews] objectAtIndex:1] setFrame:NSMakeRect(0,0,1014,220)];
        
        [[[_rightSplitView subviews] objectAtIndex:0] setFrame:NSMakeRect(0,0,0,0)];
        [[[_rightSplitView subviews] objectAtIndex:1] setFrame:NSMakeRect(0,0,0,0)];
        mapZoomStateMAX=YES;
        videoZoomStateMAX=NO;
    }else{
        
        //NSLog(@"非全屏非全屏非全屏非全屏非全屏非全屏");
        [[[_globalSplitView subviews] objectAtIndex:0] setFrame:NSMakeRect(0,0,1014,760)];
        [[[_globalSplitView subviews] objectAtIndex:1] setFrame:NSMakeRect(0,0,266,760)];
        [[[_globalSplitView subviews] objectAtIndex:2] setFrame:NSMakeRect(0,0,266,760)];
        
        [[[_leftSplitView subviews] objectAtIndex:0] setFrame:NSMakeRect(0,0,1014,540)];
        [[[_leftSplitView subviews] objectAtIndex:1] setFrame:NSMakeRect(0,0,1014,220)];
        
        [[[_rightSplitView subviews] objectAtIndex:0] setFrame:NSMakeRect(0,0,266,360)];
        [[[_rightSplitView subviews] objectAtIndex:1] setFrame:NSMakeRect(0,0,266,400)];
        mapZoomStateMAX=NO;
    }
    [_globalSplitView adjustSubviews];
    [_leftSplitView   adjustSubviews];
    [_rightSplitView  adjustSubviews];

    
    
    return state==0?1:0;
}
-(NSInteger)zoomInVideoPlayWindow:(NSInteger)state{
    
    //NSLog(@"zoomInVideoPlayWindow======state=%ld",state);
    if(mapZoomStateMAX || (!videoZoomStateMAX && state==1)){
        state=0;
        //[webVC reloadHtmlData];
    }
    //NSLog(@"zoomInVideoPlayWindow======state2=%ld",state);
    if(state==0){
        NSLog(@"state==0=========全屏模式");
       
        [[[_globalSplitView subviews] objectAtIndex:0] setFrame:NSMakeRect(0,0,1280,760)];
        [[[_globalSplitView subviews] objectAtIndex:1] setFrame:NSMakeRect(0,0,0,0)];
        //   [[[_globalSplitView subviews] objectAtIndex:2] setFrame:NSMakeRect(0,0,266,760)];
        
        //CGRect rect = [[NSScreen mainScreen] frame];
        CGFloat scalefactor = [[NSScreen mainScreen] backingScaleFactor];
        //NSLog(@"rect w = %f w= %f,scalefactor=%f",rect.size.width,rect.size.height,scalefactor);
        if(scalefactor == 2.0){
            [[[_leftSplitView subviews] objectAtIndex:0] setFrame:NSMakeRect(0,0,1280,760)];
        }else{
            [[[_leftSplitView subviews] objectAtIndex:0] setFrame:NSMakeRect(0,0,640,380)];
        }
        
        [[[_leftSplitView subviews] objectAtIndex:1] setFrame:NSMakeRect(0,0,0,0)];
        //[[[_leftSplitView subviews] objectAtIndex:1] setFrame:NSMakeRect(0,0,1280,220)];
        
        [[[_rightSplitView subviews] objectAtIndex:0] setFrame:NSMakeRect(0,0,0,0)];
        [[[_rightSplitView subviews] objectAtIndex:1] setFrame:NSMakeRect(0,0,0,0)];


        videoZoomStateMAX=YES;
        mapZoomStateMAX=NO;
        
    }else{
        NSLog(@"state==1=========非全屏模式");
        //NSLog(@"state==1=========");
        //modify by chenjian 去掉注释后，地图缩放比例就不变了
       // [webVC loadMapHTMLData:NO];
         [webVC reloadHtmlData];
        [[[_globalSplitView subviews] objectAtIndex:0] setFrame:NSMakeRect(0,0,1280,760)];//1014，760//840//1600,900//800
        [[[_globalSplitView subviews] objectAtIndex:1] setFrame:NSMakeRect(0,0,640,460)];//266
        //  [[[_globalSplitView subviews] objectAtIndex:2] setFrame:NSMakeRect(0,0,640,460)];
        //modify by chenjian
        CGFloat scalefactor = [[NSScreen mainScreen] backingScaleFactor];
        
        [[[_leftSplitView subviews] objectAtIndex:0] setFrame:NSMakeRect(0,0,1280,600)];
        [[[_leftSplitView subviews] objectAtIndex:1] setFrame:NSMakeRect(0,0,1280,160)];//220
        
        if (scalefactor == 2.0) {
            [[[_rightSplitView subviews] objectAtIndex:0] setFrame:NSMakeRect(0,0,600,320)];//460
        }else{
            [[[_rightSplitView subviews] objectAtIndex:0] setFrame:NSMakeRect(0,0,480,240)];//460
        }
        [[[_rightSplitView subviews] objectAtIndex:1] setFrame:NSMakeRect(0,0,680,440)];
        videoZoomStateMAX=NO;
        //modify by chenjian
        //mapZoomStateMAX=NO;

    }
    [_globalSplitView adjustSubviews];
    [_leftSplitView   adjustSubviews];
    [_rightSplitView  adjustSubviews];
    
    
    return state==0?1:0;
}
- (void)nssplitViewDivideInit:(NSSplitView *)splitView//反射

{
    
    unsigned int outCount, i;
  
    objc_property_t *properties = class_copyPropertyList([_leftSplitView class], &outCount);
    
    for (i = 0; i < outCount; i++) {
        
        objc_property_t property = properties[i];
        
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        if([splitView respondsToSelector:NSSelectorFromString(propertyName)]){
            
            if([propertyName isEqualToString:@"dividerColor"]){
                [splitView setValue:[NSColor clearColor] forKey:propertyName];
                
                NSLog(@"ok**** %@ --->%@",propertyName,[splitView valueForKey:propertyName]);
            }
            
        }
        
    }
    
    free(properties);
    
    
}

@end


