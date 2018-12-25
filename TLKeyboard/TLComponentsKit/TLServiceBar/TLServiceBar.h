//
//  TLServiceBar.h
//  TLServiceBar
//
//  Created by Wcg on 2017/5/2.
//  Copyright © 2017年 Wcg. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TLServiceBar;

//**暂时未用*/
@protocol TLServiceBarDataSource <NSObject>

- (NSInteger)serviceBarNumOfSections:(TLServiceBar *)bar;
- (NSArray *)serviceBarSectionTitlesArr:(TLServiceBar *)bar;

- (NSInteger)serviceBar:(TLServiceBar *)bar numOfRowInSection:(NSInteger)section;
- (NSString *)serviceBar:(TLServiceBar *)bar titleForIndexPath:(NSIndexPath *)indexPath;


@end

@protocol TLServiceBarDelegate <NSObject>

- (void)didClickKeyBoradBtn:(TLServiceBar *)bar btn:(UIButton *)btn;

- (void)didSelectedMenuInSection:(NSInteger)section row:(NSInteger)row;

@optional
- (void)didShowKeyBoradBtn:(TLServiceBar *)bar;

- (void)didHiddenKeyBoradBtn:(TLServiceBar *)bar;

@end


@interface TLServiceBar : UIView

//**数据源代理*/
@property (nonatomic, weak) id<TLServiceBarDataSource> dataSource;
@property (nonatomic, weak) id<TLServiceBarDelegate> delegate;

//**菜单数据模型*/
@property (nonatomic, strong) NSArray *menuArr;

+ (instancetype)serviceBarWithMenuArr:(NSArray *)menuArr;

- (void)hiddenSubMenu;

- (void)hiddenToolBar;
- (void)showToolBar;


@end
