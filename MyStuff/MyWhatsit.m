//
//  MyWhatsit.m
//  MyStuff
//
//  Created by Gao Xing on 2018/8/1.
//  Copyright © 2018年 Gao Xing. All rights reserved.
//

#import "MyWhatsit.h"

@implementation MyWhatsit

- (id)initWithName:(NSString*)name location:(NSString*)location
{
    self = [super init];
    if (self) {
        self.name = name;
        self.location = location;
    }
    return self;
}

- (void)postDidChangedNotification
{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:kWhatsitDidChangedNotification
     object:self];
}

- (UIImage*)viewImage
{
    if (self.image != nil)
        return self.image;
    return [UIImage imageNamed:@"camera"];
}

@end
