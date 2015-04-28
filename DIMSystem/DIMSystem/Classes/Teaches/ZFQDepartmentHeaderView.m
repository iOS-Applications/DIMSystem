//
//  ZFQDepartmentHeaderView.m
//  
//
//  Created by zfq on 14-10-31.
//  Copyright (c) 2014年 zfq. All rights reserved.
//

#import "ZFQDepartmentHeaderView.h"

@interface ZFQDepartmentHeaderView()
{
    UIButton *btn;
    UILabel *detailLabel;
}
@end

@implementation ZFQDepartmentHeaderView

+ (instancetype)zfqHeaderViewWithTableView:(UITableView *)tableView
{
    static NSString *ID=@"headerView";
    ZFQDepartmentHeaderView *headerView=[tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (headerView==nil) {
        headerView=[[ZFQDepartmentHeaderView alloc]initWithReuseIdentifier:ID];
    }
    return headerView;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageNamed:@"buddy_header_bg"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"buddy_header_bg_highlighted"] forState:UIControlStateHighlighted];
        [btn setImage:[UIImage imageNamed:@"buddy_header_arrow"] forState:UIControlStateNormal];
        btn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
        btn.imageView.contentMode=UIViewContentModeCenter;
        btn.imageView.clipsToBounds=NO;
        btn.contentEdgeInsets=UIEdgeInsetsMake(0, 10, 0, 0);
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        btn.titleLabel.font=[UIFont systemFontOfSize:15];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(tapBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
        
        detailLabel=[[UILabel alloc]init];
        detailLabel.textColor=[UIColor grayColor];
        detailLabel.textAlignment=NSTextAlignmentRight;
        detailLabel.font=[UIFont systemFontOfSize:14];
        [self.contentView addSubview:detailLabel];
        
        self.fold = YES;
    }
    return self;
}

- (void)setTitleString:(NSString *)titleString
{
    if (btn != nil) {
        [btn setTitle:titleString forState:UIControlStateNormal];
    }
}

- (void)setDetailString:(NSString *)numString
{
    if (detailLabel != nil) {
        detailLabel.text = numString;
        [self layoutIfNeeded];
    }
}

- (void)setFold:(BOOL)fold
{
    _fold = fold;
    if (btn != nil) {
        if (fold == YES) {
            btn.imageView.transform = CGAffineTransformMakeRotation(0);
        } else {
            btn.imageView.transform = CGAffineTransformMakeRotation(M_PI_2);
        }
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    //此处frame和bounds的y值是不同的，此处因为我们的x和y始终是0，所以用bounds
    btn.frame=self.bounds;
    
    //设置numberLabel坐标
    [detailLabel sizeToFit];
    CGRect originFrame = detailLabel.frame;
    detailLabel.center = CGPointMake(self.frame.size.width - (originFrame.size.width/2 + 10), self.frame.size.height/2);
}

-(void)tapBtnAction:(UIButton *)headerViewBtn
{
    if (self.selectCompletionBlk != nil) {
        self.selectCompletionBlk(self);
    }
}



@end
