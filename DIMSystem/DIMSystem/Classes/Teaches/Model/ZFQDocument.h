//
//  ZFQDocument.h
//  DIMSystem
//
//  Created by wecash on 15/4/30.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuickLook/QuickLook.h>

typedef NS_ENUM(NSInteger, ZFQDocumentType) {
    ZFQDocumentTypeDOC,
    ZFQDocumentTypePPT,
    ZFQDocumentTypeXLS,
    ZFQDocumentTypePDF,
    ZFQDocumentTypeTXT,
    ZFQDocumentTypeOther
};

@interface ZFQDocument : NSObject <QLPreviewItem>

@property (nonatomic,strong) NSString *name;        //文件名
@property (nonatomic) double fileSize;             //文件大小
@property (nonatomic) ZFQDocumentType documentType; //文档类型

- (instancetype)initWithDocInfo:(NSDictionary *)docInfo;

- (NSString *)docPath;

@end
