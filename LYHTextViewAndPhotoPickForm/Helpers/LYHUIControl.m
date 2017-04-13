//
//  LYHUIControl.m
//  test
//
//  Created by 刘乙灏 on 2017/3/16.
//  Copyright © 2017年 刘乙灏. All rights reserved.
//

#import "LYHUIControl.h"

@implementation LYHUIControl

#pragma mark ----- UILabel -----
+ (UILabel *)labelwithFont:(UIFont *)font
                      text:(NSString *)text {
    return [self labelwithFont:font textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft numberOfLines:1 text:text];
}

+ (UILabel *)labelwithFont:(UIFont *)font
                 textColor:(UIColor *)color
                      text:(NSString *)text {
    return [self labelwithFont:font textColor:color textAlignment:NSTextAlignmentLeft numberOfLines:1 text:text];
}

+ (UILabel *)labelwithFont:(UIFont *)font
                 textColor:(UIColor *)color
             textAlignment:(NSTextAlignment)textAlignment
             numberOfLines:(NSInteger)numberOfLines
                      text:(NSString *)text {
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.font = font;
    label.textColor = color;
    label.textAlignment = textAlignment;
    label.numberOfLines = numberOfLines;
    return label;
}

#pragma mark ----- UIImageView -----
+ (UIImageView *)imageViewWithImage:(UIImage *)image {
    UIImageView *imageView = [[UIImageView alloc] init];
    if (image) {
        imageView.image = image;
    }
    imageView.contentMode = UIViewContentModeScaleToFill;
    return imageView;
}

#pragma mark ----- UIButton -----
+ (UIButton *)buttonWithTitle:(NSString *)title
                         font:(UIFont *)font
                       target:(id)target
                       action:(SEL)action
{
    return [self buttonWithTitle:title font:font target:target action:action normalColor:[UIColor blackColor]];
}

+ (UIButton *)buttonWithTitle:(NSString *)title
                         font:(UIFont *)font
                       target:(id)target
                       action:(SEL)action
                  normalColor:(UIColor *)normalColor
{
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitleColor:normalColor forState:UIControlStateNormal];
    btn.titleLabel.font = font;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

+ (UIButton *)buttonWithTitle:(NSString *)title
                         font:(UIFont *)font
                       target:(id)target
                       action:(SEL)action
                  normalColor:(UIColor *)normalColor
               highLightColor:(UIColor *)highLightColor
{
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitleColor:normalColor forState:UIControlStateNormal];
    [btn setTitleColor:highLightColor forState:UIControlStateNormal];
    btn.titleLabel.font = font;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

#pragma mark ----- UITextField -----
+ (UITextField *)textFieldWithFont:(UIFont *)font
                        placeholder:(NSString *)placeholder{
    return [self textFieldWithColor:[UIColor blackColor] font:font placeholder:placeholder];
}

+ (UITextField *)textFieldWithColor:(UIColor *)color
                                     font:(UIFont *)font
                              placeholder:(NSString *)placeholder {
    return [self textFieldWithColor:color font:font clearButtonMode:UITextFieldViewModeNever placeholder:placeholder];
}

+ (UITextField *)textFieldWithColor:(UIColor *)color
                                     font:(UIFont *)font
                          clearButtonMode:(UITextFieldViewMode)clearButtonMode
                              placeholder:(NSString *)placeholder {
    UITextField *tf = [[UITextField alloc] init];
    tf.placeholder = placeholder;
    tf.textColor = color;
    tf.font = font;
    tf.clearButtonMode = UITextFieldViewModeWhileEditing;
    return tf;
}

@end
