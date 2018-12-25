

#import <UIKit/UIKit.h>
#import "TLPopoverAction.h"

// 弹窗箭头的样式
typedef NS_ENUM(NSUInteger, TLPopoverViewArrowStyle) {
    TLPopoverViewArrowStyleRound = 0, // 圆角
    TLPopoverViewArrowStyleTriangle   // 菱角
};


@interface TLPopoverView : UIView

/**
 是否开启点击外部隐藏弹窗, 默认为YES.
 */
@property (nonatomic, assign) BOOL hideAfterTouchOutside;

/**
 是否显示阴影, 如果为YES则弹窗背景为半透明的阴影层, 否则为透明, 默认为NO.
 */
@property (nonatomic, assign) BOOL showShade;

/**
 弹出窗风格, 默认为 TLPopoverViewStyleDefault(白色).
 */
@property (nonatomic, assign) TLPopoverViewStyle style;

/**
 箭头样式, 默认为 TLPopoverViewArrowStyleRound.
 如果要修改箭头的样式, 需要在显示先设置.
 */
@property (nonatomic, assign) TLPopoverViewArrowStyle arrowStyle;

+ (instancetype)sharedView;

/**
 指向指定的View来显示弹窗

 @param pointView 箭头指向的View
 @param actions 动作对象集合<TLPopoverAction>
 */
- (void)showToView:(UIView *)pointView withActions:(NSArray<TLPopoverAction *> *)actions;

/**
 指向指定的点来显示弹窗

 @param toPoint 箭头指向的点(这个点的坐标需按照keyWindow的坐标为参照)
 @param actions 动作对象集合<TLPopoverAction>
 */
- (void)showToPoint:(CGPoint)toPoint withActions:(NSArray<TLPopoverAction *> *)actions;

@end
