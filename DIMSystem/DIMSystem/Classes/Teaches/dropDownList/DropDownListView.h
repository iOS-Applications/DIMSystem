//
//  DropDownListView.h
//  DropDownDemo
//
//  Created by zfq on 14-5-28.
//  Copyright (c) 2014年 zfq. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "DropDownChooseProtocol.h"
@protocol DropDownChooseDelegate,DropDownChooseDataSource;

#define SECTION_BTN_TAG_BEGIN   1000
#define SECTION_IV_TAG_BEGIN    3000
@interface DropDownListView : UIView<UITableViewDelegate,UITableViewDataSource>{
    NSInteger currentExtendSection;     //当前展开的section ，默认－1时，表示都没有展开
    CGFloat tableViewHeight;
    BOOL isExtend;                        //是否展开，默认是NO
}

@property (nonatomic, weak) id<DropDownChooseDelegate> dropDownDelegate;
@property (nonatomic, weak) id<DropDownChooseDataSource> dropDownDataSource;

@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic) BOOL  needOffset;     //是否需要偏移，默认是NO.对于myTableView的superView为scrollView时需要设置为YES
@property (nonatomic,strong) NSString *currentTitle;

- (id)initWithFrame:(CGRect)frame dataSource:(id)datasource delegate:(id) delegate tag:(NSInteger)tag;
- (void)setTitle:(NSString *)title inSection:(NSInteger) section;

- (BOOL)isShow;
- (void)hideExtendedChooseView;

- (void)reloadMyTableViewDataInSection:(NSInteger)section;
@end


@protocol DropDownChooseDelegate <NSObject>

@optional

- (void)dropDownListViewDidExtention:(DropDownListView *)listView;
- (void)dropDownListView:(DropDownListView *)listView chooseAtSection:(NSInteger)section index:(NSInteger)index;

@end

@protocol DropDownChooseDataSource <NSObject>
-(NSInteger)numberOfSectionsInDropDownListView:(DropDownListView *)listView;
-(NSInteger)numberOfRowsInSection:(NSInteger)section dropDownListView:(DropDownListView *)listView;
-(NSString *)titleInSection:(NSInteger)section index:(NSInteger) index dropDownListView:(DropDownListView *)listView;
-(NSInteger)defaultShowSection:(NSInteger)section dropDownListView:(DropDownListView *)listView;

@end