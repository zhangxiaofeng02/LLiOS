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
#import "LFLChetBaseViewCell.h"
#import "LFLChatUserInputView.h"
#import "MagicalRecord.h"
#import "LFLFetcher+CoreData.h"
#import "NSManagedObject+MagicalRecord.h"
#import "LFLChatMessage.h"

static CGFloat kInPutBarHeight = 50;

@interface LFLChatViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, LFLChatUserInputViewDelegate ,NSFetchedResultsControllerDelegate, LFLChetBaseViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *messageTableView;
@property (strong, nonatomic) LFLChatRightMessageViewCell *rightMessageCell;
@property (strong, nonatomic) LFLChatLeftMessageViewCell *leftMessageCell;
@property (strong, nonatomic) NSMutableArray *heightArr;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageTableViewToBottomLength;
@property (strong, nonatomic) LFLFetcher *fetcher;
@property (strong, nonatomic) NSFetchedResultsController *messageFetcher;
@property (assign, nonatomic) NSInteger keyBoardHeight;
@property (assign, nonatomic) BOOL keyBoardShow;
@property (strong, nonatomic) LFLChatUserInputView *userInputView;
@property (strong, nonatomic) LFLChetBaseViewCell *currentSelectedCell;
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
    NSArray *reslut = [self.messageFetcher allObjectsInSection:0];
    NSInteger height = 0;
    for (int i =0 ; i<reslut.count; i++) {
        LFLChatMessage *message = reslut[i];
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
}

#pragma mark - 添加监听
- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuControllerShow:) name:UIMenuControllerDidShowMenuNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuControllerHidden:) name:UIMenuControllerDidHideMenuNotification object:nil];
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
    
//    [UIView animateWithDuration:0.15 animations:^{
//        [self.view layoutIfNeeded];
        self.keyBoardShow = NO;
//    }];
}

- (void)closeKeyBoard {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

#pragma mark - 底部输入栏
- (void)addUserInputView {
    LFLChatUserInputView *inputView = [LFLChatUserInputView defaultView];
    self.userInputView = inputView;
    inputView.delegate = self;
    [self.view addSubview:inputView];
    [inputView setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSMutableArray *conts = @[].mutableCopy;
    NSDictionary *views = NSDictionaryOfVariableBindings(self.view,inputView);
    [conts addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-0-[inputView]-0-|"] options:0 metrics:nil views:views]];
    [conts addObject:[NSLayoutConstraint constraintWithItem:inputView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.messageTableView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
    [conts addObject:[NSLayoutConstraint constraintWithItem:inputView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:kInPutBarHeight]];
    [self.view addConstraints:conts];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20.0f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:Color(230, 230, 230, 1)];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    NSInteger count = self.messageFetcher.numberOfSections;
//    return count;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    NSInteger count = [self.messageFetcher numberOfRowsInSection:section];
//    return count;
        NSInteger count = [self.messageFetcher numberOfRowsInSection:0];
        return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = [indexPath row];
    LFLChetBaseViewCell *cell = nil;
//    NSArray *result = [self.messageFetcher allObjectsInSection:row];
    NSArray *result = [self.messageFetcher allObjectsInSection:0];
    LFLChatMessage *message = result[row];
    NSInteger type = [message.type integerValue];
    if (type == LFLChatMessageLeftType) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"LFLChatLeftMessageViewCell" forIndexPath:indexPath];        
    } else if (type == LFLChatMessageRightType) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"LFLChatRightMessageViewCell" forIndexPath:indexPath];        
    }
    cell.delegate = self;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    NSString *txt = message.content;
    [cell setMessage:txt];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = [indexPath row];
//    NSArray *result = [self.messageFetcher allObjectsInSection:row];
    NSArray *result = [self.messageFetcher allObjectsInSection:0];
    LFLChatMessage *message = result[row];
    NSInteger height = [message.cell_height integerValue];
    if (height >0 ) {
        return height;
    }
    NSInteger type = [message.type integerValue];
    NSString *txt = message.content;
    if (type == LFLChatMessageLeftType) {
        height = [self.leftMessageCell sizeForText:txt];
    } else if (type == LFLChatMessageRightType) {
        height = [self.leftMessageCell sizeForText:txt];
    }
//    height <= 25 ? height = 60 : (height += 10*2 + 3 + 20); // cell宽度
    height = height + 10*2 + 3 + 22;
    [message setValue:@(height) forKey:@"cell_height"];
    [LFLFetcher updateObjectPropertyWith:message];
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
    return [self.fetcher fetcherWith:[self provideClass] sortedBy:@"time" ascending:YES withPredicate:nil groupBy:nil];
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

#pragma mark LFLChatUserInputViewDelegate

- (void)sendMessage:(NSString *)message {
    [self saveMessageToCoreData:message];
    if (self.messageTableView.contentSize.height > ScreenHeight - 64 - self.messageTableViewToBottomLength.constant) {
        [self messageTableViewScrollAnimation:YES];
    }
}

#pragma mark 滚动到最底部

- (void)messageTableViewScrollToBottomAnimation:(BOOL)animated {
    CGFloat height = self.messageTableView.contentSize.height;
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

#pragma mark - CoreData

- (void)saveMessageToCoreData:(NSString *)message {
    Class entityClass = [self provideClass];
    NSInteger type = 0;
    if ([message containsString:@"110"]) {
        type = 1;
    }
    [LFLFetcher addObject:entityClass withPropertys:@{@"content":message,
                                                      @"time":[NSDate new],
                                                      @"cell_height":@(0),
                                                      @"type":@(type)}];
}

- (Class)provideClass {
    return NSClassFromString(@"LFLChatMessage");
}

#pragma mark - 刷新聊天页面

- (void)refreshMessageTableView {
    [self.messageTableView reloadData];
    [self messageTableViewScrollToBottomAnimation:YES];
}

#pragma mark - NSFetchedResultsDelegate

//- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(nullable NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(nullable NSIndexPath *)newIndexPath {
//    LFLLog(@"1");
//}
//
//- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
//    LFLLog(@"2");
//}
//
//- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
//    LFLLog(@"3");
//}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    if (controller != self.messageFetcher) {
        return;
    }
    [self refreshMessageTableView];
}

//- (nullable NSString *)controller:(NSFetchedResultsController *)controller sectionIndexTitleForSectionName:(NSString *)sectionName {
//    return @""
//}

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
    [menu setMenuItems:[NSArray arrayWithObjects:itCopy, itDelete,  nil]];
    CGRect rect = [cell convertRect:cell.bubbleImageView.frame toView:self.view];
    [menu setTargetRect:rect inView:self.view];
    [menu setMenuVisible:YES animated:YES];
}

- (void)deleteMessage:(LFLChetBaseViewCell *)cell {
    
}

#pragma mark menuController
- (void)menuControllerShow:(id)sender {
    
}

- (void)menuControllerHidden:(id)sender {
    [self.userInputView setInputViewNextResponser:nil];
}
@end
