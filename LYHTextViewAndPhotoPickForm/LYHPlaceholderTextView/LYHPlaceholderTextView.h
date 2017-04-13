//
//  LYHPlaceholderTextView.h
//  GreenLands
//
//  Created by 刘乙灏 on 2017/4/5.
//  Copyright © 2017年 ricky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"
#import "LYHUIControl.h"

@interface LYHPlaceholderTextView : UITextView

@property (nonatomic, strong) UILabel *placeholderLabel;

- (void)showPlaceholder;

- (void)hidePlaceholder;

@end
