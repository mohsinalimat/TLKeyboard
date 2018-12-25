//
//  TLViewController.m
//  TLKeyboard
//
//  Created by xieyingliang on 12/24/2018.
//  Copyright (c) 2018 xieyingliang. All rights reserved.
//

#import "TLViewController.h"
#import "TLKit.h"

@interface TLViewController ()<TLChatBarDelegate, TLMoreKeyboardDelegate, TLEmojiKeyboardDelegate, TLKeyboardDelegate, TLServiceBarDelegate>
{
    TLChatBarStatus lastStatus;
    TLChatBarStatus curStatus;
}

@property (nonatomic, strong) TLServiceBar *serviceBar;

/// 聊天输入栏
@property (nonatomic, strong) TLChatBar *chatBar;

@property (nonatomic, strong) TLExpressionGroupModel *systemEditGroup;

/// 默认表情（Face）
@property (nonatomic, strong) TLExpressionGroupModel *defaultFaceGroup;

/// 默认系统Emoji
@property (nonatomic, strong) TLExpressionGroupModel *defaultSystemEmojiGroup;

/// 表情键盘
@property (nonatomic, strong, readonly) TLEmojiKeyboard *emojiKeyboard;

/// 更多键盘
@property (nonatomic, strong, readonly) TLMoreKeyboard *moreKeyboard;

@property (weak, nonatomic) IBOutlet UILabel *contentView;
@end

@implementation TLViewController

//MARK: 系统键盘回调
- (void)keyboardWillShow:(NSNotification *)notification
{
    if (curStatus != TLChatBarStatusKeyboard) {
        return;
    }
}

- (void)keyboardDidShow:(NSNotification *)notification
{
    if (curStatus != TLChatBarStatusKeyboard) {
        return;
    }
    if (lastStatus == TLChatBarStatusMore) {
        [self.moreKeyboard dismissWithAnimation:NO];
    } else if (lastStatus == TLChatBarStatusEmoji) {
        [self.emojiKeyboard dismissWithAnimation:NO];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    if (curStatus != TLChatBarStatusKeyboard && lastStatus != TLChatBarStatusKeyboard) {
        return;
    }
    if (curStatus == TLChatBarStatusEmoji || curStatus == TLChatBarStatusMore) {
        return;
    }
    
    [self.chatBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view).offset(-INDICATOR_HEIGHT);
    }];
    [self.view layoutIfNeeded];
}

- (void)keyboardFrameWillChange:(NSNotification *)notification
{
    if (curStatus != TLChatBarStatusKeyboard && lastStatus != TLChatBarStatusKeyboard) {
        return;
    }
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if (lastStatus == TLChatBarStatusMore || lastStatus == TLChatBarStatusEmoji) {
        if (keyboardFrame.size.height <= HEIGHT_CHAT_KEYBOARD) {
            return;
        }
    } else if (curStatus == TLChatBarStatusEmoji || curStatus == TLChatBarStatusMore) {
        return;
    }
    [self.chatBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view).mas_offset(-keyboardFrame.size.height);
    }];
    [self.view layoutIfNeeded];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismissKeyboard];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.contentView.text = @"Demo中的功能如下:\n \n表情键盘\n 功能键盘\n +号菜单\n 订阅号(公众号)菜单\n 输入框\n";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_add"] style:UIBarButtonItemStyleDone actionBlick:^{
        [[TLPopoverView sharedView] showToPoint:CGPointMake(SCREEN_WIDTH - 10, STATUSBAR_HEIGHT + NAVBAR_HEIGHT) withActions:[self Actions]];
    }];
    
    [self loadKeyboard];
    
    // 设置表情键盘数据
    [self setChatMoreKeyboardData];
    [self setChatEmojiKeyboardData];
    
    [self.chatBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(-INDICATOR_HEIGHT);
        make.height.mas_equalTo(TABBAR_HEIGHT);
    }];
    
    [self.serviceBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view.mas_bottom);
        make.height.mas_equalTo(TABBAR_HEIGHT);
    }];
    [self.view layoutIfNeeded];
}

- (void)loadKeyboard
{
    [self.view addSubview:self.chatBar];
    [self.view addSubview:self.serviceBar];
    
    [self.emojiKeyboard setKeyboardDelegate:self];
    [self.emojiKeyboard setDelegate:self];
    
    [self.moreKeyboard setKeyboardDelegate:self];
    [self.moreKeyboard setDelegate:self];
}

- (void)dismissKeyboard
{
    if (curStatus == TLChatBarStatusMore) {
        [self.moreKeyboard dismissWithAnimation:YES];
        curStatus = TLChatBarStatusInit;
    } else if (curStatus == TLChatBarStatusEmoji) {
        [self.emojiKeyboard dismissWithAnimation:YES];
        curStatus = TLChatBarStatusInit;
    }
    
    [self.chatBar resignFirstResponder];
}

// MARK: TLServiceBarDelegate
- (void)showServiceBar
{
    [UIView animateWithDuration:1 animations:^{
        [self.chatBar mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.view).offset(TABBAR_HEIGHT + INDICATOR_HEIGHT);
        }];
    }];
    
    [self.serviceBar showToolBar];
}

- (void)didClickKeyBoradBtn:(TLServiceBar *)bar btn:(UIButton *)btn
{
    [self.serviceBar hiddenToolBar];
    if (lastStatus == TLChatBarStatusVoice) {
        self.chatBar.status = lastStatus;
    } else if (lastStatus == TLChatBarStatusEmoji) {
        self.chatBar.status = TLChatBarStatusInit;
    }
    
    [UIView animateWithDuration:1 animations:^{
        [self.chatBar mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.view).offset(-INDICATOR_HEIGHT);
        }];
    }];
}

- (void)didSelectedMenuInSection:(NSInteger)section row:(NSInteger)row
{
    NSDictionary *dict = [self titles][section];
    NSString *title = dict[@"title"];
    NSString *subTitle = dict[@"subtitles"][row];
    self.contentView.text = [NSString stringWithFormat:@"title : %@ \n subtitle : %@",title,subTitle];
}

//MARK: TLChatBarDelegate
- (void)chatBar:(TLChatBar *)chatBar sendText:(NSString *)text
{
    self.contentView.attributedText = [self toMessageString:text];

    NSLog(@"sendText : %@", text);
}

- (void)chatBarStartRecording:(TLChatBar *)chatBar
{
    NSLog(@"开始录音");
}

- (void)chatBarWillCancelRecording:(TLChatBar *)chatBar cancel:(BOOL)cancel
{
    NSLog(@"即将取消录音");
}

- (void)chatBarFinishedRecoding:(TLChatBar *)chatBar
{
    NSLog(@"录音完成");
}

- (void)chatBarDidCancelRecording:(TLChatBar *)chatBar
{
    NSLog(@"取消录音");
}

- (void)chatBar:(TLChatBar *)chatBar changeStatusFrom:(TLChatBarStatus)fromStatus to:(TLChatBarStatus)toStatus
{
    NSLog(@"chatBar changeStatusFrom");
    
    if (curStatus == toStatus) {
        return;
    }
    lastStatus = fromStatus;
    curStatus = toStatus;
    if (toStatus == TLChatBarStatusInit) {
        if (fromStatus == TLChatBarStatusMore) {
            [self.moreKeyboard dismissWithAnimation:YES];
        } else if (fromStatus == TLChatBarStatusEmoji) {
            [self.emojiKeyboard dismissWithAnimation:YES];
        } else if (fromStatus == TLChatBarStatusModelChange) {
            [self showServiceBar];
        }
    } else if (toStatus == TLChatBarStatusVoice) {
        if (fromStatus == TLChatBarStatusMore) {
            [self.moreKeyboard dismissWithAnimation:YES];
        } else if (fromStatus == TLChatBarStatusEmoji) {
            [self.emojiKeyboard dismissWithAnimation:YES];
        }
    } else if (toStatus == TLChatBarStatusEmoji) {
        [self.emojiKeyboard showInView:self.view withAnimation:YES];
    } else if (toStatus == TLChatBarStatusMore) {
        [self.moreKeyboard showInView:self.view withAnimation:YES];
    } else if (toStatus == TLChatBarStatusModelChange) {
        if (fromStatus == TLChatBarStatusEmoji) {
            [self.emojiKeyboard dismissWithAnimation:YES];
        } else if (fromStatus == TLChatBarStatusMore) {
            [self.moreKeyboard dismissWithAnimation:YES];
        }
        [self showServiceBar];
    }
}

- (void)chatBar:(TLChatBar *)chatBar didChangeTextViewHeight:(CGFloat)height
{
    NSLog(@"弹起键盘改变的高度 : %f", height);
}

//MARK: TLKeyboardDelegate
- (void)chatKeyboardWillShow:(id)keyboard animated:(BOOL)animated
{
    NSLog(@"chatKeyboardWillShow");
}

- (void)chatKeyboardDidShow:(id)keyboard animated:(BOOL)animated
{
    NSLog(@"chatKeyboardDidShow");
    
    if (curStatus == TLChatBarStatusMore && lastStatus == TLChatBarStatusEmoji) {
        [self.emojiKeyboard dismissWithAnimation:NO];
    } else if (curStatus == TLChatBarStatusEmoji && lastStatus == TLChatBarStatusMore) {
        [self.moreKeyboard dismissWithAnimation:NO];
    }
}

- (void)chatKeyboardWillDismiss:(id)keyboard animated:(BOOL)animated
{
    NSLog(@"chatKeyboardWillDismiss");
}

- (void)chatKeyboardDidDismiss:(id)keyboard animated:(BOOL)animated
{
    NSLog(@"chatKeyboardDidDismiss");
}

- (void)chatKeyboard:(id)keyboard didChangeHeight:(CGFloat)height
{
    NSLog(@"chatKeyboard didChangeHeight");
    [self.chatBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view).mas_offset(-height);
    }];
    [self.view layoutIfNeeded];
}

// MARK: - moreKeyboardDelegate
- (void)moreKeyboard:(id)keyboard didSelectedFunctionItem:(TLMoreKeyboardItem *)funcItem
{
    self.contentView.text = funcItem.title;
    NSLog(@"didSelectedFunctionItem : %@", funcItem.title);
}

// MARK: - emojiKeyboardDelegate
- (BOOL)chatInputViewHasText
{
    return self.chatBar.curText.length == 0 ? NO : YES;
}

- (void)emojiKeyboard:(TLEmojiKeyboard *)emojiKB didSelectedEmojiItem:(TLExpressionModel *)emoji
{
    NSLog(@"didSelectedEmojiItem : %@", emoji.name);
    if (emoji.type == TLEmojiTypeEmoji || emoji.type == TLEmojiTypeFace) {
        [self.chatBar addEmojiString:emoji.name];
    } else {
        //        NSLog(@"emojiKeyboard : %@",emoji.name);
    }
}

- (void)emojiKeyboardSendButtonDown
{
    NSLog(@"emojiKeyboardSendButtonDown");
    [self.chatBar sendCurrentText];
}

- (void)emojiKeyboardDeleteButtonDown
{
    NSLog(@"emojiKeyboardDeleteButtonDown");
    [self.chatBar deleteLastCharacter];
}

- (void)emojiKeyboardEmojiEditButtonDown
{
    NSLog(@"emojiKeyboardEmojiEditButtonDown");
    self.contentView.text = @"点击了+号按钮";
}

- (void)emojiKeyboardMyEmojiEditButtonDown
{
    NSLog(@"emojiKeyboardMyEmojiEditButtonDown");
    self.contentView.text = @"点击了settting号按钮";
}

- (void)emojiKeyboard:(TLEmojiKeyboard *)emojiKB didTouchEmojiItem:(TLExpressionModel *)emoji atRect:(CGRect)rect
{
    NSLog(@"didTouchEmojiItem : %@", emoji.name);
    if (emoji.type == TLEmojiTypeEmoji || emoji.type == TLEmojiTypeFace) {
    } else {
    }
}

- (void)emojiKeyboardCancelTouchEmojiItem:(TLEmojiKeyboard *)emojiKB
{
    NSLog(@"emojiKeyboardCancelTouchEmojiItem");
}

- (void)emojiKeyboard:(TLEmojiKeyboard *)emojiKB selectedEmojiGroupType:(TLEmojiType)type
{
    NSLog(@"emojiKeyboard selectedEmojiGroupType :%ld", type);
    
    if (type == TLEmojiTypeEmoji || type == TLEmojiTypeFace) {
        [self.chatBar setActivity:YES];
    } else {
        [self.chatBar setActivity:NO];
    }
}

- (NSArray *)titles
{
    return @[ @{ @"title" : @"资质管理",
                 @"subtitles" : @[ @"企业资质查询", @"员工资质录入", @"知识产权查询" ] },
              @{ @"title" : @"知识产权",
                 @"subtitles" : @[ @"知识产权查询" ] },
              @{ @"title" : @"持续改进",
                 @"subtitles" : @[ @"持续改进平台", @"质量方针", @"公司质量目标", @"体系文件宣传", @"体系文件发布" ] } ];
}

- (void)setChatMoreKeyboardData
{
    TLMoreKeyboardItem *imageItem = [TLMoreKeyboardItem createByType:TLMoreKeyboardItemTypeImage
                                                               title:@"照片"
                                                           imagePath:@"moreKB_image"];
    TLMoreKeyboardItem *cameraItem = [TLMoreKeyboardItem createByType:TLMoreKeyboardItemTypeCamera
                                                                title:@"拍摄"
                                                            imagePath:@"moreKB_video"];
    TLMoreKeyboardItem *videoItem = [TLMoreKeyboardItem createByType:TLMoreKeyboardItemTypeVideo
                                                               title:@"小视频"
                                                           imagePath:@"moreKB_sight"];
    TLMoreKeyboardItem *videoCallItem = [TLMoreKeyboardItem createByType:TLMoreKeyboardItemTypeVideoCall
                                                                   title:@"视频聊天"
                                                               imagePath:@"moreKB_video_call"];
    TLMoreKeyboardItem *walletItem = [TLMoreKeyboardItem createByType:TLMoreKeyboardItemTypeWallet
                                                                title:@"红包"
                                                            imagePath:@"moreKB_wallet"];
    TLMoreKeyboardItem *transferItem = [TLMoreKeyboardItem createByType:TLMoreKeyboardItemTypeTransfer
                                                                  title:@"转账"
                                                              imagePath:@"moreKB_pay"];
    TLMoreKeyboardItem *positionItem = [TLMoreKeyboardItem createByType:TLMoreKeyboardItemTypePosition
                                                                  title:@"位置"
                                                              imagePath:@"moreKB_location"];
    TLMoreKeyboardItem *favoriteItem = [TLMoreKeyboardItem createByType:TLMoreKeyboardItemTypeFavorite
                                                                  title:@"收藏"
                                                              imagePath:@"moreKB_favorite"];
    TLMoreKeyboardItem *businessCardItem = [TLMoreKeyboardItem createByType:TLMoreKeyboardItemTypeBusinessCard
                                                                      title:@"个人名片"
                                                                  imagePath:@"moreKB_friendcard"];
    TLMoreKeyboardItem *voiceItem = [TLMoreKeyboardItem createByType:TLMoreKeyboardItemTypeVoice
                                                               title:@"语音输入"
                                                           imagePath:@"moreKB_voice"];
    TLMoreKeyboardItem *cardsItem = [TLMoreKeyboardItem createByType:TLMoreKeyboardItemTypeCards
                                                               title:@"卡券"
                                                           imagePath:@"moreKB_wallet"];
    NSArray *datas = @[ imageItem, cameraItem, videoItem, videoCallItem, walletItem, transferItem, positionItem, favoriteItem, businessCardItem, voiceItem, cardsItem ];
    NSMutableArray *moreKeyboardData = [NSMutableArray arrayWithArray:datas];
    [self.moreKeyboard setChatMoreKeyboardData:moreKeyboardData];
}

- (void)setChatEmojiKeyboardData
{
    NSArray *datas = @[ self.defaultFaceGroup, self.defaultSystemEmojiGroup, self.systemEditGroup ];
    NSMutableArray *emojiKeyboardData = [NSMutableArray arrayWithArray:datas];
    [self.emojiKeyboard setEmojiGroupData:emojiKeyboardData];
}

- (TLChatBar *)chatBar
{
    if (_chatBar == nil) {
        _chatBar = [[TLChatBar alloc] init];
        [_chatBar setDelegate:self];
        _chatBar.showModelBtn = YES;
    }
    return _chatBar;
}

- (TLServiceBar *)serviceBar
{
    if (_serviceBar == nil) {
        _serviceBar = [TLServiceBar serviceBarWithMenuArr:[self titles]];
        _serviceBar.delegate = self;
        _serviceBar.hidden = YES;
    }
    return _serviceBar;
}

// MARK: - keyboard
- (TLEmojiKeyboard *)emojiKeyboard
{
    return [TLEmojiKeyboard keyboard];
}

- (TLMoreKeyboard *)moreKeyboard
{
    return [TLMoreKeyboard keyboard];
}

- (TLExpressionGroupModel *)defaultFaceGroup
{
    if (_defaultFaceGroup == nil) {
        _defaultFaceGroup = [[TLExpressionGroupModel alloc] init];
        _defaultFaceGroup.type = TLEmojiTypeFace;
        _defaultFaceGroup.iconPath = @"emojiKB_group_face";
        NSString *path = [[NSBundle mainBundle] pathForResource:@"FaceEmoji" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        _defaultFaceGroup.data = [TLExpressionModel mj_objectArrayWithKeyValuesArray:data];
        for (TLExpressionModel *emoji in _defaultFaceGroup.data) {
            emoji.type = TLEmojiTypeFace;
        }
    }
    return _defaultFaceGroup;
}

- (TLExpressionGroupModel *)defaultSystemEmojiGroup
{
    if (_defaultSystemEmojiGroup == nil) {
        _defaultSystemEmojiGroup = [[TLExpressionGroupModel alloc] init];
        _defaultSystemEmojiGroup.type = TLEmojiTypeEmoji;
        _defaultSystemEmojiGroup.iconPath = @"emojiKB_group_face";
        NSString *path = [[NSBundle mainBundle] pathForResource:@"SystemEmoji" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        _defaultSystemEmojiGroup.data = [TLExpressionModel mj_objectArrayWithKeyValuesArray:data];
    }
    return _defaultSystemEmojiGroup;
}

- (TLExpressionGroupModel *)systemEditGroup
{
    if (_systemEditGroup == nil) {
        _systemEditGroup = [[TLExpressionGroupModel alloc] init];
        _systemEditGroup.type = TLEmojiTypeOther;
        _systemEditGroup.iconPath = @"emojiKB_settingBtn";
    }
    return _systemEditGroup;
}

- (NSArray<TLPopoverAction *> *)Actions {
    
    TLPopoverAction *groupChatAction = [TLPopoverAction actionWithImage:[UIImage imageNamed:@"list_chat"] title:@"发起群聊" handler:^(TLPopoverAction *action) {
        self.contentView.text = action.title;
        NSLog(@"title : %@",action.title);
    }];
    
    TLPopoverAction *addFriAction = [TLPopoverAction actionWithImage:[UIImage imageNamed:@"list_add_contact"] title:@"邀请同事" handler:^(TLPopoverAction *action) {
        self.contentView.text = action.title;
        NSLog(@"title : %@",action.title);
    }];
    
    TLPopoverAction *QRAction = [TLPopoverAction actionWithImage:[UIImage imageNamed:@"list_scan"] title:@"扫一扫" handler:^(TLPopoverAction *action) {
        self.contentView.text = action.title;
        NSLog(@"title : %@",action.title);
    }];
    
    TLPopoverAction *relaxAction = [TLPopoverAction actionWithImage:[UIImage imageNamed:@"list_relax"] title:@"休息一下" handler:^(TLPopoverAction *action) {
        self.contentView.text = action.title;
        NSLog(@"title : %@",action.title);
    }];
    
    return @[groupChatAction, addFriAction, QRAction, relaxAction];
}

- (NSAttributedString *)toMessageString:(NSString *)text;
{
    //1、创建一个可变的属性字符串
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributeString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, text.length)];
    //2、通过正则表达式来匹配字符串
    NSString *regex_emoji = @"\\[[a-zA-Z0-9\\/\\u4e00-\\u9fa5]+\\]"; //匹配表情
    
    NSError *error = nil;
    NSRegularExpression *re = [NSRegularExpression regularExpressionWithPattern:regex_emoji options:NSRegularExpressionCaseInsensitive error:&error];
    if (!re) {
        NSLog(@"[NSString toMessageString]: %@", [error localizedDescription]);
        return attributeString;
    }
    
    NSArray *resultArray = [re matchesInString:text options:0 range:NSMakeRange(0, text.length)];
    //3、获取所有的表情以及位置
    //用来存放字典，字典中存储的是图片和图片对应的位置
    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:resultArray.count];
    //根据匹配范围来用图片进行相应的替换
    for(NSTextCheckingResult *match in resultArray) {
        //获取数组元素中得到range
        NSRange range = [match range];
        //获取原字符串中对应的值
        NSString *subStr = [text substringWithRange:range];
        
        TLExpressionGroupModel *group = [self defaultFaceGroup];
        for (TLExpressionModel *emoji in group.data) {
            if ([emoji.name isEqualToString:subStr]) {
                //face[i][@"png"]就是我们要加载的图片
                //新建文字附件来存放我们的图片,iOS7才新加的对象
                NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
                //给附件添加图片
                textAttachment.image = [UIImage imageNamed:emoji.name];
                //调整一下图片的位置,如果你的图片偏上或者偏下，调整一下bounds的y值即可
                textAttachment.bounds = CGRectMake(0, -4, 20, 20);
                //把附件转换成可变字符串，用于替换掉源字符串中的表情文字
                NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
                //把图片和图片对应的位置存入字典中
                NSMutableDictionary *imageDic = [NSMutableDictionary dictionaryWithCapacity:2];
                [imageDic setObject:imageStr forKey:@"image"];
                [imageDic setObject:[NSValue valueWithRange:range] forKey:@"range"];
                //把字典存入数组中
                [imageArray addObject:imageDic];
            }
        }
    }
    
    //4、从后往前替换，否则会引起位置问题
    for (int i = (int)imageArray.count -1; i >= 0; i--) {
        NSRange range;
        [imageArray[i][@"range"] getValue:&range];
        //进行替换
        [attributeString replaceCharactersInRange:range withAttributedString:imageArray[i][@"image"]];
    }
    return attributeString;
}
@end
