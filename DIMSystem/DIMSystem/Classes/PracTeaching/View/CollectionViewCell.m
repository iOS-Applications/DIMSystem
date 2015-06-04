//
//  CollectionViewCell.m
//  collectionView
//
//  Created by shikee_app05 on 14-12-10.
//  Copyright (c) 2014年 shikee_app05. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor lightGrayColor];
        
        self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, CGRectGetWidth(self.frame)-10, CGRectGetHeight(self.frame)-10)];
        self.imgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.imgView];
        
        self.text = [[UILabel alloc]initWithFrame:CGRectMake(2, 0, CGRectGetWidth(self.frame)-14, CGRectGetWidth(self.frame)-25)];
        self.text.backgroundColor = [UIColor whiteColor];
        self.text.textAlignment = NSTextAlignmentCenter;
        self.text.numberOfLines = 0;
        [self.imgView addSubview:self.text];
        
        self.btnLable = [[UILabel alloc]initWithFrame:CGRectMake(4, CGRectGetMaxY(self.text.frame), CGRectGetWidth(self.frame)-18,45)];
        self.btnLable.backgroundColor = [UIColor whiteColor];
        self.btnLable.font = [UIFont systemFontOfSize:12];
        self.btnLable.textAlignment = NSTextAlignmentRight;
        
       [self.imgView addSubview:self.btnLable];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
