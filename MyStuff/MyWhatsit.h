//
//  MyWhatsit.h
//  MyStuff
//
//  Created by Gao Xing on 2018/8/1.
//  Copyright © 2018年 Gao Xing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define kWhatsitDidChangedNotification @"MyWhatsitDidChang"

@interface MyWhatsit : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) UIImage *image;
@property (readonly, nonatomic) UIImage *viewImage;

- (id)initWithName:(NSString*)name location:(NSString*)location;
- (void)postDidChangedNotification;

@end

NS_ASSUME_NONNULL_END
