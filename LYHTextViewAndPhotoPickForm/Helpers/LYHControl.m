//
//  JLControl.m
//  BigPrivateSchool
//
//  Created by vincent on 15/9/29.
//  Copyright (c) 2015年 vincent. All rights reserved.
//
// 可以把特殊的功能点，写一个类方法来调用

#import "LYHControl.h"

//#define IOS7   [[UIDevice currentDevice]systemVersion].floatValue>=7.0

@implementation LYHControl

+ (void)cancelWebCache
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])  {
        [storage deleteCookie:cookie];
    }
}

+ (NSString *)valiMobile:(NSString *)mobile {
    if (mobile.length < 11)
    {
        return @"手机号长度只能是11位";
    }else{
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        
        if (isMatch1 || isMatch2 || isMatch3) {
            return nil;
        }else{
            return @"请输入正确的电话号码";
        }
    }
    return nil;
}

+ (BOOL)checkPhoneNumber:(NSString *)str
{
    NSString *regex = @"^(1)\\d{10}$";
    NSPredicate *phonenum = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [phonenum evaluateWithObject:str];
}

+ (void)saveLocalData:(id)obj forKey:(NSString *)key
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:obj];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)removeLocalData:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)getLocalData:(NSString *)key
{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

+ (CGFloat)getImageLengthWithImage:(UIImage *)image {
    NSData * imageData = UIImageJPEGRepresentation(image,1);
    CGFloat length = [imageData length]/1000;
    return length;
}

+ (UIImage *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0 , 0, newSize.width, newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

+ (UIImage *)scaleImageTo500Size:(UIImage *)image{
    DEBUGLOG(@"%f", [self getImageLengthWithImage:image]);
    if (500 < [self getImageLengthWithImage:image]) {
        image = [self imageWithImage:image scaledToSize:CGSizeMake(image.size.width / 2, image.size.height / 2)];
        return [self scaleImageTo500Size:image];
    }
    return image;
}

+ (UIImage *)resizableImageWithImage:(UIImage *)image {
    image = [image stretchableImageWithLeftCapWidth:image.size.width / 2.0 topCapHeight:image.size.height / 2.0];
    return image;
}

+(UIImage *)coreBlurImage:(UIImage *)image
           withBlurNumber:(CGFloat)blur {
    //博客园-FlyElephant
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage  *inputImage=[CIImage imageWithCGImage:image.CGImage];
    //设置filter
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:@(blur) forKey: @"inputRadius"];
    //模糊图片
    CIImage *result=[filter valueForKey:kCIOutputImageKey];
    CGImageRef outImage=[context createCGImage:result fromRect:[result extent]];
    UIImage *blurImage=[UIImage imageWithCGImage:outImage];
    CGImageRelease(outImage);
    return blurImage;
}

+(NSString *)stringFromDateWithHourAndMinute:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
}


+ (CGSize)labelAutoCalculateRectWith:(NSString*)text FontSize:(CGFloat)fontSize MaxSize:(CGSize)maxSize

{
    
    return [LYHControl labelAutoCalculateRectWith:text Font:[UIFont systemFontOfSize:fontSize] MaxSize:maxSize];
    
}

+ (CGSize)labelAutoCalculateRectWith:(NSString*)text Font:(UIFont *)font MaxSize:(CGSize)maxSize

{
    
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    
    paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping;
    
    if (!font||!text) {
        return  CGSizeMake(0, 0);
    }
    NSDictionary* attributes =@{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize labelSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    
    labelSize.height=ceil(labelSize.height);
    labelSize.width=ceil(labelSize.width);
    return labelSize;
    
}

+ (BOOL)isPunctuation:(NSString *)string {
    for (NSInteger i=0; i<string.length; i++) {
        NSInteger a = [string characterAtIndex:i];
        if (((a>='a'&&a<='z')||(a>='A'&&a<='Z'))) {
            return NO;
        }
    }
    return YES;
}

+ (BOOL)isString:(NSString *)string {
    for (NSInteger i=0; i<string.length; i++) {
        NSInteger a = [string characterAtIndex:i];
        if (!((a>='a'&&a<='z')||(a>='A'&&a<='Z'))) {
            return NO;
        }
    }
    return YES;
}

+ (BOOL)isNumber:(NSString*)string{
    if (string.length>0) {
        NSScanner* scan = [NSScanner scannerWithString:string];
        int val;
        return[scan scanInt:&val] && [scan isAtEnd];
    }else{
        return NO;
    }
}

+ (BOOL)isNumberAndString:(NSString*)string{
    if (string.length>0) {
        for (NSInteger i=0; i<string.length; i++) {
            NSInteger a=[string characterAtIndex:i];
            if (!((a>='0'&&a<='9')||(a>='a'&&a<='z')||(a>='A'&&a<='Z'))) {
                return NO;
            }
        }
        return YES;
    }else{
        return NO;
    }

}

+ (BOOL)isContainChinese:(NSString*)string{
    if (string.length>0) {
        for (NSInteger i=0; i<string.length; i++) {
            NSInteger a=[string characterAtIndex:i];
            //汉字编码区间
            if (a>0x4e00&&a<0x9fff) {
                return YES;
            }
        }
        return NO;
    }else{
        return NO;
    }
}

+ (void)noMoreDataWithTarget:(UIView *)target {
    UILabel *label = [[UILabel alloc] init];
    label.text = @"没有更多数据了";
    label.backgroundColor = [UIColor grayColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    label.alpha = 0;
    [target addSubview:label];
    [target bringSubviewToFront:label];
    //    kWS(ws);
    CGSize lableSize = [LYHControl labelAutoCalculateRectWith:label.text Font:label.font MaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(target).offset(-20);
        make.centerX.equalTo(target);
        make.height.mas_equalTo(lableSize.height);
        make.width.mas_equalTo(lableSize.width + 20);
    }];
    [UIView animateWithDuration:1 delay:0 options:0 animations:^{
        label.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1 delay:0 options:0 animations:^{
            label.alpha = 0;
        } completion:^(BOOL finished) {
            [label removeFromSuperview];
        }];
    }];
}

//正则表达式是对字符串操作的一种逻辑公式，就是用事先定义好的一些特定字符、及这些特定字符的组合，组成一个“规则字符串”，这个“规则字符串”用来表达对字符串的一种过滤逻辑。

+(NSString*)zhengze:(NSString*)str
{
    
    NSError *error;
    //http+:[^\\s]* 这是检测网址的正则表达式
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"http+:[^\\s]*" options:0 error:&error];//筛选
    
    if (regex != nil) {
        NSTextCheckingResult *firstMatch = [regex firstMatchInString:str options:0 range:NSMakeRange(0, [str length])];
        
        if (firstMatch) {
            NSRange resultRange = [firstMatch rangeAtIndex:0];
            //从urlString中截取数据
            NSString *result1 = [str substringWithRange:resultRange];
            NSLog(@"正则表达后的结果%@",result1);
            return result1;
            
        }
    }
    return nil;
    
}

/**错误提示*/
+ (void)errorTip:(UIViewController *)vc tip:(NSString *)string {
    UILabel *label = [[UILabel alloc] init];
    label.text = string;
    label.backgroundColor = [UIColor blackColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:13];
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.cornerRadius = 5;
    label.layer.masksToBounds = YES;
    label.alpha = 1;
    [vc.view addSubview:label];
    [vc.view bringSubviewToFront:label];
    CGSize lableSize = [LYHControl labelAutoCalculateRectWith:label.text Font:label.font MaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(vc.view).offset(-40);
        make.centerX.equalTo(vc.view);
        make.height.mas_equalTo(lableSize.height + 20);
        make.width.mas_equalTo(lableSize.width + 20);
    }];

    [UIView animateWithDuration:1.5 delay:0 options:0 animations:^{
        label.alpha = 0;
    } completion:^(BOOL finished) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [label removeFromSuperview];
        });
    }];
}

/**自定义截屏位置大小*/
- (void)screenShotWithView:(UIView *)view {
    //这里因为我需要全屏接图所以直接改了，宏定义iPadWithd为1024，SCREEN_HEIGHT为768，
    //    UIGraphicsBeginImageContextWithOptions(CGSizeMake(640, 960), YES, 0);     //设置截屏大小
    /**
     *  截图倍率
     */
    NSInteger mulriple = 0;
    if (SCREEN_WIDTH <= 375) {
        mulriple = 2;
    } else {
        mulriple = 3;
    }
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(SCREEN_WIDTH * mulriple, SCREEN_HEIGHT * mulriple), YES, 0);     //设置截屏大小
    [[view layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRef imageRef = viewImage.CGImage;
    //    CGRect rect = CGRectMake(166, 211, 426, 320);//这里可以设置想要截图的区域
    CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH * mulriple, SCREEN_HEIGHT * mulriple);//这里可以设置想要截图的区域
    CGImageRef imageRefRect =CGImageCreateWithImageInRect(imageRef, rect);
    UIImage *sendImage = [[UIImage alloc] initWithCGImage:imageRefRect];
    UIImageWriteToSavedPhotosAlbum(sendImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);//保存图片到照片库
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    _imageFinishSaveBlock(error);
}

+ (void)showAlertWithTitle:(NSString *)title viewController:(UIViewController *)vc buttonTitles:(NSString *)otherTitle block:(void (^ __nullable)(UIAlertAction *action)) otherBlock {
    [self showAlertWithTitle:title message:nil viewController:vc cancelButtonTitle:nil otherButtonTitles:otherTitle cancelBlock:nil otherBlock:otherBlock];
}

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message viewController:(UIViewController *)vc cancelButtonTitle:(NSString *)cancelTitle otherButtonTitles:(NSString *)otherTitle cancelBlock:(void (^ __nullable)(UIAlertAction *action))cancelBlock otherBlock:(void (^ __nullable)(UIAlertAction *action)) otherBlock {
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    if (cancelTitle) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            cancelBlock(action);
        }];
        [ac addAction:cancelAction];
    }
    
    if (otherTitle) {
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            otherBlock(action);
        }];
        
        [ac addAction:otherAction];
    }
    
    [vc presentViewController:ac animated:YES completion:nil];
}

+ (void)showActionWithTitle:(NSString *)title message:(NSString *)message viewController:(UIViewController *)vc actionTitle1:(NSString *)actionTitle1 actionTitle2:(NSString *)actionTitle2 actionBlock1:(void (^ __nullable)(UIAlertAction *action))actionBlock1 actionBlock2:(void (^ __nullable)(UIAlertAction *action)) actionBlock2 {
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
//    [cancelAction setValue:kMAIN_COLOR forKey:@"_titleTextColor"];
    [ac addAction:cancelAction];
    
    if (actionTitle1) {
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:actionTitle1 style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            actionBlock1(action);
        }];
//        [action1 setValue:kMAIN_COLOR forKey:@"_titleTextColor"];
        [ac addAction:action1];
    }
    
    if (actionTitle2) {
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:actionTitle2 style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            actionBlock2(action);
        }];
//        [action2 setValue:kMAIN_COLOR forKey:@"_titleTextColor"];
        [ac addAction:action2];
    }
    
    [vc presentViewController:ac animated:YES completion:nil];
}

+ (BOOL)isNull:(id)obj {
    return (obj == NULL || [obj isEqualToString:@"<null>"] || [obj length] == 0);
}

//+ (void)wechatPayWithDict:(NSDictionary *)dict {
//    PayReq *request = [[PayReq alloc] init];
//    /** 商家向财付通申请的商家id */
//    request.partnerId = [NSString stringWithFormat:@"%@", dict[@"partnerid"]];
//    /** 预支付订单 */
//    request.prepayId= dict[@"prepayid"];
//    /** 商家根据财付通文档填写的数据和签名 */
//    request.package = dict[@"package"];
//    /** 随机串，防重发 */
//    request.nonceStr= dict[@"noncestr"];
//    /** 时间戳，防重发 */
//    request.timeStamp= [dict[@"timestamp"] intValue];
//    /** 商家根据微信开放平台文档对数据做的签名 */
//    request.sign= dict[@"sign"];
//    /*! @brief 发送请求到微信，等待微信返回onResp
//     *
//     * 函数调用后，会切换到微信的界面。第三方应用程序等待微信返回onResp。微信在异步处理完成后一定会调用onResp。支持以下类型
//     * SendAuthReq、SendMessageToWXReq、PayReq等。
//     * @param req 具体的发送请求，在调用函数后，请自己释放。
//     * @return 成功返回YES，失败返回NO。
//     */
//    [WXApi sendReq: request];
//}
//
//+ (void)alipayWithTradeNO:(NSString *)trandeNO andOrderString:(NSString *)orderString {
//    [[NSUserDefaults standardUserDefaults] setObject:trandeNO forKey:kTradeNo];
////    /*
////     *商户的唯一的parnter和seller。
////     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
////     */
////    
////    /*============================================================================*/
////    /*=======================需要填写商户app申请的===================================*/
////    /*============================================================================*/
////    NSString *partner = @"2088122483957896";
////    NSString *seller = @"2088122483957896";
////    NSString *privateKey = @"nil";
////    /*============================================================================*/
////    /*============================================================================*/
////    /*============================================================================*/
////    
////    /*
////     *生成订单信息及签名
////     */
////    
////    //将商品信息赋予AlixPayOrder的成员变量
////    Order *order = [[Order alloc] init];
////    order.partner = partner;
////    order.sellerID = seller;
////    order.outTradeNO = trandeNO; //订单ID（由商家自行制定）
////    order.subject = [NSString stringWithFormat:@"Channel We - %@", trandeNO]; //商品标题
////    order.body = [NSString stringWithFormat:@"Channel We - %@", trandeNO]; //商品描述
////    order.totalFee = @"0.01"; //商品价格
////    order.notifyURL =  [NSString stringWithFormat:@"http://www.jyfair.com/APIRest/processorder"]; //回调URL
////    
////    order.service = @"mobile.securitypay.pay";
////    order.paymentType = @"1";
////    order.inputCharset = @"utf-8";
////    order.itBPay = @"30m";
////    order.showURL = [NSString stringWithFormat:@"http://www.jyfair.com/jxs"];
////    
//    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
//    NSString *appScheme = @"com.flysanta.jxs";
////
////    //将商品信息拼接成字符串
////    NSString *orderSpec = [order description];
////    NSLog(@"orderSpec = %@",orderSpec);
////    
////    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
////    id<DataSigner> signer = CreateRSADataSigner(privateKey);
////    NSString *signedString = [signer signString:orderSpec];
////    
////    //将签名成功字符串格式化为订单字符串,请严格按照该格式
////    NSString *orderString = nil;
////    if (signedString != nil) {
////        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
////                       orderSpec, signedString, @"RSA"];
////        DEBUGLOG(@"%@", orderString);
//        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
//            NSLog(@"reslut = %@",resultDic);
//            if ([resultDic[@"resultStatus"] isEqualToString:@"6002"]) { // 网络异常
//                [LYHControl showWebErrorAlertWithVC:self.cyl_tabBarController];
//            } else if ([resultDic[@"resultStatus"] isEqualToString:@"4000"]) {  // 支付失败
//                [LYHControl showErrorAlertWithVC:self.cyl_tabBarController andContent:@"订单支付失败" andLeftTitle:nil andRightTitle:@"好的" andLeftClick:nil andRightClick:^{
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                        UINavigationController *nc = (UINavigationController *)self.cyl_tabBarController.selectedViewController;
//                        [nc.visibleViewController cyl_popSelectTabBarChildViewControllerAtIndex:3 completion:^(__kindof UIViewController *selectedTabBarChildViewController) {
//                            
//                            [[NSNotificationCenter defaultCenter] postNotificationName:@"selfPaySuccess" object:nil userInfo:nil];
//                            
//                        }];
//                    });
//                }];
//            } else if ([resultDic[@"resultStatus"] isEqualToString:@"8000"]) {
//                [LYHControl showNormalAlertViewWithVC:self.cyl_tabBarController andContent:@"订单处理中，请稍后查看" andLeftTitle:nil andRightTitle:@"好的" andLeftClick:nil andRightClick:^{
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                        UINavigationController *nc = (UINavigationController *)self.cyl_tabBarController.selectedViewController;
//                        [nc.visibleViewController cyl_popSelectTabBarChildViewControllerAtIndex:3 completion:^(__kindof UIViewController *selectedTabBarChildViewController) {
//                            
//                            [[NSNotificationCenter defaultCenter] postNotificationName:@"selfPaySuccess" object:nil userInfo:nil];
//                            
//                        }];
//                    });
//                }];
//            } else if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
//                DEBUGLOG(@"支付成功%@", resultDic);
//                [LYHControl showNormalAlertViewWithVC:self.cyl_tabBarController andContent:@"支付成功" andLeftTitle:nil andRightTitle:@"好的" andLeftClick:nil andRightClick:^{
//                    
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                        UINavigationController *nc = (UINavigationController *)self.cyl_tabBarController.selectedViewController;
//                        [nc.visibleViewController cyl_popSelectTabBarChildViewControllerAtIndex:3 completion:^(__kindof UIViewController *selectedTabBarChildViewController) {
//                            
//                            [[NSNotificationCenter defaultCenter] postNotificationName:@"selfPaySuccess" object:nil userInfo:nil];
//                            
//                        }];
//                    });
//                }];
//            }
//            
//        }];
////    }
//}
#pragma mark -----道朋-----
+ (NSAttributedString *)changeTextStyleString:(NSString *)string
                                        color:(UIColor *)color
                                         font:(UIFont *)font
                                        range:(NSRange )range {
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
    [str addAttribute:NSForegroundColorAttributeName value:color range:range];
    [str addAttribute:NSFontAttributeName value:font range:range];
    return str;
}

/**
 *  @brief  两端对其
 *
 *  @param  maxInteger  最大字符长度
 *  @param  currentString   当前显示字符
 *  @param  label   显示label
 */
+ (void)conversionCharacterInterval:(NSInteger)maxInteger current:(NSString *)currentString withLabel:(UILabel *)label
{
    CGRect rect = [@"你" boundingRectWithSize:CGSizeMake(200,label.frame.size.height)
                                     options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                  attributes:@{NSFontAttributeName: label.font}
                                     context:nil];
    
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:currentString];
    [attrString addAttribute:NSKernAttributeName value:@(((maxInteger - currentString.length) * rect.size.width)/(currentString.length - 1)) range:NSMakeRange(0, currentString.length - 1)];
    label.attributedText = attrString;
}

/**
 *  数字转汉字
 */
+ (NSString *)arabicNumeralsToChinese:(NSInteger )number

{
    
    switch (number) {
            
        case 0:
            
            return @"零";
            
            break;
            
        case 1:
            
            return @"一";
            
            break;
            
        case 2:
            
            return @"二";
            
            break;
            
        case 3:
            
            return @"三";
            
            break;
            
        case 4:
            
            return @"四";
            
            break;
            
        case 5:
            
            return @"五";
            
            break;
            
        case 6:
            
            return @"六";
            
            break;
            
        case 7:
            
            return @"七";
            
            break;
            
        case 8:
            
            return @"八";
            
            break;
            
        case 9:
            
            return @"九";
            
            break;
            
        case 10:
            
            return @"十";
            
            break;
            
        case 100:
            
            return @"百";
            
            break;
            
        case 1000:
            
            return @"千";
            
            break;
            
        case 10000:
            
            return @"万";
            
            break;
            
        case 100000000:
            
            return @"亿";
            
            break;
            
        default:
            
            return nil;
            
            break;
            
    }
}

@end
