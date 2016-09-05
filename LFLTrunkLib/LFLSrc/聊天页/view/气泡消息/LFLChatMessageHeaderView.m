//
//  LFLChatMessageHeaderView.m
//  LFLTrunkLib
//
//  Created by 啸峰 on 16/9/5.
//  Copyright © 2016年 张啸峰. All rights reserved.
//

#import "LFLChatMessageHeaderView.h"

@interface LFLChatMessageHeaderView()

@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) NSLayoutConstraint *widthContraint;
@property (nonatomic, weak) NSLayoutConstraint *heightContraint;

@end

@implementation LFLChatMessageHeaderView

- (void)awakeFromNib {
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    static NSString *identifier = @"LFLChatMessageHeaderView";
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = Color(230, 230, 230, 1);
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont fontWithName:@"Helvetica" size:12];
        label.backgroundColor = [UIColor colorWithRed:0xd9/255.0f green:0xd9/255.0f blue:0xd9/255.0f alpha:1];
        label.layer.cornerRadius = 3;
        label.layer.masksToBounds = YES;
        [self addSubview:label];
        
        [label setTranslatesAutoresizingMaskIntoConstraints:NO];
        NSMutableArray *labelAllContrains = [NSMutableArray array];
        [labelAllContrains addObject:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
        [labelAllContrains addObject:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
        
        _widthContraint = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0];
        [label addConstraint:_widthContraint];
        
        _heightContraint = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0];
        [label addConstraint:_heightContraint];
        
        [self addConstraints:labelAllContrains];
        _titleLabel = label;
        self.layer.shouldRasterize = YES;
        self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    [_titleLabel setText:title];
    CGSize size =[title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    _widthContraint.constant = size.width + 4;
    _heightContraint.constant = size.height + 2;
}
@end
