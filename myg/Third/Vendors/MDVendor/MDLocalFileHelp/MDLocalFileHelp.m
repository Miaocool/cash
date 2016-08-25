//
//  MDLocalFileHelp.m
//  MDYNews
//
//  Created by Medalands on 15/3/5.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import "MDLocalFileHelp.h"

#import "NSString+Category.h"


@implementation MDLocalFileHelp


+(NSMutableArray*)loadMutableArrayFromFile:(NSString*)name second:(NSString*)type{
    NSString *error = nil;
    
    NSPropertyListFormat format;
    NSMutableArray *array = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *str_ = [NSString stringWithFormat:@"%@.%@",name,type];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:str_];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        filePath = [[NSBundle mainBundle] pathForResource:name ofType:type];
    }
    
    
    
    
    
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:filePath];
    array = (NSMutableArray *)[NSPropertyListSerialization propertyListFromData:plistXML
                                                               mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                                                         format:&format
                                                               errorDescription:&error];
    
    
    
    return array;
}


+(BOOL)saveMutableArrayToFile:(NSMutableArray *)withData second:(NSString*)name third:(NSString*)type{
    NSError *error0;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *str_ = [NSString stringWithFormat:@"%@.%@",name,type];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:str_];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        filePath = [[NSBundle mainBundle] pathForResource:name ofType:type];
    }
    
    
    if ([[NSFileManager defaultManager] removeItemAtPath:filePath error:&error0] != YES)
        NSLog(@"Unable to delete file: %@", [error0 localizedDescription]);
    
    
    
    NSString *error = nil;
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:withData format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
    if(plistData) {
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSString *str_ = [NSString stringWithFormat:@"%@.%@",name,type];
        
        return [plistData writeToFile:[documentsDirectory stringByAppendingPathComponent:str_] atomically:YES];
    } else {
        NSLog(@"********writeToFile*********%@", error);
        
        return FALSE;
    }
}



+(NSMutableDictionary*)loadMutableDictonaryFromFile:(NSString*)name second:(NSString*)type{
    NSString *error = nil;
    NSPropertyListFormat format;
    NSMutableDictionary *dic = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *str_ = [NSString stringWithFormat:@"%@.%@",name,type];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:str_];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        filePath = [[NSBundle mainBundle] pathForResource:name ofType:type];
    }
    
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:filePath];
    dic = (NSMutableDictionary *)[NSPropertyListSerialization propertyListFromData:plistXML
                                                                  mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                                                            format:&format
                                                                  errorDescription:&error];
    return dic;
}


+(BOOL)saveMutableDictonaryToFile:(NSMutableDictionary *)withData second:(NSString*)name third:(NSString*)type{
    NSString *error = nil;
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:withData format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
    if(plistData) {
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSString *str_ = [NSString stringWithFormat:@"%@.%@",name,type];
        
        return [plistData writeToFile:[documentsDirectory stringByAppendingPathComponent:str_] atomically:YES];
    } else {
        return FALSE;
    }
}

+(id)loadJSONFromFile:(NSString*)name type:(NSString*)type{
    
    NSString *resourcePath=[[NSBundle mainBundle] resourcePath];
    NSString *filePath=[resourcePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",name,type]];
    
    NSError *error = nil;
    
    NSString *json=[[NSString alloc]initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    
    
    if (json == nil)
    {
        NSLog(@"读取的数据不存在");
    }else
    {
    }
    
    id json_=[json JSON_MD];
    return json_;
}


@end
