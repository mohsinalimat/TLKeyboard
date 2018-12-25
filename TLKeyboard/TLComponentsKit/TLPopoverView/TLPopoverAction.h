

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TLPopoverViewStyle) {
    TLPopoverViewStyleDefault = 0, // 默认风格, 白色
    TLPopoverViewStyleDark,        // 黑色风格
};


@interface TLPopoverAction : NSObject

@property (nonatomic, strong, readonly) UIImage *image;                         ///< 图标 (建议使用 60pix*60pix 的图片)
@property (nonatomic, copy, readonly) NSString *title;                          ///< 标题
@property (nonatomic, copy, readonly) void (^handler)(TLPopoverAction *action); ///< 选择回调, 该Block不会导致内存泄露, Block内代码无需刻意去设置弱引用.

+ (instancetype)actionWithTitle:(NSString *)title handler:(void (^)(TLPopoverAction *action))handler;

+ (instancetype)actionWithImage:(UIImage *)image title:(NSString *)title handler:(void (^)(TLPopoverAction *action))handler;

@end
