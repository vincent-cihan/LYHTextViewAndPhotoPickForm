//
//  LYHPlaceholderTextView.m
//  GreenLands
//
//  Created by 刘乙灏 on 2017/4/5.
//  Copyright © 2017年 ricky. All rights reserved.
//

#import "LYHPlaceholderTextView.h"

@implementation LYHPlaceholderTextView

- (instancetype)init {
    if (self = [super init]) {
        [self addSubview:self.placeholderLabel];
        NSInteger padding = 5;
        [self.placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(padding);
            make.left.equalTo(self).offset(padding);
            make.right.equalTo(self).offset(-padding);
        }];
    }
    return self;
}

- (UILabel *)placeholderLabel {
    if (!_placeholderLabel) {
        _placeholderLabel = [LYHUIControl labelwithFont:[UIFont systemFontOfSize:13] textColor:[UIColor lightGrayColor] text:@""];
    }
    return _placeholderLabel;
}

- (void)showPlaceholder {
    _placeholderLabel.hidden = NO;
}

- (void)hidePlaceholder {
    _placeholderLabel.hidden = YES;
}

@end
