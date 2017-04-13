//
//  Define.h
//  LYHTextViewAndPhotoPickForm
//
//  Created by 刘乙灏 on 2017/4/13.
//  Copyright © 2017年 刘乙灏. All rights reserved.
//

#ifndef Define_h
#define Define_h

#pragma mark -----日志输出-----
#ifdef DEBUG
#define DEBUGLOG(...) printf("[文件名:%s] [函数名:%s] [行号:%d] %s\n",__FILE__, __FUNCTION__, __LINE__, [[NSString stringWithFormat:__VA_ARGS__]UTF8String])
#define DDLOG_CURRENT_METHOD NSLog(@"%@-%@", NSStringFromClass([self class]), NSStringFromSelector(_cmd))
//#define DEBUGLOG(...) NSLog(__VA_ARGS__)
#define DEBUGLOG_FUNC DEBUGLOG(@"%s", __func__);
#define DEBUGLOG_REWRITE_FUNC DEBUGLOG(@"子类需要重写：%s", __FUNCTION__)
#else
#define DEBUGLOG(...)
#define DDLOG_CURRENT_METHOD
#define DEBUGLOG_FUNC
#define DEBUGLOG_REWRITE_FUNC
#endif

//屏幕的长宽
#define SCREEN_WIDTH ([[UIScreen mainScreen]bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen]bounds].size.height)
#pragma mark -----颜色相关-----
#define kCOLOR_P(r, g, b, p) [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:p * 1.0]
#define kCOLOR(r, g, b) kCOLOR_P(r, g, b, 1.0)

#endif /* Define_h */
