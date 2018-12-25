

#import "TLPopoverAction.h"


@interface TLPopoverAction ()

@property (nonatomic, strong, readwrite) UIImage *image;                         ///< 图标
@property (nonatomic, copy, readwrite) NSString *title;                          ///< 标题
@property (nonatomic, copy, readwrite) void (^handler)(TLPopoverAction *action); ///< 选择回调

@end


@implementation TLPopoverAction

+ (instancetype)actionWithTitle:(NSString *)title handler:(void (^)(TLPopoverAction *action))handler
{
    return [self actionWithImage:nil title:title handler:handler];
}

+ (instancetype)actionWithImage:(UIImage *)image title:(NSString *)title handler:(void (^)(TLPopoverAction *action))handler
{
    TLPopoverAction *action = [[self alloc] init];
    action.image = image;
    action.title = title ?: @"";
    action.handler = handler ?: NULL;

    return action;
}

@end
