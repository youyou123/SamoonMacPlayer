//
//  PlayListViewController.m
//  CoreVideo
//
//  Created by admin on 15/9/14.
//  Copyright (c) 2015年 yangyu   QQ：623240480. All rights reserved.
//

#import "PlayListViewController.h"
#import "MyCache.h"
#import "AppUtils.h"
#import "AppDelegate.h"
#import "AppColorManager.h"
#import "AppUserDefaults.h"

#define BasicTableViewDragAndDropDataType @"BasicTableViewDragAndDropDataType"

@interface PlayListViewController (){
    NSInteger selectIndex;
    //gps
    NSMutableArray *currentVideoGpsDataArr;
    NSString       *currentPlayVideoPath;
    Float64         totalTime;
    //gps
    //spd
    NSMutableArray *currentSpeedDataArr;
    //spd
    //modify by chenjain
    //float rotateAngle_v;
    float spd_show_v;
    
}

//@property (weak) IBOutlet NSTableView *tableView;
- (IBAction)addVideoPlay:(id)sender;
- (IBAction)removeVideoPlay:(id)sender;

@property (weak) IBOutlet NSTableHeaderView *headerView;
@property (weak) IBOutlet NSScrollView *tableContainer;

@property (weak) IBOutlet NSButton *buttonAdd;
@property (weak) IBOutlet NSButton *buttonRemove;
//headertitle
@property (weak) IBOutlet NSView *listheadColor;

@property(nonatomic,strong) NSMutableArray *playlist;
//==================north  lal
@property (weak) IBOutlet NSImageView *northAngleImageViews;
//@property (weak) IBOutlet NSTextField *stillImageViews;
@property (weak) IBOutlet NSImageView *stillImageViewss;

@property (weak) IBOutlet NSTextField *latitudeLabels;
@property (weak) IBOutlet NSTextField *latitudeUnitLabels;
@property (weak) IBOutlet NSTextField *longitudeUnitLabels;
@property (weak) IBOutlet NSTextField *longitudeLabels;

//==================north  lal
//spd
@property (weak) IBOutlet NSImageView *spdArrowChange;
@property (weak) IBOutlet NSTextField *spdshow;
@property (weak) IBOutlet NSImageView *spdImage;

//spd
//scrow
@property (weak) IBOutlet NSScrollView *fileScrollView;

//scrow

@end
NSTableView *tableView;
//NSScrollView * fileScrollView;
@implementation PlayListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setWantsLayer:YES];
   // [self.buttonAdd  setTitle:@"ADD FILES"];
   // [self.buttonRemove  setTitle:@"REMOVE FILES"];
    [self setButtonColor:_buttonAdd andColor:[NSColor greenColor]];
    [self setButtonColor:_buttonRemove andColor:[NSColor redColor]];
    
    self.latitudeLabels.hidden=YES;
    self.latitudeUnitLabels.hidden=YES;
    self.longitudeLabels.hidden=YES;
    self.longitudeUnitLabels.hidden=YES;
    
    
    
    
    
   // [self.listheadColor.layer setBackgroundColor:[[NSColor whiteColor] CGColor]];

    // [self.listheadColor.layer setBackgroundColor:[[NSColor whiteColor] CGColor]];
    
    
      //NSScrollView * tableContainer = [[NSScrollView alloc] init];//2828self.spdImage.frame.size.height//
    //NSLog(@"PlayListViewController %f;;;;;;;;%f:;;;%@;;;;%@",self.view.frame.size.width-28,nil,nil);
    tableView = [[NSTableView alloc] init];//WithFrame:NSMakeRect(0,0, self.view.frame.size.width-40, 140)
    // create tableview style
    //设置水平，坚直线
    [tableView setGridStyleMask:NSTableViewSolidVerticalGridLineMask | NSTableViewSolidHorizontalGridLineMask];
    //线条色
    [tableView setGridColor:[AppColorManager appBackgroundColor]];
 //   NSImage  *norImage=[NSImage imageNamed:@"listcs"];//defautImage listbackgound1
  

    //设置背景色
  //  [_tableContainer setBackgroundColor:[NSColor colorWithPatternImage:norImage]];
    [tableView setBackgroundColor:[NSColor clearColor]];//[NSColor colorWithPatternImage:norImage]
    //设置每个cell的换行模式，显不下时用...
    // [[_tableView cell]setLineBreakMode:NSLineBreakByTruncatingTail];
    // [[_tableView cell]setTruncatesLastVisibleLine:YES];
    
    [tableView sizeLastColumnToFit];
    [tableView setColumnAutoresizingStyle:NSTableViewUniformColumnAutoresizingStyle];
    
    
    
    //[tableView setAllowsTypeSelect:YES];
    //设置允许多选
    [tableView setAllowsMultipleSelection:NO];
    
    [tableView setAllowsExpansionToolTips:YES];
    [tableView setAllowsEmptySelection:YES];
    [tableView setAllowsColumnSelection:YES];
    [tableView setAllowsColumnResizing:YES];
    [tableView setAllowsColumnReordering:YES];
    //双击
    //    [tableView setDoubleAction:@selector(ontableviewrowdoubleClicked:)];
    //    [tableView setAction:@selector(ontablerowclicked:)];
    
    //选中高亮色模式
    //显示背景色
    [tableView setSelectionHighlightStyle:NSTableViewSelectionHighlightStyleRegular];
    //
    //会把背景色去掉
    //[tableView setSelectionHighlightStyle:NSTableViewSelectionHighlightStyleSourceList];
    //NSTableViewSelectionHighlightStyleNone
    
    //不需要列表头
    //使用隐藏的效果会出现表头的高度
    //[tableView.headerView setHidden:YES];
    
    // create columns for our table
    
    NSTableColumn * column1 = [[NSTableColumn alloc] initWithIdentifier:@"col1"];
    [column1.headerCell setTitle:@"No."];
    
    
    
    //[column1 setResizingMask:NSTableColumnAutoresizingMask];
    //  [column1.headerCell setEnabled:NO];
    NSTableColumn * column2 = [[NSTableColumn alloc] initWithIdentifier:@"col2"];
    // [column2.headerCell setEnabled:NO];
    [column2.headerCell setTitle:@"Filename"];
    //[column2 setResizingMask:NSTableColumnAutoresizingMask];
    //modify by chenjian
    [column2 setEditable:YES];
    
    
    
    NSTableColumn * column3 = [[NSTableColumn alloc] initWithIdentifier:@"col3"];
    [column3.headerCell setTitle:@"Time & Date"];
    // [column3.headerCell setEnabled:NO];
    NSTableColumn * column4 = [[NSTableColumn alloc] initWithIdentifier:@"col4"];
    [column4.headerCell setTitle:@"Protected"];
    //[column4.headerCell setEnabled:NO];
    [column1 setWidth:25];
    [column2 setWidth:130];
    [column3 setWidth:110];
    [column4 setWidth:70];
    // generally you want to add at least one column to the table view.
    
    [tableView addTableColumn:column1];
    [tableView addTableColumn:column2];
    [tableView addTableColumn:column3];
    [tableView addTableColumn:column4];
    AppDelegate *delegate=[[NSApplication sharedApplication] delegate];
    delegate.playlistVC=self;
    self.playlist=[NSMutableArray new];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    
    // embed the table view in the scroll view, and add the scroll view to our window.
    [_tableContainer setDocumentView:tableView];
    [_tableContainer setHasVerticalScroller:YES];
    [_tableContainer setHasHorizontalScroller:YES];
    _tableContainer.translatesAutoresizingMaskIntoConstraints = NO;
    tableView.translatesAutoresizingMaskIntoConstraints = YES;
    //[self.view addSubview:_tableContainer];
    
    //logoImageView左侧与父视图左侧对齐
    NSLayoutConstraint* leftConstraint = [NSLayoutConstraint constraintWithItem:_tableContainer attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:9.0f];
    
    //logoImageView右侧与父视图右侧对齐
    NSLayoutConstraint* rightConstraint = [NSLayoutConstraint constraintWithItem:_tableContainer attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:0.97f constant:0.0f];
    
    //logoImageView顶部与父视图顶部对齐
    NSLayoutConstraint* topConstraint = [NSLayoutConstraint constraintWithItem:_tableContainer attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:4.0f];
    
    //logoImageView高度为父视图高度一半
    NSLayoutConstraint* heightConstraint = [NSLayoutConstraint constraintWithItem:_tableContainer attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:0.4f constant:0.0f];
    
    
    leftConstraint.active = YES;
    rightConstraint.active = YES;
    topConstraint.active = YES;
    heightConstraint.active = YES;
    ////===========
    NSLayoutConstraint* leftConstraint1 = [NSLayoutConstraint constraintWithItem:_tableContainer attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_tableContainer attribute:NSLayoutAttributeLeading multiplier:1.0f constant:9.0f];
    
    //logoImageView右侧与父视图右侧对齐
    NSLayoutConstraint* rightConstraint1 = [NSLayoutConstraint constraintWithItem:_tableContainer attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_tableContainer attribute:NSLayoutAttributeTrailing multiplier:0.70f constant:10.0f];
    
    //logoImageView顶部与父视图顶部对齐
    NSLayoutConstraint* topConstraint1 = [NSLayoutConstraint constraintWithItem:_tableContainer attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_tableContainer attribute:NSLayoutAttributeTop multiplier:1.0f constant:4.0f];
    
    //logoImageView高度为父视图高度一半
    NSLayoutConstraint* heightConstraint1 = [NSLayoutConstraint constraintWithItem:_tableContainer attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_tableContainer attribute:NSLayoutAttributeHeight multiplier:0.4f constant:0.0f];
    
    
    leftConstraint1.active = YES;
    rightConstraint1.active = YES;
    topConstraint1.active = YES;
    heightConstraint1.active = YES;
    //=============
    
    
    selectIndex=-1;

  //  widthConstraint.active=YES;
 //  [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
       //selectIndex=-1;
    
    //modify by chenjian
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI) name:@"speed_unit_notification" object:nil];
    //更新指南针和速度
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCompass:) name:@"compass_notification" object:nil];
  //  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeMapUI) name:@"change_map_notification" object:nil];

    
     [tableView registerForDraggedTypes:@[BasicTableViewDragAndDropDataType]];
    
}

-(void)updateCompass:(NSNotification *)notification
{
    NSLog(@"收到更新指南针通知========");
    float rotateAngle_v = [[[NSUserDefaults standardUserDefaults] objectForKey:@"rotateAngle_v"] floatValue];
    float rotateSpd_v = [[[NSUserDefaults standardUserDefaults] objectForKey:@"rotateSpd_v"] floatValue];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self rotateAngle:rotateAngle_v];
        [self rotateSpd:rotateSpd_v];
    });
    //[self.view setNeedsDisplay:YES];
    //NSLog(@"角度=%f=速度==%f",rotateAngle_v,rotateSpd_v);
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"speed_unit_notification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"compass_notification" object:nil];
}

-(void)updateUI
{
    //NSLog(@"更新UI playList updateUI=====");
    NSString *spd = [[NSUserDefaults standardUserDefaults] objectForKey:@"speed_unit"];
    
    NSLog(@"updateUI spd_show_v=%f",spd_show_v);
    
    [self.spdshow setStringValue:[AppUtils convertSpeedUnit:spd_show_v]];
    //self.spdshow.layer.borderWidth = 0.0;
    
    if (![spd isEqualToString:@"kmph"]) {
        [self.spdImage  setImage:[NSImage imageNamed:@"2"]];
        [self.spdArrowChange setImage:[NSImage imageNamed:@"arrownew"]];
    }else{
        [self.spdImage  setImage:[NSImage imageNamed:@"412kmh"]];
         [self.spdArrowChange setImage:[NSImage imageNamed:@"arrownewkmh"]];
        //self.spdImage.layer.borderWidth = 0.0;
        //[self.spdImage  setImage:[NSImage imageNamed:@"spdimage"]];
    }
    
    
}

- (IBAction)addVideoPlay:(id)sender {
 
    [[NSDocumentController sharedDocumentController] beginOpenPanelWithCompletionHandler:^(NSArray *fileList) {
   //201703024
        if(fileList!=nil&&[fileList count]>0){
           
                [MyCache playPathArrCache:fileList block:^{
                [self reloadPlayListData];
                //如果有数据，默认选中第一行并请求第一行的数据
                 //modify by chenjian
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"addVideoPlay filelist-------\\\\--%d",[_playlist count]);
                      
                        [tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:[_playlist count]-1] byExtendingSelection:NO];
                        [self selectIndexPlay:[_playlist count]-1];
                    });
                    
                
                  
                    //[self selectIndexPlay:0];
                    [tableView setTarget:self];
                    [tableView setHighlighted:YES];
                    
                                      }];
      
        }

        
        
        
    }];
 
    
    
}

- (IBAction)removeVideoPlay:(id)sender {
    //NSLog(@"removeVideoPlay selectIndex : %ld",selectIndex);
    if(_playlist!=nil){
        
        if(selectIndex>=0&&selectIndex<[_playlist count]){
            
            [_playlist removeObjectAtIndex:selectIndex];
             selectIndex=-1;
            [MyCache syncPlayList:_playlist];
            
            AppDelegate *delegate=[[NSApplication sharedApplication] delegate];
            [delegate.videoVC close];
        }
        //        if (selectIndex<0) {
        //            [MyCache  playPathClear];
        //        }//delete all files
        [self reloadPlayListData];
        
        [tableView deselectAll:self];
        
        //modify by chenjian
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //[tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:[fileList count]-1] byExtendingSelection:NO];
            [tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:selectIndex] byExtendingSelection:NO];
        });
        
        
        //[self selectIndexPlay:[_playlist count]-1];
        // modify by chenjian
        if (_playlist.count>0) {
            [self selectIndexPlay:0];
            [tableView setTarget:self];
            [tableView setHighlighted:YES];
        }
        
        
    }
   
}


-(void)reloadPlayListData{
    
    //NSLog(@"reloadPlayListData========");
    self.playlist=[[MyCache playList] mutableCopy];
  
    [tableView reloadData];
    
    
}



- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    if(_playlist!=nil){
        return [_playlist count];
    }else{
        return 0;
    }
    
}


- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    //    if(_playlist!=nil){
    //        NSString *abbrev=[NSString stringWithFormat:@"%ld |     %@",row,[self abbreviationFile:[[_playlist objectAtIndex:row] objectForKey:keyPATH]]];
    //
    //        NSNumber *activeYN=[[_playlist objectAtIndex:row] objectForKey:keyActiveYN];
    //
    //
    //        if(activeYN!=nil&&[activeYN boolValue]==YES){
    //            [tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:NO];
    //            selectIndex=row;
    ////           [_tableView.cell setBackgroundColor:[NSColor redColor
    ////                                                ]];
    //
    //        }
    //
    //        return [abbrev stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //    }else{
    //        return @"";
    //    }
    return nil;
}
//    //http://blog.csdn.net/yepeng2014/article/details/49026773
//}


-(NSString *)abbreviationFile:(NSString *)path{
    
    return [path lastPathComponent];
}


- (NSIndexSet *)tableView:(NSTableView *)tableView selectionIndexesForProposedSelection:(NSIndexSet *)proposedSelectionIndexes NS_AVAILABLE_MAC(10_5){
    
    
    selectIndex=proposedSelectionIndexes.firstIndex;
    
    
    [self selectIndexPlay:selectIndex];
    
    return proposedSelectionIndexes;
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectTableColumn:(NSTableColumn *)tableColumn{
    return YES;
}

//
-(NSView*)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSString *iden = [ tableColumn identifier ];
    NSView *cellView=[[NSView alloc]initWithFrame:CGRectMake(0, 0, 30, 18)];
     NSImageView  *view=[[NSImageView alloc]initWithFrame:CGRectMake(12, 0, 30, 15)];
    NSString  *filePath=[[_playlist objectAtIndex:row] objectForKey:keyPATH];
    NSString *path = [filePath stringByReplacingOccurrencesOfString:@"file://" withString:@""];//字符串替换
    NSString  *dataItem=[self abbreviationFile:[[_playlist objectAtIndex:row] objectForKey:keyPATH]];
   //NSColor *textbgColor=[NSColor colorWithCalibratedRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    NSImage  *imagep=[NSImage imageNamed:@"15"];
    NSString *abbrev=[NSString stringWithFormat:@"%ld%@",row+1,@""];
    if ([iden isEqualToString:@"col4"]) {

        NSFileManager *fileManager = [NSFileManager defaultManager];
        //NSLog(@"tableView --viewForTableColumn-COL4:%@",path);
        //文件是否可写
        if ([fileManager isReadableFileAtPath:path]&&[fileManager isWritableFileAtPath:path]) {
            //NSLog(@"Readable");//fileManager isWritableFileAtPath:path]
           
        }else{
            [view setImage:imagep];
            [cellView addSubview:view];
        }
        
    }
    if ([iden isEqualToString:@"col3"]) {
        NSTextField *textField=[[NSTextField alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
        if (dataItem!=nil) {
            NSString *time = [dataItem stringByReplacingOccurrencesOfString:@".MOV" withString:@""];//字符串替换
            NSString *timeItem = [time stringByReplacingOccurrencesOfString:@"_" withString:@""];
            if ([timeItem length]>=14) {
                NSString    *item = [timeItem substringToIndex:14];//截取掉下标7之后的字符串
              
         
                NSString* yy=[item substringToIndex:4];//
              
                NSRange rang1={4,2};//截取dd
                NSString* MM=[item substringWithRange:rang1];//
              
                NSRange rang2={6,2};//截取dd
                NSString* dd=[item substringWithRange:rang2];//
                
                NSRange rang3={8,2};//截取hh
                NSString*hh =[item substringWithRange:rang3];//
                
                NSRange rang4={10,2};//截取mm
                NSString* mm=[item substringWithRange:rang4];//
               
                NSRange rang5={12,2};//截取ss
                NSString* ss=[item substringWithRange:rang5];//
            
                
                NSString* riqi=[[[[dd stringByAppendingString:@"/"]
                                  stringByAppendingString:MM]
                                 stringByAppendingString:@"/"]
                                stringByAppendingString:yy];
                NSString* hhmmss=[[[[hh stringByAppendingString:@":"]
                                  stringByAppendingString:mm]
                                 stringByAppendingString:@":"]
                                stringByAppendingString:ss];
                 NSString *showtime=[NSString stringWithFormat:@"%@ %@",hhmmss,riqi];
                
                [textField.cell setBordered:NO];
                [textField.cell  setBackgroundColor:[NSColor  clearColor]];
                [textField.cell  setTextColor:[NSColor blackColor]];
                [textField.cell setTitle:showtime];
                [textField.cell setEnabled:NO];
                
                [cellView addSubview:textField];
            }
        }
        
        
    }
    if ([iden isEqualToString:@"col2"]) {
        NSTextField *textField=[[NSTextField alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
        
        [textField.cell setTitle:dataItem];
    
         [textField.cell setBordered:NO];
        [textField.cell  setBackgroundColor:[NSColor  clearColor]];
        [textField.cell  setTextColor:[NSColor blackColor]];
        

       [textField.cell setEnabled:NO];
        [cellView addSubview:textField];
        
    }
    if ([iden isEqualToString:@"col1"]) {
       
        NSTextField *textField=[[NSTextField alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
        [textField.cell setTitle:abbrev];
        
      
        [textField.cell setBordered:NO];
        [textField.cell  setBackgroundColor:[NSColor  clearColor]];
          [textField.cell  setTextColor:[NSColor blackColor]];
        [textField.cell setEnabled:NO];
        [cellView addSubview:textField];
        
    }
    //    NSTextField *textField=[[NSTextField alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    //
    //    textField.textColor=[NSColor blackColor];
    //    if(_playlist!=nil){
    //        NSString *abbrev=[NSString stringWithFormat:@"%ld%@,row,@""];
    //
    //
    //          NSTableColumn *column=[[NSTableColumn alloc] initWithIdentifier:@"column"];
    //          [[column ] setStringValue:@"column"];

    return cellView;
    
}


-(BOOL)tableView:(NSTableView *)tableView acceptDrop:(id<NSDraggingInfo>)info row:(NSInteger)row dropOperation:(NSTableViewDropOperation)dropOperation
{
    NSPasteboard* pboard = [info draggingPasteboard];
    NSData* rowData = [pboard dataForType:BasicTableViewDragAndDropDataType];
    NSIndexSet* rowIndexes = [NSKeyedUnarchiver unarchiveObjectWithData:rowData];
    NSInteger dragRow = [rowIndexes firstIndex];
    
    
    return YES;
}


- (BOOL)tableView:(NSTableView *)aTableView writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard *)pboard
{
    NSLog(@"writeRowsWithIndexes ");
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:rowIndexes];
    [pboard declareTypes:@[BasicTableViewDragAndDropDataType] owner:self];
    [pboard setData:data forType:BasicTableViewDragAndDropDataType];
    return YES;
}

- (NSDragOperation)tableView:(NSTableView*)tv validateDrop:(id <NSDraggingInfo>)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)op
{
    return NSDragOperationEvery;
}


-(void)playNext:(BOOL)isNext{
    if(isNext){
        selectIndex++;
    }else{
        selectIndex--;
    }
    
    [self selectIndexPlay:selectIndex];
    
}
-(void)selectIndexPlay:(NSInteger)index{
    //NSLog(@"selectIndexPlay--------------%ld",index);
    if(index<[_playlist count]){
        //modify by chenjian
        selectIndex = index;
        dispatch_async(dispatch_get_main_queue(), ^{
            [tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:selectIndex] byExtendingSelection:NO];
        });
       
        [self playCurrentItem:[[_playlist objectAtIndex:index] objectForKey:keyPATH]];
        
        AppDelegate *delegate=[[NSApplication sharedApplication] delegate];
        [delegate activeCurrentPlayIndex:(int)index];
        [tableView selectAll:self];
    }else{
        selectIndex=-1;
    }
    
    [self reloadPlayListData];
}



-(void)playCurrentItem:(NSString *)path{
    
    //NSLog(@"playCurrentItem ==%@",path);
    AppDelegate *delegate=[[NSApplication sharedApplication] delegate];
    [delegate.videoVC close];
    
    [delegate.videoVC initAssetData:[NSURL URLWithString:path]];
}
- (void)setButtonColor:(NSButton *)button andColor:(NSColor *)color {
    if (color == nil) {
        color = [NSColor redColor];
    }
    
    int fontSize = 16;
    NSFont *font = [NSFont systemFontOfSize:fontSize];
    NSDictionary * attrs = [NSDictionary dictionaryWithObjectsAndKeys:font,
                            NSFontAttributeName,
                            color,
                            NSForegroundColorAttributeName,
                            
                            nil];
    
    NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:[button title] attributes:attrs];
    [attributedString setAlignment:NSRightTextAlignment range:NSMakeRange(0, [attributedString length])];
    
    [button setAttributedTitle:attributedString];
    
}

-(void)videoEnd{
    //NSLog(@"videoEnd.......");
    
    [self selectIndexPlay:(++selectIndex)];
    
}
//add gps
-(void)updateDataByCurrentTime:(Float64)time{
    float m_ratio=1.0;
    float spd_ratio=1.0;
    if(totalTime>0){
        m_ratio= [currentVideoGpsDataArr count]/totalTime;
        spd_ratio=[currentSpeedDataArr count]/totalTime;//spd change/time
    }
    
    int index=(int)time*m_ratio;
    //int index1=(int)time*spd_ratio;
    
    if(currentVideoGpsDataArr!=nil&&[currentVideoGpsDataArr count]>0){
        if(index<[currentVideoGpsDataArr count]){
            NSArray *xyItem=currentVideoGpsDataArr[index];
            
            if ([xyItem[0] floatValue]<0) {
                _longitudeUnitLabels.stringValue=@"W";
            }else{
                _longitudeUnitLabels.stringValue=@"E";
            }
            if ([xyItem[1] floatValue]<0) {
                _latitudeUnitLabels.stringValue=@"S";
            }else{
                _latitudeUnitLabels.stringValue=@"N";
            }
            
            _longitudeLabels.stringValue=[self convertLatLngToDFM:[xyItem[0] floatValue]<0?-[xyItem[0] floatValue]:[xyItem[0] floatValue]];
            
            _latitudeLabels.stringValue=[self convertLatLngToDFM:[xyItem[1] floatValue]<0?-[xyItem[1] floatValue]:[xyItem[1] floatValue]];
            
            
            [self  rotateAngle:[xyItem[2] floatValue]/180*M_PI];///180*M_PI
            //modify by chenjian
            //[self  rotateAngle:[xyItem[2] floatValue]/M_PI];///180*M_PI
            
        }
    }
    if(currentSpeedDataArr!=nil&&[currentSpeedDataArr count]>0){
        if(index<[currentSpeedDataArr  count]){
            NSArray *xyItem=currentSpeedDataArr[index];
            
            if(xyItem[0]>0){
                
                //modify chenjian
                spd_show_v = [xyItem[0] floatValue];
                [self.spdshow setStringValue:[AppUtils convertSpeedUnit:(spd_show_v)]];
                NSString  *spdSouce=self.spdshow.stringValue;
                //NSLog(@"spdSouce==%@",spdSouce);
                
                if ([spdSouce rangeOfString:@"KM/H"].location == NSNotFound) {
                    NSString *spdString = [spdSouce stringByReplacingOccurrencesOfString:@"MPH" withString:@""];//字符串替换
                    float spd_v = [spdString floatValue];
                    //NSLog(@"MPH spd_v==========%f",spd_v);
                    [self  rotateSpd:spd_v/90*M_PI];
                    //NSLog(@"spdimage---------------------------mph-");
                    [ self.spdImage  setImage:[NSImage imageNamed:@"2"]];
                    //modify by chenjian
                    //[self.view setNeedsDisplay:YES];
                   // [self.spdArrowChange setImage:[NSImage imageNamed:@"spdarrow"]];
                    
                }
                if ([spdSouce rangeOfString:@"MPH"].location == NSNotFound) {
                    NSString *spdString = [spdSouce stringByReplacingOccurrencesOfString:@"KM/H" withString:@""];//字符串替换
                    float spd_v = [spdString floatValue];
                    //NSLog(@"KM/H spd_v==========%f",spd_v);
                    [self  rotateSpd:spd_v/172*M_PI];
                    //NSLog(@"speedbackset----------------/////-----------kmh-");
                    [ self.spdImage  setImage:[NSImage imageNamed:@"412kmh"]];//speedbackset
                    //modify by chenjian
                    //[self.view setNeedsDisplay:YES];
                  //  [self.spdArrowChange setImage:[NSImage imageNamed:@"3"]];
                }
                
                
            }else{
                
                [self.spdshow setStringValue:[AppUtils convertSpeedUnit:(0.0)]];
            }
            
            
        }
        
    }
    
    
    
}
//static float val=0.0;

-(void)rotateAngle:(float)angle{
    
    
    float xval=self.stillImageViewss.frame.origin.x+self.stillImageViewss.frame.size.width/2;
    float yval=self.stillImageViewss.frame.origin.y+self.stillImageViewss.frame.size.height/2;
    
    self.stillImageViewss.layer.position=CGPointMake(xval, yval);
    
    CATransform3D transform = CATransform3DMakeRotation(angle, 0, 0, -1);
    self.stillImageViewss.layer.anchorPoint=CGPointMake(0.5, 0.5);
    self.stillImageViewss.layer.transform=transform;
    
    //modify by chenjian
    [[NSUserDefaults standardUserDefaults] setObject:@(angle) forKey:@"rotateAngle_v"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
}
-(void)rotateSpd:(float)angle{
    
    
    float xval=self.spdArrowChange.frame.origin.x+self.spdArrowChange.frame.size.width/2;
    float yval=self.spdArrowChange.frame.origin.y+self.spdArrowChange.frame.size.height/2;
    
    self.spdArrowChange.layer.position=CGPointMake(xval, yval);
    
    CATransform3D transform = CATransform3DMakeRotation(angle, 0, 0, -1);
    self.spdArrowChange.layer.anchorPoint=CGPointMake(0.5, 0.5);
    self.spdArrowChange.layer.transform=transform;
    
    //modify by chenjian
    [[NSUserDefaults standardUserDefaults] setObject:@(angle) forKey:@"rotateSpd_v"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    
}

-(NSString *)convertLatLngToDFM:(float)latlng{
    int d_int=(int)latlng;
    float f_float=(latlng-d_int)*60;
    int f_int=(int)f_float;
    float m_float=(f_float-f_int)*60;
    return [NSString stringWithFormat:@"%3d°%3d'    %.2f",d_int,f_int,m_float];
}

-(void)videoAllTime:(Float64)allTime{
    totalTime=allTime;
}


-(void)dataLogicProcessOfViodePath:(NSString *)playVideoPath{
    
    currentPlayVideoPath=playVideoPath;
    
    
    
    NSArray *gpsDataArr=[MyCache findGpsDatas:currentPlayVideoPath];
    
    currentVideoGpsDataArr=[NSMutableArray new];
    currentSpeedDataArr=[NSMutableArray new];
    [gpsDataArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSNumber *spd=[obj objectForKey:@"spd"];
        
        //  [self  rotateAngle:[xyItem[2] floatValue]/140*M_PI];///180*M_PI
        
        NSString *gps_lat=[obj objectForKey:@"gps_lat"];
        NSString *gps_lgt=[obj objectForKey:@"gps_lgt"];
        
        NSNumber *north_angle=[obj objectForKey:@"north_angle"];
        
        
        if(gps_lat.floatValue!=0&&gps_lgt.floatValue!=0){
            
            [currentVideoGpsDataArr addObject:[NSArray arrayWithObjects:[NSNumber numberWithFloat:gps_lgt.floatValue],[NSNumber numberWithFloat:gps_lat.floatValue],north_angle, nil]];
            
            
        }
        
        [currentSpeedDataArr addObject:[NSArray arrayWithObjects:spd, nil]];
        
        
        
        
        
    }];
    
}

//add gps location
//键盘监听事件===========
- (BOOL)tableView:(NSTableView *)tableView shouldTypeSelectForEvent:(NSEvent *)event withCurrentSearchString:(nullable NSString *)searchString NS_AVAILABLE_MAC(10_5){
    //NSLog(@"shouldTypeSelectForEvent play event***** %@",event);
    return NO;
}


-(void)keyDown:(NSEvent *)theEvent{
    NSLog(@"keyDown play list========%@",theEvent);
    
    //[self interpretKeyEvents:[NSArray arrayWithObject:e]];
    //NSLog(@"%@,down,%f",e.characters,second);
    
    AppDelegate *delegate=[[NSApplication sharedApplication] delegate];
    [delegate.videoVC keyDown:theEvent];
    if([theEvent modifierFlags] & NSCommandKeyMask)
    {
        NSString* theString = [theEvent charactersIgnoringModifiers];
        if([theString characterAtIndex:0] == 'A' || [theString characterAtIndex:0] == 'a')
        {
            
            [tableView selectAll:self];
            
        }
        
    }
}
//键盘监听事件==============
- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
     NSLog(@"keyDown setRepresentedObject");
    // Update the view, if already loaded.
}


-(NSInteger)zoomInMapWindow:(NSInteger)state
{
    NSLog(@"PlayListViewController zoomInMapWindow===%ld",state);
    return state;
}


@end
