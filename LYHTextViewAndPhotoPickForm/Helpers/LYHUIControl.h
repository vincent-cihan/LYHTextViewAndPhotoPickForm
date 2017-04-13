//
//  LYHUIControl.h
//  test
//
//  Created by 刘乙灏 on 2017/3/16.
//  Copyright © 2017年 刘乙灏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LYHUIControl : NSObject
#pragma mark ----- UILabel -----
/**
 *  Label 字形 文字
 */
+ (UILabel *)labelwithFont:(UIFont *)font
                      text:(NSString *)text;

/**
 *  Label 字形 字色 文字
 */
+ (UILabel *)labelwithFont:(UIFont *)font
                 textColor:(UIColor *)color
                      text:(NSString *)text;

/**
 *  Label 字形 字色 对齐 行数 文字
 */
+ (UILabel *)labelwithFont:(UIFont *)font
                       textColor:(UIColor *)color
                   textAlignment:(NSTextAlignment)textAlignment
                   numberOfLines:(NSInteger)numberOfLines
                            text:(NSString *)text;

#pragma mark ----- UIImageView -----
/**
 *  ImageView 图片
 */
+ (UIImageView *)imageViewWithImage:(UIImage *)image;

#pragma mark ----- UIButton -----
/**
 *  Button 文字 字体 target 事件
 */
+ (UIButton *)buttonWithTitle:(NSString *)title
                         font:(UIFont *)font
                       target:(id)target
                       action:(SEL)action;
/**
 *  Button 文字 字体 target 事件 字体颜色
 */
+ (UIButton *)buttonWithTitle:(NSString *)title
                         font:(UIFont *)font
                       target:(id)target
                       action:(SEL)action
                  normalColor:(UIColor *)normalColor;
/**
 *  Button 文字 字体 target 事件 字体颜色 高亮颜色
 */
+ (UIButton *)buttonWithTitle:(NSString *)title
                         font:(UIFont *)font
                       target:(id)target
                       action:(SEL)action
                  normalColor:(UIColor *)normalColor
               highLightColor:(UIColor *)highLightColor;

#pragma mark ----- UITextField -----
/**
 *  TextField 字体 默认
 */
+ (UITextField *)textFieldWithFont:(UIFont *)font
                       placeholder:(NSString *)placeholder;
/**
 *  TextField 字色 字体 默认
 */
+ (UITextField *)textFieldWithColor:(UIColor *)color
                               font:(UIFont *)font
                        placeholder:(NSString *)placeholder;
/**
 *  TextField 字色 字体 清除按钮类型 默认
 */
+ (UITextField *)textFieldWithColor:(UIColor *)color
                               font:(UIFont *)font
                    clearButtonMode:(UITextFieldViewMode)clearButtonMode
                        placeholder:(NSString *)placeholder;

@end
