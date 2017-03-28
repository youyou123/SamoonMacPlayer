//
//  Abo/Users/samoon/Downloads/RECORDERMACPLAY/2016.11.25LATEST_VERSION/最新款_recoder_pLAYER/samoon_version_palyer/CoreVideo /CoreVideo/PreferenceController.hutWindowView.m
//  CoreVideo
//
//  Created by samoon on 2017/3/23.
//  Copyright © 2017年 yuyang    QQ:623240480. All rights reserved.
//

#import "AboutWindowView.h"

@interface AboutWindowView ()
@property (strong) IBOutlet NSTextField *shouVersion;

@end

@implementation AboutWindowView

- (void)windowDidLoad {
    [super windowDidLoad];
    [self.window setTitle:NSLocalizedString(@"About",nil)];
    
     [[self.window standardWindowButton:NSWindowZoomButton] setHidden:YES];
     [[self.window standardWindowButton:NSWindowMiniaturizeButton] setHidden:YES];
    
    NSString *version=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [self.window setBackgroundColor:[NSColor blackColor]];
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    NSString *message=[NSString stringWithFormat:@"Cardv Player:MPH&KMH Version %@",version];//build
    
    _shouVersion.stringValue=message;
}
-(NSString *)windowNibName{
    return @"AboutWindowView";
}

@end
