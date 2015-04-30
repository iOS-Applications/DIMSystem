//
//  ZFQDocumentCellTableViewCell.h
//  DIMSystem
//
//  Created by wecash on 15/4/30.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZFQDocument;

@interface ZFQDocumentCellTableViewCell : UITableViewCell

@property (nonatomic,strong) UILabel *fileNameLabel;        //文件名
@property (nonatomic,strong) UILabel *fileSizeLabel;        //文件大小
@property (nonatomic,strong) UIImageView *thumbImgView;     //缩略图

- (void)bindModel:(ZFQDocument *)zfqDocument;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
