//
//  LFLChatViewController.m
//  LFLTrunkLib
//
//  Created by 啸峰 on 16/8/31.
//  Copyright © 2016年 张啸峰. All rights reserved.
//

#import "LFLChatViewController.h"
#import "LFLChatRightMessageViewCell.h"
#import "LFLChatLeftMessageViewCell.h"
#import "LFLChatViewController+CoreData.h"
#import "LFLChatViewController+UserInput.h"
#import "LFLChatMessageHeaderView.h"
#import "LFLChatRightVoiceMessageViewCell.h"

@interface LFLChatViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, LFLChatUserInputViewDelegate ,NSFetchedResultsControllerDelegate, LFLChetBaseViewCellDelegate, AVAudioPlayerDelegate>

@property (weak, nonatomic, readwrite) IBOutlet UITableView *messageTableView;
//消息cell
@property (strong, nonatomic) LFLChetBaseViewCell *currentSelectedCell;
@property (strong, nonatomic) LFLChatRightMessageViewCell *rightMessageCell;
@property (strong, nonatomic) LFLChatLeftMessageViewCell *leftMessageCell;
//消息列表约束
@property (weak, nonatomic, readwrite) IBOutlet NSLayoutConstraint *messageTableViewToBottomLength;
//数据操作
@property (strong, nonatomic) LFLFetcher *fetcher;
//键盘高度
@property (assign, nonatomic) NSInteger keyBoardHeight;
//键盘是否正在显示
@property (assign, nonatomic) BOOL keyBoardShow;

@end

@implementation LFLChatViewController

- (void)dealloc {
    [[LFLFetcherManager shareInstance] removeFetcherWithObjects:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadView {
    [super loadView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //侧滑导致的button点击延迟
    self.navigationController.interactivePopGestureRecognizer.delaysTouchesBegan = NO;
    [self.view setBackgroundColor:Color(230, 230, 230, 1)];
    self.title = @"廖呆呆";
    self.fetcher = [[LFLFetcherManager shareInstance] fetcherWithObject:self];
    
    [self registerCell];
    [self addNotification];
    
    self.messageTableView.delegate = self;
    self.messageTableView.dataSource = self;
    self.messageTableView.separatorStyle = NO;
    
    [self addUserInputView];
    
    self.messageFetcher.delegate = self;

    [self setUpRigthBarButton];
}

- (void)setUpRigthBarButton {
    UIButton *rightBarButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 15, 13)];
    [rightBarButton addTarget:self action:@selector(rightBarAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightBarButton setImage:[LFLTrunkBundle imageName:@"right_bar_icon"] forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButton];
    self.navigationItem.rightBarButtonItems = @[rightItem];
}

- (void)rightBarAction:(id)sender {
    [LFLFetcher deleteAllObjectWithEntityClass:[self provideClass] completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSInteger *number = self.messageFetcher.numberOfSections;
    NSMutableArray *result = @[].mutableCopy;
    for (int i = 0; i<number; i++) {
        NSArray *section = [self.messageFetcher allObjectsInSection:i];
        [result addObjectsFromArray:section];
    }
    
    NSInteger height = 0;
    for (int i =0 ; i<result.count; i++) {
        LFLChatMessage *message = result[i];
        height = height + [message.cell_height integerValue];
    }
    if (self.messageTableView.contentOffset.y == 0) {
        if (height > ScreenHeight- 64- kInPutBarHeight) {
            [self messageTableViewScrollAnimation:NO];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark - 注册cell

- (void)registerCell {
    [self.messageTableView LFLRegisterNibWithClass:[LFLChatRightMessageViewCell class] bundle:@"LFLTrunkBundle"];
    [self.messageTableView LFLRegisterNibWithClass:[LFLChatLeftMessageViewCell class] bundle:@"LFLTrunkBundle"];
    [self.messageTableView LFLRegisterNibWithClass:[LFLChatRightVoiceMessageViewCell class] bundle:@"LFLTrunkBundle"];
    [self.messageTableView registerClass:[LFLChatMessageHeaderView class] forHeaderFooterViewReuseIdentifier:@"LFLChatMessageHeaderView"];
}

#pragma mark - 添加监听

- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuControllerShow:) name:UIMenuControllerDidShowMenuNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuControllerHidden:) name:UIMenuControllerDidHideMenuNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBackGround:) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

#pragma mark - 键盘弹出收起事件

- (void)keyboardWasShown:(id)noti {
    NSDictionary *userInfo = [noti userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    self.keyBoardHeight = height;
    self.messageTableViewToBottomLength.constant = height + kInPutBarHeight;
    [self messageTableViewScrollToBottomAnimation:NO];
    self.keyBoardShow = YES;
}

- (void)keyboardWillBeHidden:(id)noti {
    self.messageTableViewToBottomLength.constant = kInPutBarHeight;
    self.keyBoardShow = NO;
}

- (void)closeKeyBoard {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 33;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    LFLChatMessageHeaderView *view =(LFLChatMessageHeaderView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"LFLChatMessageHeaderView"];
    WeakSelf;
    view.onClick = ^ {
        [weakSelf closeKeyBoard];
    };
    LFLChatMessage *message = [self.messageFetcher objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
    if (message) {
        NSDate *date = message.time;
        NSDateFormatter *formatter;
        if (section == 0) {
            formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
        } else {
            formatter = [NSDate formatMessageGroupDate:message.time];
        }
        NSString *dateStr = [formatter stringFromDate:[NSDate DPDLocalDateFromDate:[NSDate dateWithTimeIntervalSince1970:[message.time LFLDateToTimeInerval]]]];
        [view setTitle:dateStr];
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger count = self.messageFetcher.numberOfSections;
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = [self.messageFetcher numberOfRowsInSection:section];
    return count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = [indexPath row];
    NSInteger section = [indexPath section];
    LFLChetBaseViewCell *cell = nil;
    NSArray *result = [self.messageFetcher allObjectsInSection:section];
    LFLChatMessage *message = result[row];
    NSInteger type = [message.type integerValue];
    if (type == LFLChatMessageLeftType) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"LFLChatLeftMessageViewCell" forIndexPath:indexPath];
        NSString *txt = message.content;
        [cell setMessage:txt];
    } else if (type == LFLChatMessageRightType) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"LFLChatRightMessageViewCell" forIndexPath:indexPath];
        NSString *txt = message.content;
        [cell setMessage:txt];
    } else if (type == LFLChatVoiceMessageLeftType) {
        
    } else if (type == LFLChatVoiceMessageRightType) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"LFLChatRightVoiceMessageViewCell" forIndexPath:indexPath];
        CGFloat width = [message.voiceLength floatValue];
        [cell setVoiceCellWidth:width animation:NO];
    }
    cell.delegate = self;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = [indexPath row];
    NSInteger section = [indexPath section];
    NSArray *result = [self.messageFetcher allObjectsInSection:section];
    LFLChatMessage *message = result[row];
    NSInteger type = [message.type integerValue];
    NSInteger height = [message.cell_height integerValue];
    if (message && height >0 ) {
        return height;
    }
    
    NSString *txt = message.content;
    if (type == LFLChatMessageLeftType) {
        height = [self.leftMessageCell sizeForText:txt];
    } else if (type == LFLChatMessageRightType) {
        height = [self.leftMessageCell sizeForText:txt];
    } else if (type == LFLChatVoiceMessageLeftType) {
        height = 17;
    } else if (type == LFLChatVoiceMessageRightType) {
        height = 17;
    }
    height = height + 10*2 + 3 + 18;
    [message setValue:@(height) forKey:@"cell_height"];
    [LFLFetcher updateObjectPropertyWith:message];
    [self messageTableViewScrollToBottomAnimation:YES];
    return height;
}

#pragma mark getter && setter

- (LFLChatRightMessageViewCell *)rightMessageCell {
    if (_rightMessageCell) {
        _rightMessageCell = [self.messageTableView dequeueReusableCellWithIdentifier:@"LFLChatRightMessageViewCell"];
    } else {
        _rightMessageCell = [[[LFLTrunkBundle resourceBundle] loadNibNamed:@"LFLChatRightMessageViewCell" owner:self options:nil] firstObject];
    }
    return _rightMessageCell;
}

- (LFLChatLeftMessageViewCell *)leftMessageCell {
    if (_leftMessageCell) {
        _leftMessageCell = [self.messageTableView dequeueReusableCellWithIdentifier:@"LFLChatLeftMessageViewCell"];
    } else {
        _leftMessageCell = [[[LFLTrunkBundle resourceBundle] loadNibNamed:@"LFLChatLeftMessageViewCell" owner:self options:nil] firstObject];
    }
    return _leftMessageCell;
}

- (NSFetchedResultsController *)messageFetcher {
    return [self.fetcher fetcherWith:[self provideClass] sortedBy:@"msgNo" ascending:YES withPredicate:nil groupBy:@"groupKey"];
}

- (AVAudioRecorder *)audioRecorder {
    if (!_audioRecorder) {
        NSURL *url = [self getVoiceSavePath];
        LFLLog(@"保存的文件路径%@",url);
        self.currentAudioPath = [url absoluteString];
        NSDictionary *setting = [self getAudioSetting];
        NSError *error=nil;
        _audioRecorder = [[AVAudioRecorder alloc] initWithURL:url settings:setting error:&error];
        _audioRecorder.delegate = self;
        _audioRecorder.meteringEnabled = YES;//如果要监控声波则必须设置为YES
        if (error) {
            LFLLog(@"创建录音机对象时发生错误，错误信息：%@",error.localizedDescription);
            return nil;
        }
    }
    return _audioRecorder;
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self closeKeyBoard];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
}

#pragma mark 滚动

- (BOOL)messageTableViewScrollToBottom {
    CGPoint contentOffsetPoint = self.messageTableView.contentOffset;
    CGRect frame = self.messageTableView.frame;
    if (contentOffsetPoint.y == self.messageTableView.contentSize.height - frame.size.height || self.messageTableView.contentSize.height < frame.size.height) {
        return YES;
    }
    return NO;
}

- (BOOL)messageTableViewScrollToTop {
    CGFloat y = self.messageTableView.contentOffset.y;
    if (y <= -64.0f) {
        return YES;
    }
    return NO;
}

- (void)messageTableViewScrollToBottomAnimation:(BOOL)animated {
    CGFloat height = self.messageTableView.contentSize.height;
    CGFloat test = ScreenHeight - 64 - kInPutBarHeight - self.messageTableViewToBottomLength.constant;
    if (height < ScreenHeight - 64 - kInPutBarHeight - self.messageTableViewToBottomLength.constant) {
        return;
    }
    [self messageTableViewScrollAnimation:animated];
}

- (void)messageTableViewScrollAnimation:(BOOL)animated {
    WeakSelf;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        StrongSelf;
        [strongSelf.messageTableView setContentOffset:CGPointMake(0, strongSelf.messageTableView.contentSize.height - strongSelf.messageTableView.bounds.size.height) animated:animated];
    });
}

#pragma mark - 刷新聊天页面

- (void)refreshMessageTableView {
    [self.messageTableView reloadData];
}

#pragma mark LFLChetBaseViewCellDelegate

- (void)cellLongPress:(LFLChetBaseViewCell *)cell recognizer:(UIGestureRecognizer *)recognizer {
    self.currentSelectedCell = cell;
    CGPoint location = [recognizer locationInView:self.view];
    [self.userInputView setInputViewNextResponser:cell];
    if (!self.keyBoardShow) {
        [cell becomeFirstResponder];
    }
    
    UIMenuItem *itCopy = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(handleCopyCell:)];
    UIMenuItem *itDelete = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(handleDeleteCell:)];
    UIMenuController *menu = [UIMenuController sharedMenuController];
    
    NSInteger cellType = cell.messageType;
    switch (cellType) {
        case LFLChatMessageLeftType:
        case LFLChatMessageRightType:
            [menu setMenuItems:[NSArray arrayWithObjects:itCopy, itDelete,  nil]];
            break;
        case LFLChatVoiceMessageLeftType:
        case LFLChatVoiceMessageRightType:
            [menu setMenuItems:[NSArray arrayWithObjects:itDelete,  nil]];
            break;
        default:
            [menu setMenuItems:[NSArray arrayWithObjects:itDelete,  nil]];
            break;
    }
    CGRect rect = [cell convertRect:cell.bubbleImageView.frame toView:self.view];
    [menu setTargetRect:rect inView:self.view];
    [menu setMenuVisible:YES animated:YES];
}

- (void)deleteMessage:(LFLChetBaseViewCell *)cell {
    NSIndexPath *indexPath = [self.messageTableView indexPathForCell:cell];
    LFLChatMessage *message = [self.messageFetcher allObjectsInSection:[indexPath section]][[indexPath row]];
    [LFLFetcher deleteObjects:@[message]];
}

- (void)cellTapAction:(LFLChetBaseViewCell *)cell {
    if (self.menuControllerShow) {
        return;
    }
    NSInteger type = cell.messageType;
    switch (type) {
        case LFLChatMessageLeftType: {
            [self closeKeyBoard];
        }
            break;
        case LFLChatMessageRightType: {
            [self closeKeyBoard];
        }
            break;
        case LFLChatVoiceMessageLeftType: {
            [cell startVoiceAnimation];
            [self playAudioInCell:cell];
        }
            break;
        case LFLChatVoiceMessageRightType: {
            [cell startVoiceAnimation];
            [self playAudioInCell:cell];
        }
            break;
        default:
            break;
    }
    
}

- (void)playAudioInCell:(LFLChetBaseViewCell *)cell {
    NSIndexPath *indexPath = [self.messageTableView indexPathForCell:cell];
    LFLChatMessage *message = [self.messageFetcher allObjectsInSection:[indexPath section]][[indexPath row]];
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
    
    if ([self.audioPlayer isPlaying]) {
        [self.audioPlayer stop];
        [self.currentPlayingCell stopPlaying];
    }
    if (self.currentPlayingCell && cell == self.currentPlayingCell) {//如果这次播放的和上次播放的是同一个就暂停
        self.currentPlayingCell = nil;
        return;
    }
    NSURL *url = [NSURL URLWithString:message.voiceUrl];
    NSError *error = nil;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    self.audioPlayer.numberOfLoops = 0;
    self.audioPlayer.delegate = self;
    [self.audioPlayer prepareToPlay];
    if (error) {
        LFLLog(@"创建播放器过程中发生错误，错误信息：%@",error.localizedDescription);
        return;
    }
    [self.audioPlayer play];
    self.currentPlayingCell = cell;
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    [self.currentPlayingCell stopPlaying];
    self.currentPlayingCell = nil;
}

#pragma mark menuController

- (void)menuControllerShow:(id)sender {
    self.menuControllerShow = YES;
}

- (void)menuControllerHidden:(id)sender {
    self.menuControllerShow = NO;
    [self.userInputView setInputViewNextResponser:nil];
}

#pragma mark 进入后台
- (void)enterBackGround:(id)sender {
    [self.currentPlayingCell stopPlaying];
    if ([self.audioPlayer isPlaying]) {
        [self.audioPlayer stop];
    }
    self.currentPlayingCell = nil;
}
@end
