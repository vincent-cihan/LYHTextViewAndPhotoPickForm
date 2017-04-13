//
//  JLControl.h
//  BigPrivateSchool
//
//  Created by vincent on 15/9/29.
//  Copyright (c) 2015年 vincent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Masonry.h"
#import "LYHUIControl.h"
#import "Define.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^imageFinishSaveBlock)(NSError *error);

@interface LYHControl : NSObject
+ (void)cancelWebCache;                                 //清除UIWebView的缓存
/**
 *  手机号码是否合法
 */
+ (NSString *)valiMobile:(NSString *)mobile;
+ (BOOL)checkPhoneNumber:(NSString *)str;               //验证手机号码是否合法
+ (void)saveLocalData:(id)obj forKey:(NSString *)key;   //保存数据到本地
+ (void)removeLocalData:(NSString *)key;                //移除本地数据
+ (id)getLocalData:(NSString *)key;                     //读取本地数据
+ (CGFloat)getImageLengthWithImage:(UIImage *)image;    // 获取图片大小kb
+ (UIImage *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize; //根据尺寸压缩图片
+ (UIImage *)scaleImageTo500Size:(UIImage *)image;  // 压缩图片到500kb以下
/**
 *  拉伸图片
 */
+ (UIImage *)resizableImageWithImage:(UIImage *)image;

/**
 *  高斯模糊
 **/
+(UIImage *)coreBlurImage:(UIImage *)image
           withBlurNumber:(CGFloat)blur;

#pragma mark 创建时间转换字符串
+(NSString *)stringFromDateWithHourAndMinute:(NSDate *)date;

#pragma mark 对字符串的判断 对nil进行了处理
/**
 *  是否全是标点
 */
+ (BOOL)isPunctuation:(NSString *)string;
/**
 *  是否全是数字
 */
+ (BOOL)isNumber:(NSString*)string;
/**
 *  是否全是字母
 */
+ (BOOL)isString:(NSString *)string;
+ (BOOL)isNumberAndString:(NSString*)string;
+ (BOOL)isContainChinese:(NSString*)string;


#pragma mark 返回字体尺寸
+ (CGSize)labelAutoCalculateRectWith:(NSString*)text FontSize:(CGFloat)fontSize MaxSize:(CGSize)maxSize;
+ (CGSize)labelAutoCalculateRectWith:(NSString*)text Font:(UIFont *)font MaxSize:(CGSize)maxSize;

/**下拉刷新没有更多数据*/
+ (void)noMoreDataWithTarget:(UIView *)target;

/**判断是否是网址*/
+(NSString*)zhengze:(NSString*)str;

/**错误提示*/
+ (void)errorTip:(UIViewController *)vc  tip:(NSString *)string;

/**屏幕截图，自定义view大小*/
- (void)screenShotWithView:(UIView *)view;

/**自定义弹窗*/
+ (void)showAlertWithTitle:(NSString *)title viewController:(UIViewController *)vc buttonTitles:(NSString *)otherTitle block:(void (^ __nullable)(UIAlertAction *action))otherBlock;

+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
            viewController:(UIViewController *)vc
         cancelButtonTitle:(NSString *)cancelTitle
         otherButtonTitles:(NSString *)otherTitle
               cancelBlock:(void (^ __nullable)(UIAlertAction *action))cancelBlock
                otherBlock:(void (^ __nullable)(UIAlertAction *action)) otherBlock;

/**自定义actionSheet*/
+ (void)showActionWithTitle:(NSString *)title
                    message:(NSString *)message
             viewController:(UIViewController *)vc
               actionTitle1:(NSString *)actionTitle1
               actionTitle2:(NSString *)actionTitle2
               actionBlock1:(void (^ __nullable)(UIAlertAction *action))actionBlock1
               actionBlock2:(void (^ __nullable)(UIAlertAction *action)) actionBlock2;

@property (nonatomic, copy) imageFinishSaveBlock imageFinishSaveBlock;


/**
 *  判断是否空值,yes 则空
 */
+ (BOOL)isNull:(id)obj;

//+ (void)wechatPayWithDict:(NSDictionary *)dict;
//
//+ (void)alipayWithTradeNO:(NSString *)trandeNO andOrderString:(NSString *)orderString;

/**
 测试请求错误
 */
+ (void)DebugRequestWithPostUrlStr:(NSString *)urlStr andParam:(NSDictionary *)param;

#pragma mark -----道朋-----
+ (NSAttributedString *)changeTextStyleString:(NSString *)string color:(UIColor *)color font:(UIFont *)font range:(NSRange )range;

/**
 *  两端对齐
 *
 *  @param maxInteger    最大字符长度
 *  @param currentString 字符串
 *  @param label         label
 */
+ (void)conversionCharacterInterval:(NSInteger)maxInteger current:(NSString *)currentString withLabel:(UILabel *)label;

/**
 *  数字转汉字
 */
+ (NSString *)arabicNumeralsToChinese:(NSInteger)number;

NS_ASSUME_NONNULL_END

@end
