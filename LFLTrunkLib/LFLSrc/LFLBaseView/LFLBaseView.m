//
//  LFLBaseView.m
//  LFLTrunkLib
//
//  Created by 啸峰 on 16/9/1.
//  Copyright © 2016年 张啸峰. All rights reserved.
//

#import "LFLBaseView.h"

@implementation LFLBaseView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

+ (id)defaultView {
    NSString *nibName = NSStringFromClass([self class]);
    NSArray *cells = [[LFLTrunkBundle resourceBundle] loadNibNamed:nibName owner:self options:nil];
    id cell = cells[0];
    return cell;
}

@end
