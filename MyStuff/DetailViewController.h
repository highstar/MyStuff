//
//  DetailViewController.h
//  MyStuff
//
//  Created by Gao Xing on 2018/8/1.
//  Copyright © 2018年 Gao Xing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) NSDate *detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

