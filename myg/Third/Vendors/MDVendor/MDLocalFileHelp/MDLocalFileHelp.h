//
//  MDLocalFileHelp.h
//  MDYNews
//
//  Created by Medalands on 15/3/5.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDLocalFileHelp : NSObject

/**
 * 读取数组从本地文件
 */
+(NSMutableArray*)loadMutableArrayFromFile:(NSString*)name second:(NSString*)type;



/**
 * 保存数组从本地文件
 */
+(BOOL)saveMutableArrayToFile:(NSMutableArray *)withData second:(NSString*)name third:(NSString*)type;
//
/**
 *  读取字典从本地文件
 */
+(NSMutableDictionary*)loadMutableDictonaryFromFile:(NSString*)name second:(NSString*)type;

/**
 *  读取json从本地文件
 */
+(id)loadJSONFromFile:(NSString*)name type:(NSString*)type;
@end
