//
//  TLServicePanel.m
//  TLServiceBar
//
//  Created by Wcg on 2017/5/3.
//  Copyright © 2017年 Wcg. All rights reserved.
//

#import "TLServicePanel.h"
#import "Masonry.h"
#import "TLKit.h"


@interface TLServicePanel ()

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIImageView *backImageView;

@property (nonatomic, strong) UIView *masnoryView;

@property (nonatomic, strong) NSMutableArray *subBtns;

@property (nonatomic, strong) NSMutableArray *subLines;

@end


@implementation TLServicePanel

static const CGFloat btnH = 44;
static const CGFloat increment = 1000;

#pragma mark - init
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
    //创建容器的view
    self.contentView = [[UIView alloc] init];
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.edges.mas_equalTo(self).insets(UIEdgeInsetsZero);
    }];

    //创建背景图
    self.backImageView = [[UIImageView alloc] init];

    NSBundle *bundle = [NSBundle bundleForClass:NSClassFromString(@"TLServiceBar")];
    NSURL *url = [bundle URLForResource:@"TLServiceBar" withExtension:@"bundle"];
    NSBundle *imageBundle = [NSBundle bundleWithURL:url];
    NSString *path = [imageBundle pathForResource:@"chat_serviceMenuBG@3x" ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];

    self.backImageView.image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(6, 6, 6, 6) resizingMode:UIImageResizingModeStretch];
    [self.contentView addSubview:self.backImageView];
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.edges.mas_equalTo(self.contentView).insets(UIEdgeInsetsZero);
    }];
}

#pragma mark - action
- (void)btnClick:(UIButton *)btn
{
    NSInteger row = btn.tag - increment;
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickPanel:atRow:)]) {
        [self.delegate didClickPanel:self atRow:row];
    }
}

#pragma mark - private
- (CGFloat)panelHeight:(NSArray *)titleArr
{
    return titleArr.count * btnH + 5;
}

- (CGFloat)panelWidth:(NSArray *)titleArr
{
    CGFloat width = 0;
    for (NSString *title in titleArr) {
        CGSize titleSize = [title tt_sizeWithFont:TLFont(14.0) constrainedToSize:CGSizeMake(0, SCREEN_WIDTH) lineBreakMode:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading lineSpace:8];
        if (titleSize.width > width) {
            width = titleSize.width;
        }
    }

    return width + 2 * 10;
}

#pragma mark - setter getter
- (void)setSubMenuArr:(NSArray *)subMenuArr
{
    _subMenuArr = subMenuArr;

    if (self.subBtns.count > 0) {
        [self.subBtns performSelector:@selector(removeFromSuperview) withObject:nil];
        [self.subBtns removeAllObjects];
    }

    NSInteger row = 0;
    for (NSString *subTitle in _subMenuArr) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font = TLFont(14.0f);
        [btn setTitle:subTitle forState:UIControlStateNormal];
        btn.tag = row + increment;
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {

            make.height.mas_equalTo(btnH);

            if (row == 0) {
                make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-5);
            } else {
                make.bottom.mas_equalTo(self.masnoryView.mas_top).offset(0);
            }

            make.left.mas_equalTo(self.contentView).offset(5);
            make.right.mas_equalTo(self.contentView).offset(-5);
        }];
        [self.subBtns addObject:btn];
        self.masnoryView = btn;

        if (self.subMenuArr.count - 1 > row) {
            //添加横线
            UIView *line = [[UIView alloc] init];
            line.backgroundColor = [UIColor colorWithWhite:0.8f alpha:1.0f];
            [self.contentView addSubview:line];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {

                make.left.mas_equalTo(self.contentView).offset(8);
                make.right.mas_equalTo(self.contentView).offset(-8);
                make.centerX.mas_equalTo(self.contentView.mas_centerX);
                make.height.mas_equalTo(0.5);
                make.bottom.mas_equalTo(self.masnoryView.mas_top);
            }];
            [self.subLines addObject:line];
        }

        row++;
    }

    _panelWidth = [self panelWidth:subMenuArr];
    _panelHeight = [self panelHeight:subMenuArr];
}

- (NSMutableArray *)subBtns
{
    if (!_subBtns) {
        _subBtns = [NSMutableArray array];
    }
    return _subBtns;
}

- (NSMutableArray *)subLines
{
    if (!_subLines) {
        _subLines = [NSMutableArray array];
    }
    return _subLines;
}

@end
