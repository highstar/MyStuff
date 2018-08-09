//
//  DetailViewController.h
//  MyStuff
//
//  Created by Gao Xing on 2018/8/1.
//  Copyright © 2018年 Gao Xing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyWhatsit.h"

@interface DetailViewController : UIViewController <UIActionSheetDelegate,
                                                    UIImagePickerControllerDelegate,
                                                    UINavigationControllerDelegate>

@property (strong, nonatomic) MyWhatsit *detailItem;

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *locationField;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)changedDetail:(id)sender;
- (IBAction)chosePicture:(id)sender;
- (IBAction)dismissKeyboard:(id)sender;

@end

