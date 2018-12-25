//
//  TLServiceBtn.m
//  TLServiceBar
//
//  Created by Wcg on 2017/5/2.
//  Copyright © 2017年 Wcg. All rights reserved.
//

#import "TLServiceBtnView.h"
#import "TLServicePanel.h"
#import "Masonry.h"
#import "TLKit.h"


@interface TLServiceBtnView () <TLServicePanelDelegate>

@property (nonatomic, strong) UIView *backGroupImageView;

@property (nonatomic, strong) UIButton *btn;

@end


@implementation TLServiceBtnView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    //设置背景图
    [self addSubview:self.backGroupImageView];
    [_backGroupImageView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.edges.mas_equalTo(self).insets(UIEdgeInsetsZero);
    }];

    //设置按钮
    [self addSubview:self.btn];
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {

        make.edges.mas_equalTo(self).insets(UIEdgeInsetsZero);
    }];
}

#pragma mark - public
- (void)changeShowStatus:(void (^)(BOOL finished, BOOL isShowed))completion
{
    if (_subMenus.count == 0) return;
    if (_isShowPanel) {
        [self hiddenPanel:^(BOOL finished) {
            if (completion) {
                completion(finished, NO);
            }
        }];
    } else {
        [self showPanel:^(BOOL finished) {
            if (completion) {
                completion(finished, YES);
            }
        }];
    }
}

- (void)showPanel:(void (^)(BOOL finished))completion
{
    if (!_isShowPanel) {
        TLWeakSelf(self);
        [UIView animateWithDuration:0.15 animations:^{
            [weakself.panel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(-weakself.panel.panelHeight - 18);
            }];
            [weakself layoutIfNeeded];
        } completion:^(BOOL finished) {
            weakself.isShowPanel = YES;
            weakself.panel.hidden = NO;
            if (completion) {
                completion(finished);
            }
        }];
    }
}

- (void)hiddenPanel:(void (^)(BOOL finished))completion
{
    if (_isShowPanel) {
        TLWeakSelf(self);
        weakself.panel.hidden = YES;
        [UIView animateWithDuration:0.15 animations:^{
            [weakself.panel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self).offset(TABBAR_HEIGHT);
            }];
            [weakself layoutIfNeeded];
        } completion:^(BOOL finished) {
            weakself.isShowPanel = NO;
            if (completion) {
                completion(finished);
            }
        }];
    }
}

#pragma mark - action
- (void)btnClick:(UIButton *)btn
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickServiceBtnView:)]) {
        [self.delegate didClickServiceBtnView:self];
    }
}

#pragma mark - TLServicePanelDelegate
- (void)didClickPanel:(TLServicePanel *)panel atRow:(NSInteger)row
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickServiceBtnView:subMenuRow:)]) {
        [self.delegate didClickServiceBtnView:self subMenuRow:row];
    }

    [self hiddenPanel:nil];
}

// MARK: - setter
- (void)setSubMenus:(NSArray *)subMenus
{
    _subMenus = subMenus;
    self.panel.subMenuArr = subMenus;
    if (subMenus.count > 0) {
        NSBundle *bundle = [NSBundle bundleForClass:NSClassFromString(@"TLServiceBar")];
        NSURL *url = [bundle URLForResource:@"TLServiceBar" withExtension:@"bundle"];
        NSBundle *imageBundle = [NSBundle bundleWithURL:url];
        NSString *path = [imageBundle pathForResource:@"chat_Menu@3x" ofType:@"png"];
        UIImage *image = [UIImage imageWithContentsOfFile:path];

        [_btn setImage:image forState:UIControlStateNormal];
    }
    [self insertSubview:self.panel atIndex:0];

    CGFloat btnW = (SCREEN_WIDTH - 36 - 16 - 3 * 0.5) / 3 * 1.0;
    [self.panel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(TABBAR_HEIGHT);
        if (self.panel.panelWidth > btnW) {
            if (self.tag == 102) { // 适配标题过长，屏幕遮挡
                make.centerX.mas_equalTo(self.mas_centerX).mas_offset(-(self.panel.panelWidth - btnW));
            } else {
                make.centerX.mas_equalTo(self.mas_centerX);
            }
        } else {
            make.centerX.mas_equalTo(self.mas_centerX);
        }
        make.size.mas_equalTo(CGSizeMake(self.panel.panelWidth, self.panel.panelHeight));
    }];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    [_btn setTitle:title forState:UIControlStateNormal];
}

// MARK: - getter
- (TLServicePanel *)panel
{
    if (!_panel) {
        _panel = [[TLServicePanel alloc] init];
        _panel.delegate = self;
        _panel.hidden = YES;
    }
    return _panel;
}

- (UIButton *)btn
{
    if (!_btn) {
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
        [_btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        [_btn setContentMode:UIViewContentModeScaleAspectFit];
        _btn.titleLabel.font = TLFont(15.0f);
        [_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn;
}

- (UIView *)backGroupImageView
{
    if (!_backGroupImageView) {
        _backGroupImageView = [[UIImageView alloc] init];
        _backGroupImageView.backgroundColor = [UIColor colorGrayForChatBar];
    }
    return _backGroupImageView;
}

@end
