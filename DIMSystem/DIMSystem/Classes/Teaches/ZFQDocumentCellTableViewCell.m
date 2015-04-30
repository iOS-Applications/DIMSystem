//
//  ZFQDocumentCellTableViewCell.m
//  DIMSystem
//
//  Created by wecash on 15/4/30.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import "ZFQDocumentCellTableViewCell.h"
#import "ZFQMecroDefine.h"
#import "ZFQDocument.h"

@implementation ZFQDocumentCellTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.fileNameLabel];
        [self.contentView addSubview:self.fileSizeLabel];
        [self.contentView addSubview:self.thumbImgView];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat imgViewWidth = 0;
    CGFloat imgViewHeight = 0;
    CGFloat marginTop = 8.0f;
    CGFloat marginLeft = 10.0f;
    
    //设置thubImgView的位置
    if (self.thumbImgView.image != nil) {
        UIImage *img = self.thumbImgView.image;
        imgViewWidth = img.size.width;
        imgViewHeight = img.size.height;
    }
    CGFloat contentHeight = self.contentView.frame.size.height;
    self.thumbImgView.bounds = CGRectMake(0, 0, imgViewWidth, imgViewHeight);
    self.thumbImgView.center = CGPointMake(imgViewWidth/2 + marginLeft, self.contentView.frame.size.height/2);
    
    //设置nameLabel的位置
    CGFloat maxX = CGRectGetMaxX(self.thumbImgView.frame);
    CGRect originFrame = CGRectZero;
    [self.fileNameLabel sizeToFit];
    originFrame = self.fileNameLabel.frame;
    originFrame.origin = CGPointMake(maxX + 2 * marginLeft, marginTop);
    self.fileNameLabel.frame = originFrame;
    
    //设置fileSizeLabel的位置
    [self.fileSizeLabel sizeToFit];
    originFrame = self.fileSizeLabel.frame;
    originFrame.origin = CGPointMake(maxX + 2 * marginLeft, contentHeight - marginTop - originFrame.size.height);
    self.fileSizeLabel.frame = originFrame;
}

- (UILabel *)fileNameLabel
{
    if (_fileNameLabel == nil) {
        _fileNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _fileNameLabel.font = [UIFont systemFontOfSize:15];
        _fileNameLabel.textColor = ZFQ_RGB(14, 14, 14, 1);
    }
    return _fileNameLabel;
}

- (UILabel *)fileSizeLabel
{
    if (_fileSizeLabel == nil) {
        _fileSizeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _fileSizeLabel.font = [UIFont systemFontOfSize:13];
        _fileSizeLabel.textColor = [UIColor grayColor];
    }
    return _fileSizeLabel;
}

- (UIImageView *)thumbImgView
{
    if (_thumbImgView == nil) {
        _thumbImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _thumbImgView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)bindModel:(ZFQDocument *)zfqDocument
{
    
    UIImage *img = nil;
    switch (zfqDocument.documentType) {
        case ZFQDocumentTypeDOC:
            img = [UIImage imageNamed:@"zfq_icon_doc"];
            break;
        case ZFQDocumentTypePPT:
            img = [UIImage imageNamed:@"zfq_icon_ppt"];
            break;
        case ZFQDocumentTypeXLS:
            img = [UIImage imageNamed:@"zfq_icon_xls"];
            break;
        case ZFQDocumentTypePDF:
            img = [UIImage imageNamed:@"zfq_icon_pdf"];
            break;
        case ZFQDocumentTypeTXT:
            img = [UIImage imageNamed:@"zfq_icon_txt"];
            break;
        default:
            img = [UIImage imageNamed:@"zfq_icon_other"];
            break;
    }
    
    self.thumbImgView.image = img;
    
    self.fileNameLabel.text = zfqDocument.name;
    self.fileSizeLabel.text = [self stringFromFileSize:zfqDocument.fileSize];
    
    [self layoutIfNeeded];
}

- (NSString *)stringFromFileSize:(double)fileSize
{
    NSString *sizeString = nil;
    if (fileSize <1000) {
        sizeString = [NSString stringWithFormat:@"%.0lfB",fileSize];
    } else if (fileSize >=1000 && fileSize < 1024) {
        sizeString = [NSString stringWithFormat:@"%.2lfKB",fileSize/1024.0];
    } else if (fileSize >=1024 && fileSize < 1024000){
        sizeString = [NSString stringWithFormat:@"%iKB",(int)(fileSize/1024)];
    } else if (fileSize >=1024000 && fileSize <1048576) {
        sizeString = [NSString stringWithFormat:@"%.2fMB",fileSize/1048576.0];
    } else if (fileSize >=1048576 && fileSize < 1048576000) {
        sizeString = [NSString stringWithFormat:@"%iMB",(int)(fileSize/1048576)];
    } else if (fileSize >=1048576000 && fileSize < 1048576000000) {
        sizeString = [NSString stringWithFormat:@"%.2fGB",fileSize/1048576000.0];
    } else {
        sizeString = [NSString stringWithFormat:@"%.0fGB",fileSize/1048576000];
    }
    return sizeString;
}

@end


