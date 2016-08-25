//
//  Constants.h
//  RabbitTiger
//
//  Created by Chenxi Cai on 14-10-29.
//  Copyright (c) 2014年 RabbitTiger. All rights reserved.
//

#ifdef __IPHONE_6_0

#define UILineBreakModeWordWrap                          NSLineBreakByWordWrapping
#define UILineBreakModeCharacterWrap   NSLineBreakByCharWrapping
#define UILineBreakModeClip                       NSLineBreakByClipping
#define UILineBreakModeHeadTruncation          NSLineBreakByTruncatingHead
#define UILineBreakModeTailTruncation         NSLineBreakByTruncatingTail
#define UILineBreakModeMiddleTruncation               NSLineBreakByTruncatingMiddle

#define UITextAlignmentLeft                          NSTextAlignmentLeft
#define UITextAlignmentCenter                    NSTextAlignmentCenter
#define UITextAlignmentRight                NSTextAlignmentRight

#endif   // #ifdef __IPHONE_6_0

#ifndef RabbitTiger_Header_h
#define RabbitTiger_Header_h


#define IOS8_OR_LATER	( [[[UIDevice currentDevice] systemVersion] compare:@"8.0"] != NSOrderedAscending )
#define IOS7_OR_LATER	( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )
#define IOS6_OR_LATER	( [[[UIDevice currentDevice] systemVersion] compare:@"6.0"] != NSOrderedAscending )
#define IOS5_OR_LATER	( [[[UIDevice currentDevice] systemVersion] compare:@"5.0"] != NSOrderedAscending )
#define IOS4_OR_LATER	( [[[UIDevice currentDevice] systemVersion] compare:@"4.0"] != NSOrderedAscending )
#define IOS3_OR_LATER	( [[[UIDevice currentDevice] systemVersion] compare:@"3.0"] != NSOrderedAscending )



#define IS_IPAD         (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
#define isIPhone4       ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define isIPhone5       ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define isIPhone6       ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define isIPhone6p      ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)




//------------------------------------------notification name------------------------------------------------//

#define LOGIN_OK                                @"LOGIN_OK"





typedef enum : NSUInteger {
    FromProduct,
    FromOrder,
} FromType;

/*本地化转换*/
#define L(key) \
[[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:nil]

//颜色创建
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
//是否为空或是[NSNull null]
#define NotNilAndNull(_ref)  (((_ref) != nil) && (![(_ref) isEqual:[NSNull null]]))
#define IsNilOrNull(_ref)   (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]))

//字符串是否为空
#define IsStrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref)isEqualToString:@""]))
//数组是否为空
#define IsArrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref) count] == 0))
//字符串是否合法（只用于定位）
#define IsLegitimate(_ref)  (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref)isEqualToString:@""]) || ([(_ref)isEqualToString:@"0"]))


#define OC(str) [NSString stringWithCString:(str) encoding:NSUTF8StringEncoding]

//释放ASIHttpRequest专用
#define HTTP_RELEASE_SAFELY(__POINTER) \
{\
if (nil != (__POINTER))\
{\
[__POINTER clearDelegatesAndCancel];\
TT_RELEASE_SAFELY(__POINTER);\
}\
}

//释放httpMessage专用
#define HTTPMSG_RELEASE_SAFELY(__REF) \
{\
if (nil != (__REF))\
{\
[__REF cancelDelegateAndCancel];\
TT_RELEASE_SAFELY(__REF);\
}\
}

//释放service专用
#define SERVICE_RELEASE_SAFELY(__REF) \
{\
if ((__REF) != nil)\
{ \
[__REF setDelegate:nil];\
TT_RELEASE_SAFELY(__REF);\
}\
}

//释放SNPopoverViewController
#define POP_RELEASE_SAFELY(__POINTER) \
{\
if (nil != (__POINTER))\
{\
[__POINTER dismissPopoverAnimated:YES];\
TT_RELEASE_SAFELY(__POINTER);\
}\
}

//安全释放
#define TT_RELEASE_SAFELY(__REF) { (__REF) = nil;}

//view安全释放
#define TTVIEW_RELEASE_SAFELY(__REF) { [__REF removeFromSuperview]; __REF = nil; }

//释放定时器
#define TT_INVALIDATE_TIMER(__TIMER) \
{\
[__TIMER invalidate];\
__TIMER = nil;\
}

#define DEBUGLOG 1

#ifdef DEBUGLOG
#       define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#       define DLog(...)
#endif

#define EncodeFormDic(dic,key) [dic[key] isKindOfClass:[NSString class]] ? dic[key] :([dic[key] isKindOfClass:[NSNumber class]] ? [dic[key] stringValue]:@"")


#define kTableViewNumberOfRowsKey       @"numberOfRows"
#define kTableViewCellListKey           @"cellList"
#define kTableViewCellHeightKey         @"cellHeight"
#define kTableViewCellTypeKey           @"cellType"
#define kTableViewCellDataKey           @"cellData"
#define kTableViewSectionHeaderHeightKey      @"sectionHeaderHeight"
#define kTableViewSectionHeaderTypeKey        @"sectionHeaderType"
#define kTableViewSectionFooterHeightKey      @"sectionFooterHeight"
#define kTableViewSectionFooterTypeKey        @"sectionFooterType"

//arc 支持performSelector:
#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

#endif
