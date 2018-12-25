//
//  TLServicePanel.h
//  TLServiceBar
//
//  Created by Wcg on 2017/5/3.
//  Copyright © 2017年 Wcg. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TLServicePanel;

@protocol TLServicePanelDelegate <NSObject>

- (void)didClickPanel:(TLServicePanel *)panel atRow:(NSInteger)row;

@end


@interface TLServicePanel : UIView

//**代理*/
@property (nonatomic, weak) id<TLServicePanelDelegate> delegate;
//**数据源*/
@property (nonatomic, strong) NSArray *subMenuArr;

/**panelWidth */
@property (nonatomic, assign) CGFloat panelWidth;
@property (nonatomic, assign) CGFloat panelHeight;

@end
