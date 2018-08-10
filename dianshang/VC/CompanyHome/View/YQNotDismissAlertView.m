//
//  YQNotDismissAlertView.m
//  kuainiao
//
//  Created by yunjobs on 17/2/23.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "YQNotDismissAlertView.h"

@implementation YQNotDismissAlertView

-(void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated {
    
    if (_notDisMiss)
    {
        return;
    }
    [super dismissWithClickedButtonIndex:buttonIndex animated:animated];
    
}

@end
