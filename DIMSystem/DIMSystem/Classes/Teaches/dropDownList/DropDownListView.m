//
//  DropDownListView.m
//  DropDownDemo
//
//  Created by zfq on 14-5-28.
//  Copyright (c) 2014年 zfq. All rights reserved.
//

#import "DropDownListView.h"
#define DEGREES_TO_RADIANS(angle) ((angle)/180.0 *M_PI)
#define RADIANS_TO_DEGREES(radians) ((radians)*(180.0/M_PI))

@implementation DropDownListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame dataSource:(id)datasource delegate:(id) delegate tag:(NSInteger)tag
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        currentExtendSection = -1;
        isExtend = NO;
        self.dropDownDataSource = datasource;
        self.dropDownDelegate = delegate;
        self.tag =tag;
        _needOffset = NO;
        
        NSInteger sectionNum =0;
        if ([self.dropDownDataSource respondsToSelector:@selector(numberOfSectionsInDropDownListView:)] ) {
            sectionNum = [self.dropDownDataSource numberOfSectionsInDropDownListView:self];
        }
        
        if (sectionNum == 0) {
            self = nil;
        }
        
        //初始化默认显示view
        CGFloat sectionWidth = (1.0*(frame.size.width)/sectionNum);
        for (int i = 0; i <sectionNum; i++) {
            UIButton *sectionBtn = [[UIButton alloc] initWithFrame:CGRectMake(sectionWidth*i, 1, sectionWidth, frame.size.height-2)];
            sectionBtn.tag = SECTION_BTN_TAG_BEGIN + i;
            [sectionBtn addTarget:self action:@selector(tapSectionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            NSString *sectionBtnTitle = @"--";
            if ([self.dropDownDataSource respondsToSelector:@selector(titleInSection:index:dropDownListView:)]) {
                sectionBtnTitle = [self.dropDownDataSource titleInSection:i index:[self.dropDownDataSource defaultShowSection:i dropDownListView:self] dropDownListView:self];
                if (i == 0) {
                    _currentTitle = sectionBtnTitle;
                }
            }
            [sectionBtn  setTitle:sectionBtnTitle forState:UIControlStateNormal];
            [sectionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            sectionBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
            [self addSubview:sectionBtn];
            
            UIImageView *sectionBtnIv = [[UIImageView alloc] initWithFrame:CGRectMake(sectionWidth*i +(sectionWidth - 16), (self.frame.size.height-12)/2, 12, 12)];
            [sectionBtnIv setImage:[UIImage imageNamed:@"down_dark.png"]];
            [sectionBtnIv setContentMode:UIViewContentModeScaleToFill];
            sectionBtnIv.transform = CGAffineTransformRotate(sectionBtnIv.transform, M_PI_2);
            sectionBtnIv.tag = SECTION_IV_TAG_BEGIN + i;
            
            [self addSubview: sectionBtnIv];
            
            if (i<sectionNum) {   //i<sectionNum && i != 0
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - 1, frame.size.width, 1)];
                lineView.backgroundColor = [UIColor lightGrayColor];
                [self addSubview:lineView];
            }
        
        }
        
    }
    return self;
}

-(void)tapSectionBtnAction:(UIButton *)btn
{
    NSInteger section = btn.tag - SECTION_BTN_TAG_BEGIN;
        
    if (currentExtendSection == section) {
        [self hideExtendedChooseView];
    }else{
        currentExtendSection = section;
        UIImageView *currentIV = (UIImageView *)[self viewWithTag:SECTION_IV_TAG_BEGIN + currentExtendSection];
        [UIView animateWithDuration:0.3 animations:^{
            currentIV.transform = CGAffineTransformRotate(currentIV.transform, -M_PI_2);
        }];
        
        [self showChooseListViewInSection:currentExtendSection choosedIndex:[self.dropDownDataSource defaultShowSection:currentExtendSection dropDownListView:self]];
    }
    
    if ([self.dropDownDelegate respondsToSelector:@selector(dropDownListViewDidExtention:)]) {
        [self.dropDownDelegate dropDownListViewDidExtention:self];
    }
}

- (void)setTitle:(NSString *)title inSection:(NSInteger) section
{
    UIButton *btn = (id)[self viewWithTag:SECTION_BTN_TAG_BEGIN +section];
    [btn setTitle:title forState:UIControlStateNormal];
    if (section == 0) {
        _currentTitle = title;
    }
}

- (BOOL)isShow
{
    if (currentExtendSection == -1) {
        return NO;
    }
    return YES;
}

-  (void)hideExtendedChooseView
{
    if (currentExtendSection != -1) {
        
        CGRect rect = self.myTableView.frame;
        rect.size.height = 0;
        [UIView animateWithDuration:0.3 animations:^{
            self.myTableView.frame = rect;
            UIImageView *currentIV= (UIImageView *)[self viewWithTag:(SECTION_IV_TAG_BEGIN +currentExtendSection)];
            currentIV.transform = CGAffineTransformMakeRotation(M_PI_2);
        }completion:^(BOOL finished) {
            [self.myTableView removeFromSuperview];
            
            //设置为原始的frame值
            CGRect originFrame = _myTableView.frame;
            originFrame.size.height = tableViewHeight;
            _myTableView.frame = originFrame;
            currentExtendSection = -1;
        }];
    }
}

-(void)showChooseListViewInSection:(NSInteger)section choosedIndex:(NSInteger)index
{
    if (_myTableView == nil) {
        CGRect tableViewFrame = [self tableViewFrameInsection:section];
        self.myTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        [self.superview addSubview:_myTableView];
        _myTableView.frame = tableViewFrame;
    }
    
    if (_myTableView.superview == nil) {
        _myTableView.frame = [self tableViewFrameInsection:section];
        [self.superview addSubview:_myTableView];
    }
        //添加展开动画
    CGRect originFrame = _myTableView.frame;
    originFrame.size.height = 0;
    _myTableView.frame = originFrame;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect originFrame = _myTableView.frame;
        originFrame.size.height = tableViewHeight;
        _myTableView.frame = originFrame;
    }];
    [_myTableView reloadData];
    
}

- (CGRect)tableViewFrameInsection:(NSInteger)section
{
    tableViewHeight = 0;
    
    //1.先计算tableViewHeight
    CGFloat tempHeight = 0;
    NSInteger rows = [_dropDownDataSource numberOfRowsInSection:section dropDownListView:self];
    if (rows <= 5) {
        for (NSInteger i = 0; i < rows; i++) {
            tempHeight = [self tableView:_myTableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:section]];
            tableViewHeight += tempHeight;
        }
    } else {
        for (NSInteger i = 0; i < 5; i++) {
            tempHeight = [self tableView:_myTableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:section]];
            tableViewHeight += tempHeight;
        }
    }
    
    //2.再判断tableView往上还是往下展开
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat tableViewOriginY = CGRectGetMaxY(self.frame);
    BOOL up = NO;
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        CGFloat offset = screenHeight - (CGRectGetMaxY(self.frame) - scrollView.contentOffset.y);
        if (offset < 60) {
            //往上展开
            tableViewOriginY = self.frame.origin.y - tableViewHeight;
            up = YES;
        } else {
        }
    } else {
        //如果tableView离边缘距离小于60，则往上展开
        if (screenHeight - tableViewOriginY > 60) {
            tableViewOriginY = self.frame.origin.y - tableViewHeight;
            up = YES;
        } else {
        }
    }
    
    if (up == NO) {
        if ([self.superview isKindOfClass:[UIScrollView class]]) {
            UIScrollView *scrollView = (UIScrollView *)self.superview;
            CGFloat maxY = tableViewHeight + CGRectGetMaxY(self.frame);
            if (maxY -  scrollView.contentOffset.y > screenHeight) {
                
                CGFloat tempF = maxY -  scrollView.contentOffset.y - screenHeight;
                tableViewHeight -= tempF  + 10;
            }
        } else {
            CGFloat maxY = tableViewHeight + CGRectGetMaxY(self.frame);
            if (maxY > screenHeight) {
                tableViewHeight -= maxY - screenHeight + 10;
            }

        }
    }
    return CGRectMake(self.frame.origin.x, tableViewOriginY, self.frame.size.width, tableViewHeight);
}

-(void)bgTappedAction:(UITapGestureRecognizer *)tap
{
    UIImageView *currentIV = (UIImageView *)[self viewWithTag:(SECTION_IV_TAG_BEGIN + currentExtendSection)];
    [UIView animateWithDuration:0.3 animations:^{
        currentIV.transform = CGAffineTransformRotate(currentIV.transform, DEGREES_TO_RADIANS(90));
    }];
    [self hideExtendedChooseView];
}

#pragma mark -- UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dropDownDelegate respondsToSelector:@selector(dropDownListView:chooseAtSection:index:)]) {
        NSString *chooseCellTitle = [self.dropDownDataSource titleInSection:currentExtendSection index:indexPath.row dropDownListView:self];
        _currentTitle = chooseCellTitle;
        UIButton *currentSectionBtn = (UIButton *)[self viewWithTag:SECTION_BTN_TAG_BEGIN + currentExtendSection];
        [currentSectionBtn setTitle:chooseCellTitle forState:UIControlStateNormal];
        
        [self.dropDownDelegate dropDownListView:self chooseAtSection:currentExtendSection index:indexPath.row];
        [self hideExtendedChooseView];
    }
}

#pragma mark -- UITableView DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dropDownDataSource numberOfRowsInSection:currentExtendSection dropDownListView:self];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.textLabel.text = [self.dropDownDataSource titleInSection:currentExtendSection index:indexPath.row dropDownListView:self];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    return cell;
}

- (void)reloadMyTableViewDataInSection:(NSInteger)section;
{
    if ([self.dropDownDataSource respondsToSelector:@selector(numberOfSectionsInDropDownListView:)] ) {
        [self.dropDownDataSource numberOfSectionsInDropDownListView:self];
    }
    if ([self.dropDownDataSource respondsToSelector:@selector(titleInSection:index:dropDownListView:)]) {
        NSString *title = [self.dropDownDataSource titleInSection:section index:[self.dropDownDataSource defaultShowSection:section dropDownListView:self] dropDownListView:self];
        _currentTitle = title;
        if ([self.dropDownDataSource respondsToSelector:@selector(defaultShowSection:dropDownListView:)]) {
            NSInteger idx = [self.dropDownDataSource defaultShowSection:section dropDownListView:self];
            //获取tag
            NSInteger tag = SECTION_BTN_TAG_BEGIN + idx;
            UIButton *sectionBtn = (UIButton *)[self viewWithTag:tag];
            if (sectionBtn != nil) {
                [sectionBtn setTitle:title forState:UIControlStateNormal];
            }
        }
    }
    
}
@end
