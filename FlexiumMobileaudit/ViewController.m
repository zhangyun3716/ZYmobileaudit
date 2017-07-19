//  ViewController.m
//  FlexiumMobileaudit
//  Created by flexium on 2016/11/17.
//  Copyright © 2016年 FLEXium. All rights reserved.

#import "ViewController.h"
#import "ZYScannerView.h"
#import "UIImageView+WebCache.h"
@interface ViewController ()<NSXMLParserDelegate,UIImagePickerControllerDelegate>

//第一個按鈕
- (IBAction)type:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *typechoose;
//違規的事項類型
@property (strong, nonatomic) IBOutlet UILabel *type;

- (IBAction)beginscan:(UIButton *)sender;
//第二個按鈕
@property (strong, nonatomic) IBOutlet UIButton *Compassestype;
- (IBAction)Compassestype:(UIButton *)sender;
//具體類型的table
@property (strong, nonatomic) IBOutlet UILabel *choosetype;
@property (strong, nonatomic) IBOutlet UIView *beijingview;
- (IBAction)exit:(id)sender;


@property(nonatomic,strong)UIView *backview;
@property(nonatomic,strong) NSArray *typearr;
@property(nonatomic,strong) NSArray *changtingarr;
@property(nonatomic,strong)NSArray *shenghuoarr;
@property(nonatomic,assign) int leixing;

//存放我解析出来的数据
@property (nonatomic, strong) NSArray *list;
@property (nonatomic, strong) NSArray *arraylist;
@property (nonatomic,strong) NSArray *retrunlist;
@property (nonatomic,strong) NSArray *bedmangementlist;
//添加属性(数据类型xml解析)
@property (nonatomic, strong) NSXMLParser *parser;
//标记当前标签，以索引找到XML文件内容
@property (nonatomic, copy) NSString *currentElement;

@property (nonatomic,strong)NSString *currentElementName;

@property (nonatomic,assign)BOOL isCheck;
@property (nonatomic,strong)NSString *returnresult;

@property (nonatomic,assign) int httptype;

@property (strong, nonatomic) IBOutlet UILabel *empno;

@property (strong, nonatomic) IBOutlet UILabel *empname;
@property (strong, nonatomic) IBOutlet UILabel *emptype;
@property (strong, nonatomic) IBOutlet UILabel *empcontent;
@property (strong, nonatomic) IBOutlet UILabel *bed_no;
@property (strong, nonatomic) IBOutlet UIImageView *imageview;
@property (strong,nonatomic) NSTimer *myTimer;
- (IBAction)Takephoto:(UIButton *)sender;
@property(nonatomic,strong)UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *Takephoto;

//菊花界面
@property (strong,nonatomic)UIActivityIndicatorView *testview;
@end

@implementation ViewController

#pragma mark 界面加载
- (void)viewDidLoad {
    [super viewDidLoad];
//[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    _leixing=1;
     self.Takephoto.layer.cornerRadius=7;
     self.Takephoto.layer.masksToBounds=YES;
    self.chuangweilabel.hidden=YES;
    self.bed_no.hidden=YES;
//    self.Takephoto.hidden=YES;
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(80, 159, 180, self.view.bounds.size.height-170)];
    // _tableView.backgroundColor=[UIColor blackColor];
    self.tableView.bounces=NO;
    self.tableView.hidden=YES;
    [self.view addSubview:_tableView];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.tableFooterView=[[UIView alloc] init];
//    self.tableView.backgroundColor=[UIColor blackColor];
    //下列方法的作用也是隐藏分割线。
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.tableView setLayoutMargins:UIEdgeInsetsZero];
}


#pragma mark 點擊完成的操作
-(void)nextmenu:(UIButton *)sender{
    NSLog(@"%d",(int)sender.tag);
     self.backview.hidden=YES;
    self.tableView.hidden=YES;
    [self.backview removeFromSuperview];
    self.typechoose.selected=0;
    self.Compassestype.selected=0;
  
    if (sender.tag==1) {
        NSLog(@"掃描");
        self.chuangweilabel.hidden=YES;
        self.bed_no.hidden=YES;
        self.type.text=self.typearr[sender.tag];
        _leixing=1;
        [[ZYScannerView sharedScannerView] showOnView:self.view block:^(NSString *str) {
            self.choosetype.textColor=[UIColor whiteColor];
            [self.beijingview bringSubviewToFront:self.view];
            //里面写实现的方法。可以实现的功能
            self.choosetype.text=str;
        }];
    }
    else if(sender.tag==2){
        self.chuangweilabel.hidden=YES;
        self.bed_no.hidden=YES;
     self.type.text=self.typearr[sender.tag];
        _leixing=2;
        NSLog(@"餐厅违规稽核");
    }
    else if(sender.tag==3){
        self.chuangweilabel.hidden=YES;
        self.bed_no.hidden=YES;
        self.type.text=self.typearr[sender.tag];
        _leixing=3;
        NSLog(@"生活区违规");
        
    }
    else if(sender.tag==4){
        self.httptype=4;
        _leixing=4;
        self.type.text=self.typearr[sender.tag];
        self.choosetype.text=self.typearr[sender.tag];
        self.choosetype.textColor=[UIColor whiteColor];
        self.chuangweilabel.hidden=NO;
        self.bed_no.hidden=NO;
        NSLog(@"床位管理");
        [[ZYScannerView sharedScannerView] showOnView:self.view block:^(NSString *str) {
//            self.choosetype.textColor=[UIColor whiteColor];
//            //里面写实现的方法。可以实现的功能
//            self.choosetype.text=str;
             [self.beijingview bringSubviewToFront:self.view];
            [self bedmangementwebsever:str];
        }];

    }
    else {
        self.chuangweilabel.hidden=YES;
        self.bed_no.hidden=YES;
        self.type.text=self.typearr[sender.tag];
        _leixing=5;
    }

}
#pragma mark 下一个动作
-(void)nextaction:(UIButton *)sender{
     self.backview.hidden=YES;
    [self.backview removeFromSuperview];
    self.typechoose.selected=0;
    self.Compassestype.selected=0;
    if (_leixing==2) {
         self.choosetype.text=self.changtingarr[sender.tag];
    }
    if (_leixing==3) {
         self.choosetype.text=self.shenghuoarr[sender.tag];
    }
    if (_leixing==5) {
        self.choosetype.text=self.shenghuoarr[sender.tag];
    }
}


#pragma mark 類型選擇
- (IBAction)type:(UIButton *)sender {
//    [self.view setUserInteractionEnabled:NO];
     self.tableView.hidden=YES;
    self.imageview.image=nil;
    self.choosetype.text=@"选择類型或卡機";
    self.choosetype.textColor=[UIColor redColor];
    self.choosetype.font=[UIFont systemFontOfSize:13];
     self.backview.hidden=YES;
    [self.backview removeFromSuperview];
    self.Compassestype.selected=0;
     sender.selected=!sender.selected;
    sender.userInteractionEnabled=NO;
     self.httptype=1;
    if (sender.selected==1) {
         [self websever:@"KS"];
    }else{
         self.backview.hidden=YES;
         self.tableView.hidden=YES;
        [self.backview removeFromSuperview];
    }
   
}
#pragma mark 第二個類型選擇
- (IBAction)Compassestype:(UIButton *)sender {
    //    self.imageview.image=nil;
//        [self.view setUserInteractionEnabled:NO];
//    self.Compassestype.userInteractionEnabled=NO;
    self.backview.hidden=YES;
    [self.backview removeFromSuperview];
    self.typechoose.selected=0;
    self.choosetype.font=[UIFont systemFontOfSize:15];
    self.choosetype.textColor=[UIColor whiteColor];
    sender.selected=!sender.selected;
    self.httptype=2;
    if (sender.selected==1) {
        [self messgewebsever:[NSString stringWithFormat:@"%d",_leixing]];
    }else{
        sender.selected=0;
        self.Compassestype.userInteractionEnabled=YES;
        self.backview.hidden=YES;
        [self.backview removeFromSuperview];
        self.tableView.hidden=YES;
    }
}


#pragma mark 處理點擊屏幕空白地方消失鍵盤并將按鈕屬性復位
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
        self.typechoose.userInteractionEnabled=YES;
        self.Compassestype.userInteractionEnabled=YES;
     self.backview.hidden=YES;
        [self.backview removeFromSuperview];
        self.typechoose.selected=0;
        self.Compassestype.selected=0;
        self.tableView.hidden=YES;
    for(UIView *view in [self.view subviews])
    {
        if (view==self.backview) {
             self.backview.hidden=YES;
            self.tableView.hidden=YES;
            [view removeFromSuperview];
        }
        
    }
}
#pragma mark 開始掃描
- (IBAction)beginscan:(UIButton *)sender {
//    self.imageview.image=nil;
    self.tableView.hidden=YES;
     self.backview.hidden=YES;
    [self.backview removeFromSuperview];
    [_myTimer invalidate];
    _myTimer =nil;
    self.httptype=3;
    if ([self.choosetype.text isEqualToString:@"选择類型或卡機"]) {
        NSLog(@"不能弄了");
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择具体类型" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:nil];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
        //修改title
        NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:@"请选择具体类型"];
        [alertControllerStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 7)];
        [alertControllerStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, 7)];
        [alertController setValue:alertControllerStr forKey:@"attributedTitle"];
        [cancelAction setValue:[UIColor blueColor] forKey:@"titleTextColor"];
    }else{
//插入數據庫的是餐卡機異常
    if (_leixing==1) {
        [[ZYScannerView sharedScannerView] showOnView:self.view block:^(NSString *str) {
            //里面写实现的方法。可以实现的功能
            NSLog(@"選擇了掃描");
             [self.beijingview bringSubviewToFront:self.view];
            NSString *message=[NSString stringWithFormat:@"%d;%@;%@;",_leixing,str,self.choosetype.text];
            [self  insertwebsever:message image:nil];
            [self beginjuhua];
        }];
    }
//這裡是餐廳浪費稽核
    if (_leixing==2) {
//        [[ZYScannerView sharedScannerView] showOnView:self.view block:^(NSString *str) {
//            //里面写实现的方法。可以实现的功能
//            NSLog(@"選擇了掃描");
//             [self.beijingview bringSubviewToFront:self.view];
//            NSString *message=[NSString stringWithFormat:@"%d;%@;;%@",_leixing,str,self.choosetype.text];
//            UIImage *originImage = self.imageview.image;
//        originImage=[self imageWithImage:originImage scaledToSize:CGSizeMake( 320.2,426.667)];
//            NSData *data = UIImageJPEGRepresentation(originImage, 0.988f);
//            NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
//            [self  insertwebsever:message image:encodedImageStr];
//            [self beginjuhua];
//        }];
        [self tanchukuang];
    }
//這裡是生活區人員稽核功能
   if (_leixing==3) {
       [self tanchukuang];
    }
        //這裡是床位管理
         else if(_leixing==4){
                    [[ZYScannerView sharedScannerView] showOnView:self.view block:^(NSString *str) {
                         [self.view addSubview:self.beijingview];
                        self.httptype=4;
                        [self bedmangementwebsever:str];
                        [self beginjuhua];

                    }];
                }
        //其他類型
             else{
//                 [[ZYScannerView sharedScannerView] showOnView:self.view block:^(NSString *str) {
//                     //里面写实现的方法。可以实现的功能
//                     NSLog(@"選擇了掃描");
//                     [self.beijingview bringSubviewToFront:self.view];
//                     NSString *message=[NSString stringWithFormat:@"%d;%@;;%@",_leixing,str,self.choosetype.text];
//                     UIImage *originImage = self.imageview.image;
//                     originImage=[self imageWithImage:originImage scaledToSize:CGSizeMake( 320.2,426.667)];
//                     NSData *data = UIImageJPEGRepresentation(originImage, 0.988f);
//                     NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
//                     [self  insertwebsever:message image:encodedImageStr];
//                     [self beginjuhua];
//                 }];
                 [self tanchukuang];
             }
    }
    
}
#pragma mark 查詢大类型
-(void)websever:(NSString *)message{
    NSString *urlStr = @"http://portal.flexium.com.cn:81/Mobileaudit.asmx";
    NSURL *url = [NSURL URLWithString:urlStr];
    // 2.创建session对象
    NSURLSession *session = [NSURLSession sharedSession];
    // 3.创建请求对象
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    // 4.设置请求方式与参数
    request.HTTPMethod = @"POST";
    NSString *str1=@"<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><APPMethod xmlns='http://tempuri.org/'><message>";
    NSString *str2=@"</message></APPMethod></soap:Body></soap:Envelope>";
    NSString *dataStr = [NSString stringWithFormat:@"%@%@%@",str1,message,str2];
    NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = data;
    NSString *msgLength=  [NSString stringWithFormat:@"%zd",(int*)dataStr.length];
    [request setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"http://tempuri.org/APPMethod" forHTTPHeaderField:@"Action"];
    
    
    // 5.进行链接请求数据
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"请求数据出错!----%@",error.description);
            [self presentnetworkingerr];
        } else {
            self.parser=[[NSXMLParser alloc]initWithData:data];
            NSString *result = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
            NSLog(@"%@",result);
            //添加代理
            self.parser.delegate=self;
            //self.list = [NSMutableArray arrayWithCapacity:9];
            //这一步不能少！
            self.parser.shouldResolveExternalEntities=true;
            //开始解析
            [self.parser parse];
            
        }
    }];
    // 6.开启请求数据
    [dataTask resume];
}
   #pragma mark 查詢小类型
-(void)messgewebsever:(NSString *)message{
    NSString *urlStr = @"http://portal.flexium.com.cn:81/Mobileaudit.asmx";
    NSURL *url = [NSURL URLWithString:urlStr];
    // 2.创建session对象
    NSURLSession *session = [NSURLSession sharedSession];
    // 3.创建请求对象
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    // 4.设置请求方式与参数
    request.HTTPMethod = @"POST";
    NSString *str1=@"<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><APPQQ xmlns='http://tempuri.org/'><message>";
    NSString *str2=@"</message></APPQQ></soap:Body></soap:Envelope>";
    NSString *dataStr = [NSString stringWithFormat:@"%@%@%@",str1,message,str2];
    NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = data;
    NSString *msgLength=  [NSString stringWithFormat:@"%zd",(int*)dataStr.length];
    [request setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"http://tempuri.org/APPQQ" forHTTPHeaderField:@"Action"];
    
    
    // 5.进行链接请求数据
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"请求数据出错!----%@",error.description);
            [self presentnetworkingerr];
        } else {
            self.parser=[[NSXMLParser alloc]initWithData:data];
            NSString *result = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
            NSLog(@"%@",result);
            //添加代理
            self.parser.delegate=self;
            //self.list = [NSMutableArray arrayWithCapacity:9];
            //这一步不能少！
            self.parser.shouldResolveExternalEntities=true;
            //开始解析
            [self.parser parse];
            
        }
    }];
    // 6.开启请求数据
    [dataTask resume];
}
#pragma mark 插入数据
-(void)insertwebsever:(NSString *)message image:(NSString *)imageBuffer{
    NSString *urlStr = @"http://portal.flexium.com.cn:81/Mobileaudit.asmx?wsdl";
    NSURL *url = [NSURL URLWithString:urlStr];
    // 2.创建session对象
    NSURLSession *session = [NSURLSession sharedSession];
    // 3.创建请求对象
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    // 4.设置请求方式与参数
    request.HTTPMethod = @"POST";
    NSString *str1=[NSString stringWithFormat:@"<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><APPinsert xmlns='http://tempuri.org/'><message>%@</message><imageBuffer>%@</imageBuffer></APPinsert></soap:Body></soap:Envelope>",message,imageBuffer];
    NSData *data = [str1 dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = data;
    NSString *msgLength=  [NSString stringWithFormat:@"%zd",(int*)str1.length];
    [request setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"http://tempuri.org/APPinsert" forHTTPHeaderField:@"Action"];
    
    
    // 5.进行链接请求数据
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"请求数据出错!----%@",error.description);
            [self presentnetworkingerr];
        } else {
            self.parser=[[NSXMLParser alloc]initWithData:data];
            NSString *result = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
            NSLog(@"%@",result);
            //添加代理
            self.parser.delegate=self;
            //self.list = [NSMutableArray arrayWithCapacity:9];
            //这一步不能少！
            self.parser.shouldResolveExternalEntities=true;
            //开始解析
            [self.parser parse];
            
        }
    }];
    // 6.开启请求数据
    [dataTask resume];
}
#pragma mark 现在进行网络请求
-(void)bedmangementwebsever:(NSString *)message{
    NSString *urlStr = @"http://portal.flexium.com.cn:81/Bedmangement.asmx";
    NSURL *url = [NSURL URLWithString:urlStr];
    // 2.创建session对象
    NSURLSession *session = [NSURLSession sharedSession];
    // 3.创建请求对象
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    // 4.设置请求方式与参数
    request.HTTPMethod = @"POST";
    NSString *str1=@"<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><bedmangement xmlns='http://tempuri.org/'><message>";
    NSString *str2=@"</message></bedmangement></soap:Body></soap:Envelope>";
    NSString *dataStr = [NSString stringWithFormat:@"%@%@%@",str1,message,str2];
    NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = data;
    NSString *msgLength=  [NSString stringWithFormat:@"%zd",(int*)dataStr.length];
    [request setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"http://tempuri.org/bedmangement" forHTTPHeaderField:@"Action"];
    
    
    // 5.进行链接请求数据
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"请求数据出错!----%@",error.description);
            [self presentnetworkingerr];
        } else {
            self.parser=[[NSXMLParser alloc]initWithData:data];
            //添加代理
            self.parser.delegate=self;
            self.list = [NSMutableArray arrayWithCapacity:6];
            //这一步不能少！
            self.parser.shouldResolveExternalEntities=true;
            //开始解析
            [self.parser parse];
            
        }
    }];
    // 6.开启请求数据
    [dataTask resume];
}

#pragma mark 遍历查找xml中文件的元素
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict{
    _currentElementName = elementName;
    //大类型选择
    if ([_currentElementName isEqualToString:@"APPMethodResult"]) {
        _isCheck = true;
        _returnresult = @"";
    }
    //小类型选择
    if ([_currentElementName isEqualToString:@"APPQQResult"]) {
        _isCheck = true;
        _returnresult = @"";
    }
    //插入数据
    if ([_currentElementName isEqualToString:@"APPinsertResult"]) {
        _isCheck = true;
        _returnresult = @"";
    }
    if ([_currentElementName isEqualToString:@"bedmangementResult"]) {
        _isCheck = true;
        _returnresult = @"";
    }
}
#pragma mark xml解析方法中的遍历原素的方法
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    //大类型
    if ([_currentElementName isEqualToString:@"APPMethodResult"]) {
        _isCheck = true;
        _returnresult =[_returnresult stringByAppendingString:string] ;
        self.list= [self.returnresult componentsSeparatedByString:@";"];
    }
    //具体类型
    if ([_currentElementName isEqualToString:@"APPQQResult"]) {
        _isCheck = true;
        _returnresult =[_returnresult stringByAppendingString:string] ;
        self.arraylist= [self.returnresult componentsSeparatedByString:@";"];
//        NSLog(@"%@",self.arraylist);
    }
    //插入数据
    if ([_currentElementName isEqualToString:@"APPinsertResult"]) {
        _isCheck = true;
        _returnresult =[_returnresult stringByAppendingString:string] ;
        self.retrunlist= [self.returnresult componentsSeparatedByString:@";"];
//        NSLog(@"%@",self.retrunlist);
    }
    if ([_currentElementName isEqualToString:@"bedmangementResult"]) {
        _isCheck = true;
        _returnresult =[_returnresult stringByAppendingString:string] ;
        self.list= [self.returnresult componentsSeparatedByString:@";"];
    }
    
}
#pragma mark 把上部的信息存储到数据中
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
  //  self.currentElementName = nil;
    
}

#pragma mark 最后一次这里解析出数据
- (void)parserDidEndDocument:(NSXMLParser *)parser{
    self.typechoose.userInteractionEnabled=YES;
    self.Compassestype.userInteractionEnabled=YES;
      dispatch_async(dispatch_get_main_queue(), ^{
          [self endjuhua];
//类型一：
 if (self.httptype==1) {
            if (_typechoose.selected==1) {
              //  NSArray *arr=@[@"餐卡機異常",@"餐廳內違規",@"生活區違規"];
                self.typearr=[[NSArray alloc]initWithArray:self.list];
                self.backview=[[UIView alloc]initWithFrame:CGRectMake(5, 160, 250, 400)];
                self.backview.backgroundColor=[UIColor whiteColor];
                [self.backview setAlpha:1];
                [self.view addSubview:self.backview];
                for (int i=0; i< self.typearr.count-1; i++) {
                    NSString *a=[ self.typearr objectAtIndex:i+1];
                    UIButton *btn=[[UIButton alloc]init];
                    int b=i*41;
                    btn.backgroundColor=[UIColor blackColor];
                    btn.frame=CGRectMake(0, b, 150, 40);
                    btn.titleLabel.text=a;
                    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [btn setTitle:a forState:UIControlStateNormal];
                    [btn setTitle:@"確認選擇" forState:UIControlStateHighlighted];
                    [btn addTarget:self action:@selector(nextmenu:) forControlEvents:UIControlEventTouchUpInside];
                    [self.backview addSubview:btn];
                    btn.tag=i+1;
                }
        
                [self.view setUserInteractionEnabled:YES];
            }else{
                 self.backview.hidden=YES;
                [self.backview removeFromSuperview];
                [self.view setUserInteractionEnabled:YES];

            }
        }
//类型二：
  if (self.httptype==2) {
          if (_leixing==1) {
              self.Compassestype.selected=0;
              //掃描餐卡機
              [[ZYScannerView sharedScannerView] showOnView:self.view block:^(NSString *str) {
                   [self.beijingview bringSubviewToFront:self.view];
                  //里面写实现的方法。可以实现的功能
                  self.choosetype.textColor=[UIColor whiteColor];
                  self.choosetype.text=str;
                  self.Compassestype.selected=0;
                  [self.view setUserInteractionEnabled:YES];

              }];
          }
          if (_leixing==2) {
              NSLog(@"顯示類型二");
              [self.backview removeFromSuperview];
                    if (self.Compassestype.selected==1) {
                        self.tableView.hidden=NO;
                        [self.tableView reloadData];
      
              }else{
                  [self.view setUserInteractionEnabled:YES];
                   self.backview.hidden=YES;
                  [self.backview removeFromSuperview];
                  self.tableView.hidden=YES ;
              }
      
          }
          if (_leixing==3) {
              NSLog(@"顯示類型三");
              if (self.Compassestype.selected==1) {

                  [self.tableView reloadData];
                  self.tableView.hidden=NO;
              }else{
                  [self.view setUserInteractionEnabled:YES];
                   self.backview.hidden=YES;
                  [self.backview removeFromSuperview];
                  self.tableView.hidden=YES ;
              }
          }
      
        }
//类型3：插入数据并返回
if (self.httptype==3) {
    dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.retrunlist[0] isEqualToString:@"OK"]) {
                self.empno.text=self.retrunlist[1];
                self.empname.text=self.retrunlist[2];
                self.emptype.text=self.retrunlist[3];
                self.empcontent.text=self.retrunlist[4];
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"登记成功" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
               _myTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(delayMethod) userInfo:nil repeats:NO];
                   
                }];
                [alertController addAction:cancelAction];
                [self presentViewController:alertController animated:YES completion:nil];
                //修改title
                NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:@"登记成功"];
                [alertControllerStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 4)];
                [alertControllerStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, 4)];
                [alertController setValue:alertControllerStr forKey:@"attributedTitle"];
                [cancelAction setValue:[UIColor blueColor] forKey:@"titleTextColor"];
                [self.view setUserInteractionEnabled:YES];
            }else{
                  _myTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(delayMethod) userInfo:nil repeats:NO];
                self.empno.text=@"插入失败";
                self.empname.text=nil;
                self.emptype.text=nil;
                self.empcontent.text=nil;
                self.bed_no.text=nil;
                self.imageview.image=nil;
                [self.view setUserInteractionEnabled:YES];

            }
    });
              
        }
          
          
if (self.httptype==4) {
              dispatch_async(dispatch_get_main_queue(), ^{
                  if ([self.list[0] isEqualToString:@"OK" ]) {
                      self.empno.text=self.list[1];
                      //self.emo_no.textColor=[UIColor blackColor];
                      self.empname.text=self.list[2];
                      self.emptype.text=self.list[3];
                      self.empcontent.numberOfLines=0;
                      self.empcontent.text=self.list[4];
                      self.bed_no.text=self.list[5];
                      dispatch_async(dispatch_get_main_queue(), ^{
                          NSLog(@"实现图片加载功能");
                          NSString *image_name= [self.list[1]stringByAppendingString:@".JPG"];
                          if (image_name.length<6) {
                              self.imageview.image=nil;
                          }else{
                              NSLog(@"%@",image_name);
                              NSString *image_str=[NSString stringWithFormat:@"http://hr-server.flexium.com.cn:81/image/%@",image_name];
                              [self.imageview sd_setImageWithURL:[NSURL URLWithString:image_str]];
                              _myTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(delayMethod) userInfo:nil repeats:NO];
                          }
                         
                      });
                      [self.view setUserInteractionEnabled:YES];

                      
                  }else{
                       _myTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(delayMethod) userInfo:nil repeats:NO];
                      self.empno.text=@"非住宿员工";
                      self.empno.textColor=[UIColor redColor];
                      self.empname.text=nil;
                      self.emptype.text=nil;
                      self.empcontent.numberOfLines=0;
                      self.empcontent.text=nil;
                      self.bed_no.text=nil;
                      self.imageview.image=nil;
                      UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"非住宿员工" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                      UIView *subView1 = alertController.view.subviews[0];
                      UIView *subView2 = subView1.subviews[0];
                      UIView *subView3 = subView2.subviews[0];
                      UIView *subView4 = subView3.subviews[0];
                      UIView *subView5 = subView4.subviews[0];
                      NSLog(@"%@",subView5.subviews);
                      UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:nil];
                      [alertController addAction:cancelAction];
                      [self presentViewController:alertController animated:YES completion:nil];
                      //修改title
                      NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:@"非住宿员工"];
                      [alertControllerStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 5)];
                      [alertControllerStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, 5)];
                      [alertController setValue:alertControllerStr forKey:@"attributedTitle"];
                      [cancelAction setValue:[UIColor blueColor] forKey:@"titleTextColor"];
                      [self.view setUserInteractionEnabled:YES];
                      
                  }
                  
              });
          }
      
    });
    
}
#pragma mark 延迟清空界面数据的方法
- (void)delayMethod {
     dispatch_async(dispatch_get_main_queue(), ^{
    self.empno.text=nil;
    self.empname.text=nil;
    self.emptype.text=nil;
    self.empcontent.text=nil;
    self.bed_no.text=nil;
    self.imageview.image=nil;
     });
}

#pragma mark 拍照留证据
- (IBAction)Takephoto:(UIButton *)sender {
   // [[UIApplication sharedApplication] setStatusBarHidden:YES];
    UIImagePickerController *pick = [[UIImagePickerController alloc]init];
    pick.sourceType = UIImagePickerControllerSourceTypeCamera;
    pick.delegate = self;
    //必须是用present方法模态推出
    [self presentViewController:pick animated:YES completion:nil];

}

#pragma mark - 照片选择代理方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.imageview.image = image;
//    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    [picker dismissViewControllerAnimated:NO completion:nil];
}
#pragma mark -网络错误弹出窗口
-(void)presentnetworkingerr{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"網絡錯誤" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
    //修改title
    NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:@"網絡錯誤"];
    [alertControllerStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 4)];
    [alertControllerStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, 4)];
    [alertController setValue:alertControllerStr forKey:@"attributedTitle"];
    [cancelAction setValue:[UIColor blueColor] forKey:@"titleTextColor"];

}
#pragma mark 建立并开始菊花界面请求
-(void)beginjuhua{
    UIActivityIndicatorView *testActivityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];//UIActivityIndicatorViewStyleWhite];
    //testActivityIndicator.backgroundColor=[UIColor whiteColor];
    testActivityIndicator.center = CGPointMake(100.0f, 100.0f);//只能设置中心，不能设置大小
    [testActivityIndicator setFrame :CGRectMake(100, 200, 100, 100)];//不建议这样设置，因为
    [self.view addSubview:testActivityIndicator];
    testActivityIndicator.color = [UIColor greenColor]; // 改变圈圈的颜色为红色； iOS5引入
    [testActivityIndicator startAnimating]; // 开始旋转
    self.testview=testActivityIndicator;
}
#pragma mark 结束并移除菊花界面
-(void)endjuhua{
    
     dispatch_async(dispatch_get_main_queue(), ^{
    [_testview stopAnimating]; // 结束旋转
    [_testview removeFromSuperview]; //当旋转结束时移除
     });
}
#pragma mark 图片压缩
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];

    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
  
    UIGraphicsEndImageContext();
 
    return newImage;
}
- (IBAction)exit:(id)sender {
    exit(0);
}
#pragma mark 返回分组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
#pragma mark 返回表视图的分组行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arraylist.count-1;
}
#pragma mark tableviewcell的显示样式等东西
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath: (NSIndexPath *)indexPath{
    static NSString *cellIdentifier =@"cell_id";
    //重用机制有关系
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        //样式
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        //cell.accessoryType =UITableViewCellAccessoryDetailDisclosureButton;//有箭头和感叹号
    }
    cell.textLabel.text= self.arraylist[indexPath.row+1];
    cell.contentView.backgroundColor=[UIColor blackColor];
    cell.textLabel.textColor=[UIColor whiteColor];
    cell.textLabel.backgroundColor=[UIColor blackColor];
    //    NSLog(@"%@",self.searchResult[indexPath.row]);
    return cell;
    
}
#pragma mark 点击選擇計劃出现的事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.backview.hidden=YES;
    [self.backview removeFromSuperview];
    self.typechoose.selected=0;
    self.Compassestype.selected=0;
    if (_leixing==2) {
        self.choosetype.text=self.arraylist[indexPath.row+1];
    }
    if (_leixing==3) {
        self.choosetype.text=self.arraylist[indexPath.row+1];
    }
    if (_leixing==5) {
        self.choosetype.text=self.arraylist[indexPath.row+1];
    }
    self.tableView.hidden=YES;
    

}

#pragma mark 彈出顯示正常異常的方法
-(void)tanchukuang{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"是否掃描工卡"message:@""preferredStyle:UIAlertControllerStyleAlert ];
    UIAlertAction *home1Action = [UIAlertAction actionWithTitle:@"掃描工卡" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"打印正常");
        [[ZYScannerView sharedScannerView] showOnView:self.view block:^(NSString *str) {
            //里面写实现的方法。可以实现的功能
            NSLog(@"選擇了掃描");
            [self.beijingview bringSubviewToFront:self.view];
            NSString *message=[NSString stringWithFormat:@"%d;%@;;%@",_leixing,str,self.choosetype.text];
            UIImage *originImage = self.imageview.image;
            originImage=[self imageWithImage:originImage scaledToSize:CGSizeMake( 320.2,426.667)];
            NSData *data = UIImageJPEGRepresentation(originImage, 0.988f);
            NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            [self  insertwebsever:message image:encodedImageStr];
            [self beginjuhua];
        }];
        
    }];;
    [alertController addAction:home1Action];
    UIAlertAction *home2Action = [UIAlertAction actionWithTitle:@"直接上傳" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //里面写实现的方法。可以实现的功能
        NSLog(@"選擇了掃描");
        [self.beijingview bringSubviewToFront:self.view];
        NSString *message=[NSString stringWithFormat:@"%d;%@;;%@",_leixing,@"110",self.choosetype.text];
        UIImage *originImage = self.imageview.image;
        originImage=[self imageWithImage:originImage scaledToSize:CGSizeMake( 320.2,426.667)];
        NSData *data = UIImageJPEGRepresentation(originImage, 0.988f);
        NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        [self  insertwebsever:message image:encodedImageStr];
        [self beginjuhua];
        
    }];
    
    [alertController addAction:home2Action];
    
    NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:@"是否掃描工卡"];
    [alertControllerStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 6)];
    [alertControllerStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, 6)];
    [alertController setValue:alertControllerStr forKey:@"attributedTitle"];
    [home2Action setValue:[UIColor blueColor] forKey:@"titleTextColor"];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

@end
