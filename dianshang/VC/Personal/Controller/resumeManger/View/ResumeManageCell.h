//
//  ResumeManageCell.h
//  dianshang
//
//  Created by yunjobs on 2017/11/8.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ResumeManageSubEntity;

@interface ResumeManageCell : UITableViewCell

- (void)setItem:(ResumeManageSubEntity *)item indexPath:(NSIndexPath *)indexPath totalCount:(NSInteger)totalCount;

@end
