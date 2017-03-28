//
//  AppDelegate.m
//  CoreVideo
//
//  Created by admin on 15/9/11.
//  Copyright (c) 2015年 yangyu   QQ：623240480. All rights reserved.
//

#import "AppDelegate.h"
#import "VideoViewController.h"
#import "MyCache.h"
#import "AppUserDefaults.h"
@interface AppDelegate ()



@end
//更新数据
@implementation AppDelegate

NSString *tutvideos=@"http://www.nextbase.co.uk/412GWtutvideo";
NSString *websites=@"http://www.nextbase.co.uk/";
NSString *shopsites=@"http://www.nextbaseshop.co.uk";
NSString  *SPEED_UNIT_NOTIFICATIONS=@"speed_unit_notification";
NSString  *CHANGE_MAP_NOTIFICATIONS=@"change_map_notification";


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    
    
    //NSLog(@"applicationDidFinishLaunching...");
    // [self.spdkmh setImage:[NSImage imageNamed:@"lock"]];
    
    
    [MyCache playPathClear];
    
    
    
    // [[NSUserDefaults standardUserDefaults] setObject:KMPH forKey:@"speed_unit"];
    NSString* speedUNIT=[[NSUserDefaults standardUserDefaults] objectForKey:@"speed_unit"];
    if([speedUNIT isEqualToString:MILEPH]){
        NSLog(@"speedunit--------------%@",speedUNIT);
        [AppUserDefaults setSpeedUnit:MILEPH];//MILEPH
        
        [_menuitemmph setState:1];
        [_spdkmh setState:0];
       
        
    }else if([speedUNIT isEqualToString:KMPH]){
        NSLog(@"speedunit--------------%@",speedUNIT);
        
        [AppUserDefaults setSpeedUnit:KMPH];//MILEPH
        
        [_menuitemmph setState:0];
        [_spdkmh setState:1];
        
        
    }else{
        NSLog(@"speedunit--------------%@",speedUNIT);
        
        [AppUserDefaults setSpeedUnit:KMPH];
        
        [_menuitemmph setState:0];
        [_spdkmh setState:1];
    }
    NSString* changeMAP=[[NSUserDefaults standardUserDefaults] objectForKey:@"change_map"];
    if([changeMAP isEqualToString:GOOGLE]){
       
        [AppUserDefaults setChangeMap:GOOGLE];//MILEPH
        
        [_googleMapsItem setState:1];
        [_openstreetItem setState:0];
        
        
    }else{
        
        [AppUserDefaults setChangeMap:STREET];
        
        [_googleMapsItem setState:0];
        [_openstreetItem setState:1];
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:SPEED_UNIT_NOTIFICATIONS object:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:CHANGE_MAP_NOTIFICATIONS object:nil];
    
    
}




- (BOOL)applicationShouldOpenUntitledFile:(NSApplication *)sender{
    //NSLog(@"applicationShouldOpenUntitledFile");
    return YES;
}
- (BOOL)applicationOpenUntitledFile:(NSApplication *)sender{
    //NSLog(@"applicationOpenUntitledFile");
    return YES;
}


-(BOOL)application:(NSApplication *)sender openFile:(NSString *)filename{
    //NSLog(@"filename %@",filename);
    return YES;
}
//-(IBAction)showHelp:(id)sender{
//    NSString *version=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//    NSString *build=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
//
//    NSString *appName=NSLocalizedStringFromTable(@"CFBundleDisplayName",@"InfoPlist", nil);
//
//   // NSString *message=[NSString stringWithFormat:@"Version %@(Build %@)",version,build];
////     NSString *message=@"DKHSFKSFKDKFKFLLSDFDLFLFDLGFLDGLKJKLFDGJKL KLGFDJLKJG   FGLDGJFDGLFKGJLGJLJKLFKGDFK;KDKFK;FKD;K;KD;K";
// NSString *message=@"NEXTBASE Replay 2: mph Version 1.8\n\nThank you for purchasing a NEXTBASE Dash Cam.\n\nThis playback software has been specifically designed for use with your dash cam and allows playback of the recorded video whilst showing your position upon the map.\nPortable Multimedia Ltd.All Rights Reserved.www.nextbase.co.uk\nCopyright:\nThe NEXTBASE Replay application is protected by copyright laws.Any unauthorized use of these materials may violate copyright,trademark or other laws.Piracy of Products is considered a serious offence and will be pursued to the fullest extent of the law.";
//    NSRunAlertPanel(appName, message,
//                                 nil, nil,nil);
//
//
//}




- (IBAction)showversion:(id)sender {
    NSString *version=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *build=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    
    NSString *appName=@"Cardv Player:";//NSLocalizedStringFromTable(@"CFBundleDisplayName",@"InfoPlist", nil);
    
    NSString *message=[NSString stringWithFormat:@"Version %@",version];//build
    
    NSRunAlertPanel(appName, message,@"OK", nil,nil);
    
}

- (IBAction)openFile:(id)sender {
    
    __weak AppDelegate *weakSelf=self;
    [[NSDocumentController sharedDocumentController] beginOpenPanelWithCompletionHandler:^(NSArray *fileList) {
        if(fileList!=nil){
            
            
            //NSLog(@"%@",fileList);
            [weakSelf.videoVC close];
            if(fileList!=nil&&[fileList count]>0){
                NSURL *fisrtUrl=[fileList objectAtIndex:0];
                
                [MyCache playPathArrCache:fileList block:^{
                    
                    [weakSelf activeCurrentPlayFile:[fisrtUrl absoluteString]];
                    
                    [weakSelf.videoVC initAssetData:fisrtUrl];
                    
                    [weakSelf.playlistVC reloadPlayListData];
                    
                }];
            }
            
        }
        
    }];
}

- (IBAction)watchvideo:(id)sender {
    
    NSURL * url = [NSURL URLWithString:tutvideos];
    
    
    
    [[NSWorkspace sharedWorkspace] openURL:url];
    
}

- (IBAction)visitwebsite:(id)sender {
    NSURL * url = [NSURL URLWithString:websites];
    
    
    
    [[NSWorkspace sharedWorkspace] openURL:url];
}

- (IBAction)visitshop:(id)sender {
    NSURL * url = [NSURL URLWithString:shopsites];
    
    
    
    [[NSWorkspace sharedWorkspace] openURL:url];
}

- (IBAction)tutorialvideo:(id)sender {
    NSURL * url = [NSURL URLWithString:tutvideos];
    
    
    
    [[NSWorkspace sharedWorkspace] openURL:url];
    
}

- (IBAction)visitabout:(id)sender {
    NSString *version=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *build=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    
    NSString *appName=NSLocalizedStringFromTable(@"CFBundleDisplayName",@"InfoPlist", nil);
    
    // NSString *message=[NSString stringWithFormat:@"Version %@(Build %@)",version,build];
    //     NSString *message=@"DKHSFKSFKDKFKFLLSDFDLFLFDLGFLDGLKJKLFDGJKL KLGFDJLKJG   FGLDGJFDGLFKGJLGJLJKLFKGDFK;KDKFK;FKD;K;KD;K";
    NSString *message=@"NEXTBASE Replay 2: MPH Version 4.9\n\nThank you for purchasing a NEXTBASE Dash Cam.\n\nThis playback software has been specifically designed for use with your dash cam and allows playback of the recorded video whilst showing your position upon the map.\n\nPortable Multimedia Ltd.\nAll Rights Reserved.\nwww.nextbase.co.uk\n\nCopyright:\nThe NEXTBASE Replay application is protected by copyright laws. Any unauthorized use of these materials may violate copyright, trademark or other laws. Piracy of Products is considered a serious offence and will be pursued to the fullest extent of the law.";
    //        All Rights Reserved.
    //        www.nextbase.co.uk";
    //    This playback software has been specifically designed for use with your dash cam and allows playback of the recorded video whilst showing your position upon the map.
    //
    //        Portable Multimedia Ltd.
    //        All Rights Reserved.
    //        www.nextbase.co.uk
    //
    //        Copyright:
    //        The NEXTBASE Replay application is protected by copyright laws. Any unauthorized use of these materials may violate copyright, trademark or other laws. Piracy of Products is considered a serious offence and will be pursued to the fullest extent of the law.
    
    NSRunAlertPanel(appName, message, @"Close", nil,nil);
}

- (IBAction)website:(id)sender {
    
    //NSLog(@"AppDelegate website=%@",sender);
    NSURL * url = [NSURL URLWithString:websites];
    [[NSWorkspace sharedWorkspace] openURL:url];
}

- (IBAction)shop:(id)sender {
    
    NSURL * url = [NSURL URLWithString:shopsites];
    
    
    
    [[NSWorkspace sharedWorkspace] openURL:url];
}



- (IBAction)mphspd:(id)sender {
    NSLog(@"mphspd========");
    [_menuitemmph setState:1];
    [_spdkmh setState:0];
    [AppUserDefaults setSpeedUnit:MILEPH];
    [[NSUserDefaults standardUserDefaults] setObject:MILEPH forKey:@"speed_unit"];
    [[NSNotificationCenter defaultCenter] postNotificationName:SPEED_UNIT_NOTIFICATIONS object:nil];
    
 
    
    
    
}


- (IBAction)kmhspd:(id)sender {
    NSLog(@"kmhspd=======");
    [_menuitemmph setState:0];
    [_spdkmh setState:1];
  [AppUserDefaults setSpeedUnit:KMPH];
    [[NSUserDefaults standardUserDefaults] setObject:KMPH forKey:@"speed_unit"];
   
    [[NSNotificationCenter defaultCenter] postNotificationName:SPEED_UNIT_NOTIFICATIONS object:nil];
    
    
}
//set map change
- (IBAction)googleAction:(id)sender {
    [_openstreetItem setState:0];
    [_googleMapsItem setState:1];
    [AppUserDefaults setSpeedUnit:GOOGLE];
    
    [[NSUserDefaults standardUserDefaults] setObject:GOOGLE forKey:@"change_map"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:CHANGE_MAP_NOTIFICATIONS object:nil];

}

- (IBAction)openstreetAction:(id)sender {
    [_openstreetItem setState:1];
    [_googleMapsItem setState:0];
    [AppUserDefaults setSpeedUnit:STREET];
    
    [[NSUserDefaults standardUserDefaults] setObject:STREET forKey:@"change_map"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:CHANGE_MAP_NOTIFICATIONS object:nil];
}








-(void)activeCurrentPlayFile:(NSString *)filePath{
    NSArray *playList=[[NSUserDefaults standardUserDefaults] objectForKey:key_play_list];
    
    NSMutableArray *newPlayList=[NSMutableArray new];
    for (int i=0; i<[playList count];i++) {
        
        
        NSMutableDictionary *dic=[playList[i] mutableCopy];
        [dic setObject:[NSNumber numberWithBool:NO] forKey:keyActiveYN];
        
        [newPlayList addObject:dic];
        
    }
    
    for (int i=(int)[playList count]-1; i>=0;i--) {
        
        if([filePath isEqualToString:[playList[i] objectForKey:keyPATH]]){
            
            NSMutableDictionary *dic=[playList[i] mutableCopy];
            [dic setObject:[NSNumber numberWithBool:YES] forKey:keyActiveYN];
            
            [newPlayList replaceObjectAtIndex:i withObject:dic];
            
            break;
        }
        
        
    }
    [[NSUserDefaults standardUserDefaults] setObject:newPlayList forKey:key_play_list];
    
}
-(void)activeCurrentPlayIndex:(int)index{
    NSArray *playList=[[NSUserDefaults standardUserDefaults] objectForKey:key_play_list];
    
    NSMutableArray *newPlayList=[NSMutableArray new];
    for (int i=0; i<[playList count];i++) {
        
        
        NSMutableDictionary *dic=[playList[i] mutableCopy];
        [dic setObject:[NSNumber numberWithBool:NO] forKey:keyActiveYN];
        
        [newPlayList addObject:dic];
        
    }
    
    for (int i=0;i<[playList count];i++) {
        
        if(i==index){
            NSMutableDictionary *dic=[playList[i] mutableCopy];
            [dic setObject:[NSNumber numberWithBool:YES] forKey:keyActiveYN];
            
            [newPlayList replaceObjectAtIndex:i withObject:dic];
            
            break;
        }
        
        
    }
    [[NSUserDefaults standardUserDefaults] setObject:newPlayList forKey:key_play_list];
    //modify by chenjian
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}





- (BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag{
    
    if(!flag){
        //NSLog(@"applicationShouldHandleReopen flag:%d",flag);
        [self.windowVC showWindow:self];
    }
    return flag;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
    //NSLog(@"applicationWillTerminate...");
}




@end
