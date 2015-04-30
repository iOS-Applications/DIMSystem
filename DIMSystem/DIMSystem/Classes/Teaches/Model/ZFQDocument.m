//
//  ZFQDocument.m
//  DIMSystem
//
//  Created by wecash on 15/4/30.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import "ZFQDocument.h"

@implementation ZFQDocument

- (instancetype)initWithDocInfo:(NSDictionary *)docInfo
{
    self = [super init];
    if (self) {
        self.name = docInfo[@"name"];
        
        NSNumber *sizeNum = docInfo[@"fileSize"];
        self.fileSize = sizeNum.doubleValue;
        
        NSString *extention = [self.name pathExtension];
        
        if ([extention isEqualToString:@"doc"]) {
            self.documentType = ZFQDocumentTypeDOC;
        } else if ([extention isEqualToString:@"ppt"]) {
            self.documentType = ZFQDocumentTypePPT;
        } else if ([extention isEqualToString:@"xls"]) {
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
@end
