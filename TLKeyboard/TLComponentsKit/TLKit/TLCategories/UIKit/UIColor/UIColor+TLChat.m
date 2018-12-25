//
//  UIColor+TLChat.m
//  TLChat
//
//  Created by 李伯坤 on 16/1/27.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "UIColor+TLChat.h"
#import "TLShortcutMacros.h"

@implementation UIColor (TLChat)

#pragma mark - # 字体
+ (UIColor *)colorTextBlack {
    return [UIColor blackColor];
}

+ (UIColor *)lineColor
{
    return [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1.0];
}

+ (UIColor *)colorTextGray {
    return [UIColor grayColor];
}

+ (UIColor *)colorTextGray1 {
    return RGBAColor(160, 160, 160, 1.0);
}

#pragma mark - 灰色
+ (UIColor *)colorGrayBG {
    return RGBAColor(239.0, 239.0, 244.0, 1.0);
}

+ (UIColor *)colorGrayCharcoalBG {
    return RGBAColor(235.0, 235.0, 235.0, 1.0);
}

+ (UIColor *)colorGrayLine {
    return [UIColor colorWithWhite:0.5 alpha:0.3];
}

+ (UIColor *)colorGrayForChatBar {
    return RGBAColor(250.0, 250.0, 250.0, 1.0);
}

+ (UIColor *)colorGrayForMoment {
    return RGBAColor(243.0, 243.0, 245.0, 1.0);
}

+ (UIColor *)colorGrayForSystemMsg {
    return [UIColor colorWithWhite:0.3 alpha:0.3];
}

#pragma mark - 绿色
+ (UIColor *)colorGreenHL {
    return RGBAColor(46, 139, 46, 1.0f);
}

#pragma mark - 蓝色
+ (UIColor *)colorBlueDefault {
    return RGBAColor(85.0, 119.0, 173.0, 1.0f);
}

+ (UIColor *)colorBlueMoment {
    return RGBAColor(74.0, 99.0, 141.0, 1.0);
}

#pragma mark - 黑色
+ (UIColor *)colorBlackBG {
    return RGBAColor(46.0, 49.0, 50.0, 1.0);
}

+ (UIColor *)colorBlackAlphaScannerBG {
    return [UIColor colorWithWhite:0 alpha:0.6];
}

+ (UIColor *)colorWhiteForAddMenu {
    return RGBAColor(255, 255, 255, 1.0);
}

+ (UIColor *)colorWhiteForAddMenuHL {
    return RGBAColor(236, 237, 241, 1.0);
}

#pragma mark - #
+ (UIColor *)colorRedForButton {
    return RGBColor(228, 68, 71);
}

+ (UIColor *)colorRedForButtonHL {
    return RGBColor(205, 62, 64);
}

+ (UIColor *)colorRedForConversationTagAlert{
    return RGBAColor(254, 214, 215, 1);
}

+ (UIColor *)randomColor
{
    return RGBAColor(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255), 1.0);
}

@end
