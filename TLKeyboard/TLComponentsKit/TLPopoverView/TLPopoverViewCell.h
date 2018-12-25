

#import <UIKit/UIKit.h>
#import "TLPopoverAction.h"

UIKIT_EXTERN float const TLPopoverViewCellHorizontalMargin; ///< 水平间距边距
UIKIT_EXTERN float const TLPopoverViewCellVerticalMargin;   ///< 垂直边距
UIKIT_EXTERN float const TLPopoverViewCellTitleLeftEdge;    ///< 标题左边边距


@interface TLPopoverViewCell : UITableViewCell

@property (nonatomic, assign) TLPopoverViewStyle style;

/*! @brief 标题字体
 */
+ (UIFont *)titleFont;

/*! @brief 底部线条颜色
 */
+ (UIColor *)bottomLineColorForStyle:(TLPopoverViewStyle)style;

- (void)setAction:(TLPopoverAction *)action;

- (void)showBottomLine:(BOOL)show;

@end
