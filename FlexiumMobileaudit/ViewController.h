//
//  ViewController.h
//  FlexiumMobileaudit
//
//  Created by flexium on 2016/11/17.
//  Copyright © 2016年 FLEXium. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *chuangweilabel;

@end

