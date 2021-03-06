//
//  TUBatteryProgressView.h
//  RedLine
//
//  Created by LXJ on 16/3/28.
//  Copyright © 2016年 cn. All rights reserved.
//

/*
 *
 * 电池页面三个充电状态View
 *
 */

#import <UIKit/UIKit.h>

@interface TUBatteryProgressView : UIView

@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdLabel;

+ (TUBatteryProgressView *)showProgressView;

- (void)updateProgress:(CGFloat)progress;

@end
