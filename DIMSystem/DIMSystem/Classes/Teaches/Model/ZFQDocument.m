//
//  ZFQDocument.m
//  DIMSystem
//
//  Created by wecash on 15/4/30.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import "ZFQDocument.h"
#import "ZFQGeneralService.h"

@implementation ZFQDocument

- (instancetype)initWithDocInfo:(NSDictionary *)docInfo
{
    self = [super init];
    if (self) {
        self.name = docInfo[@"file_name"];
        
        NSNumber *sizeNum = docInfo[@"file_size"];
        self.fileSize = sizeNum.doubleValue;
        
        NSString *extention = [self.name pathExtension];
        
        if ([extention rangeOfString:@"doc"].length > 0) {  //doc docx
            self.documentType = ZFQDocumentTypeDOC;
        } else if ([extention rangeOfString:@"ppt"].length > 0) {   //ppt pptx
            self.documentType = ZFQDocumentTypePPT;
        } else if ([extention rangeOfString:@"xls"].length > 0) {   //xls xlsx
            self.documentType = ZFQDocumentTypeXLS;
        } else if ([extention isEqualToString:@"pdf"]) {
            self.documentType = ZFQDocumentTypePDF;
        } else if ([extention isEqualToString:@"txt"]) {
            self.documentType = ZFQDocumentTypeTXT;
        } else {
            self.documentType = ZFQDocumentTypeOther;
        }
        
    }
    return self;
}

- (NSString *)docPath
{
    NSString *path = [ZFQGeneralService documentURLString];
    //创建doc文件夹
    NSString *docPath = [path stringByAppendingPathComponent:@"doc"];
    //判断doc文件夹是否存在
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory = NO;
    BOOL result = [fileManager fileExistsAtPath:docPath isDirectory:&isDirectory];
    if (isDirectory == YES) {
        return docPath;
    } else {
        result = [fileManager createDirectoryAtPath:docPath withIntermediateDirectories:NO attributes:nil error:NULL];
        if (result == YES) {
            return docPath;
        } else {
            return nil;
        }
    }
}

- (NSURL *)previewItemURL
{
    NSString *docPath = [self docPath];
    if (docPath != nil) {
        //判断文件是否存在
        NSString *filePath = [docPath stringByAppendingPathComponent:self.name];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL result = [fileManager fileExistsAtPath:filePath isDirectory:NULL];
        if (result == YES) {
            return [NSURL fileURLWithPath:filePath];
        } else {
            return nil;
        }
    } else {
        return nil;
    }
    
    /*
    NSString *path = [ZFQGeneralService documentURLString];
    //创建doc文件夹
    NSString *docPath = [path stringByAppendingPathComponent:@"doc"];
    NSString *filePath = [docPath stringByAppendingPathComponent:self.name];
    //判断doc文件夹是否存在
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory = NO;
    BOOL result = [fileManager fileExistsAtPath:docPath isDirectory:&isDirectory];
    if (isDirectory == YES) {
        //再判断文件是否存在
        result = [fileManager fileExistsAtPath:filePath isDirectory:NULL];
        if (result == YES) {
            return [NSURL fileURLWithPath:filePath];
        } else {
            return nil;
        }
    } else {
        result = [fileManager createDirectoryAtPath:docPath withIntermediateDirectories:NO attributes:nil error:NULL];
        if (result == YES) {
            return [NSURL fileURLWithPath:[docPath stringByAppendingString:self.name]];
        } else {
            return nil;
        }
    }*/
}

- (NSString *)previewItemTitle
{
    return self.name;
}
@end
