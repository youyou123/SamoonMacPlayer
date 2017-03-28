//
//  CVWebViewController.m
//  CoreVideo
//
//  Created by admin on 15/9/15.
//  Copyright (c) 2015年 yangyu   QQ：623240480. All rights reserved.
//

#import "CVWebViewController.h"
#import "MyCache.h"
#import "JSONKit.h"
#import "BDTransUtil.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "Reachability.h"
@interface CVWebViewController ()
{
    NSMutableArray *currentVideoGpsDataArr;
     NSMutableArray *currentVideoGpsDataArrGoogle;
    NSString       *currentPlayVideoPath;
    Float64         totalTime;
    BOOL  currentLocationChina;
    
    NSInteger zoomState;//0 放大  1 缩小
    NSTextField *textField;
    NSTextField *textFieldNoLine;
}

@end

@implementation CVWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
     默认加载百度地图（中国内）YES--百度地图  NO－Google地图
     */
    NSLog(@"webview---------------------");
    //currentLocationChina=YES;
    
    NSString* changeMAP=[[NSUserDefaults standardUserDefaults] objectForKey:@"change_map"];
    if([changeMAP isEqualToString:@"google"]){
        
        currentLocationChina=NO;
    
        
        
    }else {
        
    
        currentLocationChina=YES;
        
    }
        
   

    self.webview=[[WebView alloc] initWithFrame:self.view.bounds];
    
    
    
    self.webview.frameLoadDelegate=self;
    
    
    textField=[[NSTextField alloc] initWithFrame:NSMakeRect(49,5,150 ,22)];
    
    [textField setEditable:NO];
    [textField setBezeled:NO];
    [textField setBordered:NO];
    [textField setDrawsBackground:NO];
    [textField setSelectable:NO];
    [textField setHidden:NO];
    

    
    
    NSButton *current=[[NSButton alloc] initWithFrame:NSMakeRect(2, 55,100, 20)];
    
    NSButton *openstret=[[NSButton alloc] initWithFrame:NSMakeRect(2, 25,128, 20)];
    
    [current.cell setBezelStyle:NSRegularSquareBezelStyle];
    
    [current.cell setImageScaling:NSImageScaleProportionallyDown];
    
    [current setTarget:self];
    [current setTitle:@"Google Map"];
    [current setAction:@selector(currentAction:)];
    current.alphaValue=0.8f;
    [openstret.cell setBezelStyle:NSRegularSquareBezelStyle];
    
    [openstret.cell setImageScaling:NSImageScaleProportionallyDown];
    
    [openstret setTarget:self];
    [openstret setTitle:@"OpenStreet Map"];
    [openstret setAction:@selector(openStreetAction:)];
    openstret.alphaValue=0.8f;
    
    
    
    
    
    [self.view addSubview:_webview];
    //[_webview addSubview:current];
  //  [_webview addSubview:openstret];
  //  [self.view addSubview:zoomInOut];
    [self.view addSubview:textField];
    textFieldNoLine.translatesAutoresizingMaskIntoConstraints = NO;
    
    textFieldNoLine=[[NSTextField alloc] initWithFrame:NSMakeRect(40,0,300,180)];//show no internet state
    [textFieldNoLine setEditable:NO];
    
    [textFieldNoLine setBezeled:NO];
    [textFieldNoLine setBordered:NO];
    [textFieldNoLine setDrawsBackground:YES];
    [textFieldNoLine setSelectable:NO];
    [textFieldNoLine setHidden:YES];
     [self.view addSubview:textFieldNoLine];
    
    [self startInternetNotification];
    
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowFullScreenChange:) name:notification_full_screen object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeMapUI) name:@"change_map_notification" object:nil];

   
}
-(void)changeMapUI{
    NSLog(@"真是他妈的醉啦。。。。。。。。。。。。。。。。");
    NSString *map = [[NSUserDefaults standardUserDefaults] objectForKey:@"change_map"];
    

    

    
    if ([map isEqualToString:@"google"]) {
        if(currentLocationChina==YES){
            
            currentLocationChina=NO;
        }
        
        
        [self loadMapHTMLData:NO];
        
        
      
    }else {
        if(currentLocationChina==NO){
            
            currentLocationChina=YES;
        }
        [self loadMapHTMLData:YES];

       
    }

}


//谷歌切换
-(void)currentAction:(id)sender{

 
    [self loadMapHTMLData:NO];
    
    
}
//openStreet切换
-(void)openStreetAction:(id)sender{
    NSLog(@"OPENSTREET-----------------------");

    
    [self loadMapHTMLData:YES];
    
    
    
}
-(void)windowFullScreenChange:(NSNotification *)notification{
    
    [self reloadHtmlData];
    
}
-(void)dealloc{
  //  [[NSNotificationCenter defaultCenter] removeObserver:self name:notification_full_screen object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"change_map_notification" object:nil];
}

-(void)startInternetNotification{
    // Allocate a reachability object
    Reachability* reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    
    // Set the blocks
    reach.reachableBlock = ^(Reachability*reach)
    {
        // keep in mind this is called on a background thread
        // and if you are updating the UI it needs to happen
        // on the main thread, like this:
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reloadHtmlData];
            [textFieldNoLine setHidden:YES];
            [self.view addSubview:self.webview];

           // [textField setStringValue:NSLocalizedString(@"map_online",nil)];
        });
    };
    
    reach.unreachableBlock = ^(Reachability*reach)
    {
         [self reloadHtmlData];
        [textFieldNoLine setHidden:NO];
        [textFieldNoLine setTextColor:[NSColor whiteColor]];
        [textFieldNoLine  setBackgroundColor:[NSColor blackColor]];
        
        [textFieldNoLine setStringValue:NSLocalizedString(@"   Map not available, please check your,internet connection and / or select an alternative map from the , Setting menu.",nil)];//NSLocalizedString(@"map_offlineText",nil)
        
        @try {
            // 1
            [self.webview removeFromSuperview];
        }
        @catch (NSException *exception) {
            // 2
            NSLog(@"%s\n%@", __FUNCTION__, exception);
            //        @throw exception; // 这里不能再抛异常
        }
    };
    
    // Start the notifier, which will cause the reachability object to retain itself!
    [reach startNotifier];
}

-(void)zoomInOut:(id)sender{
    [self reloadHtmlData];
    zoomState=[self.zoomInOutDelegate zoomInMapWindow:zoomState];
}

-(void)reloadHtmlData{
    [self loadMapHTMLData:currentLocationChina];
}

-(void)loadMapHTMLData:(BOOL)locationInChina{
    NSString *mapHtml=@"OpenStreetMap.html";
    
    
    if(!locationInChina){
        mapHtml=@"google_map.html";
        
    }
    NSString *gpsPath=[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:mapHtml];
    
    
    
    NSString *htmlString = [NSString stringWithContentsOfFile:gpsPath encoding:NSUTF8StringEncoding error:nil];
    
 
   //  该种方式加载本地html数据可能会出现无法显示的奇怪问题
     
    // [[self.webview mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:gpsPath]]];

    
   // [[self.webview mainFrame]  loadHTMLString:htmlString baseURL:[NSURL URLWithString:gpsPath]];
 [[self.webview mainFrame]  loadHTMLString:htmlString baseURL:[[NSBundle mainBundle] resourceURL]];
    
    
    
  //  NSString *resourcePath = [ [NSBundle mainBundle] resourcePath];
   // NSString *filePath  = [resourcePath stringByAppendingPathComponent:mapHtml];
  //  NSString *htmlstring =[[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
  //  [self.webview loadHTMLString:htmlstring  baseURL:[NSURL fileURLWithPath: [[NSBundle mainBundle]  bundlePath]]];
   //  [[self.webview mainFrame]  loadHTMLString:htmlstring baseURL:[NSURL fileURLWithPath: [[NSBundle mainBundle]  bundlePath]]];
    
    
    
}


- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame{
    NSLog(@"didFinishLoadForFrame");

    JSContext *context=self.webview.mainFrame.javaScriptContext;
    
    __weak CVWebViewController *weakSelf = self;
    
    context[@"cocoa_getDistance"]=^(){
        NSArray *args=[JSContext currentArguments];
        JSValue *value=args[0];
        NSLog(@"当前距离是 : %f" ,value.toDouble);
        [weakSelf.distanceDelegate totalDistance:value.toDouble];
    };
   
    if(currentVideoGpsDataArr!=nil&&[currentVideoGpsDataArr count]>0){
        [_webview stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"drawPolyLinePath(%@)",[currentVideoGpsDataArr JSONString]]];
    }
    if(currentVideoGpsDataArrGoogle!=nil&&[currentVideoGpsDataArrGoogle count]>0){
        [_webview stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"drawPolyLinePath1(%@)",[currentVideoGpsDataArrGoogle JSONString]]];
    }
    
    
    
}
-(void)removeLineMap{
  [self.webview stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"removeLine()",0]];
}
-(void)updateDataByCurrentTime:(Float64)time{
    float m_ratio=1.0;
    if(totalTime>0){
        m_ratio= [currentVideoGpsDataArr count]/totalTime;
    }
    
    int index=(int)time*m_ratio;
    
    if(currentVideoGpsDataArr!=nil&&[currentVideoGpsDataArr count]>0){
        if(index<[currentVideoGpsDataArr count]){
            NSArray *xyItem=currentVideoGpsDataArr[index];
        //NSLog(@"--------------%@",[xyItem JSONString]);
            [self.webview stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"updateMarkerPosition(%@)",[xyItem JSONString]]];
        }
    }
        float m_ratio1=1.0;
    if(totalTime>0){
        m_ratio1= [currentVideoGpsDataArrGoogle count]/totalTime;
    }
     int index1=(int)time*m_ratio1;
    
      if(currentVideoGpsDataArrGoogle!=nil&&[currentVideoGpsDataArrGoogle count]>0){
        if(index<[currentVideoGpsDataArrGoogle count]){
            NSArray *xyItem=currentVideoGpsDataArrGoogle[index1];
            //NSLog(@"--------------%@",[xyItem JSONString]);
            [self.webview stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"updateMarkerPosition1(%@)",[xyItem JSONString]]];
        }
    }
    
    
}




-(void)videoAllTime:(Float64)allTime{
    totalTime=allTime;
}


-(void)dataLogicProcessOfViodePath:(NSString *)playVideoPath{
    [self.distanceDelegate totalDistance:0];
   
    
    currentPlayVideoPath=playVideoPath;
    
    NSLog(@"------------------pelaese see yolater");
   
    
    
    
    NSArray *gpsDataArr=[MyCache findGpsDatas:currentPlayVideoPath];
    
    currentVideoGpsDataArr=[NSMutableArray new];
     currentVideoGpsDataArrGoogle=[NSMutableArray new];
    [gpsDataArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        NSString *gps_lat=[obj objectForKey:@"gps_lat"];
        NSString *gps_lgt=[obj objectForKey:@"gps_lgt"];
        
        if(gps_lat.floatValue!=0&&gps_lgt.floatValue!=0){
            
         //   if(currentLocationChina){
                NSLog(@"OPENSTRRETmAP================");
                /*
                 直接使用
                 [currentVideoGpsDataArr addObject:[NSArray arrayWithObjects:[NSNumber numberWithFloat:gps_lgt.floatValue], [NSNumber numberWithFloat:gps_lat.floatValue],nil]];
                 以地球坐标转为百度坐标 *********
                 [currentVideoGpsDataArr addObject:[BDTransUtil wgs2bdLat:gps_lat.floatValue lgt:gps_lgt.floatValue]];
                 以火星坐标转为百度坐标
                 [currentVideoGpsDataArr addObject:[BDTransUtil gcj2bdLat:gps_lat.floatValue lgt:gps_lgt.floatValue]];
                 
                 */
                
            //    [currentVideoGpsDataArr addObject:[BDTransUtil wgs2bdLat:gps_lat.floatValue lgt:gps_lgt.floatValue]];
         
                
                [currentVideoGpsDataArr addObject:@[@(gps_lat.floatValue),@(gps_lgt.floatValue)]];
            
                 //  [self.webview stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"initMap()",0]];
                
                
        //    }else{
                 NSLog(@"gOOGLE_MAP===============");
                [currentVideoGpsDataArrGoogle addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:gps_lat.floatValue],@"lat",[NSNumber numberWithFloat:gps_lgt.floatValue],@"lng",nil]];
               //  [self.webview stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"initGoogleMap()",0]];
                  [self reloadHtmlData];
           // }
            
            
        }
        
        
        
    }];

            
    NSLog(@"*****count ::%ld****",[currentVideoGpsDataArr count]);
    [self.webview stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"drawPolyLinePath(%@)",[currentVideoGpsDataArr JSONString]]];
    
    NSLog(@"*****count ::%ld****",[currentVideoGpsDataArrGoogle count]);
    [self.webview stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"drawPolyLinePath1(%@)",[currentVideoGpsDataArrGoogle JSONString]]];
    



}
-(void)initFGoMap{//opnes
    [self.webview stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"initMap()",0]];
    [self reloadHtmlData];
}

@end
