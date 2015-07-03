//
//  EMChatToolbar.m
//  ChatDemo-UI3.0
//
//  Created by dhc on 15/7/1.
//  Copyright (c) 2015年 easemob.com. All rights reserved.
//

#import "EMChatToolbar.h"

@interface EMChatToolbar()<UITextViewDelegate>

@property (nonatomic) CGFloat version;

@property (strong, nonatomic) NSMutableArray *leftItems;
@property (strong, nonatomic) NSMutableArray *rightItems;

/**
 *  背景
 */
@property (strong, nonatomic) UIImageView *toolbarBackgroundImageView;
@property (strong, nonatomic) UIImageView *backgroundImageView;

/**
 *  底部扩展页面
 */
@property (nonatomic) BOOL isShowButtomView;
@property (strong, nonatomic) UIView *activityButtomView;//当前活跃的底部扩展页面

/**
 *  按钮、toolbarView
 */
@property (strong, nonatomic) UIView *toolbarView;
//@property (strong, nonatomic) UIButton *styleChangeButton;
//@property (strong, nonatomic) UIButton *moreButton;
//@property (strong, nonatomic) UIButton *faceButton;

/**
 *  输入框
 */
@property (nonatomic) CGFloat previousTextViewContentHeight;//上一次inputTextView的contentSize.height
@property (nonatomic) NSLayoutConstraint *inputViewWidthItemsLeftConstraint;
@property (nonatomic) NSLayoutConstraint *inputViewWidthoutItemsLeftConstraint;

@end

@implementation EMChatToolbar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [self initWithFrame:frame horizontalPadding:8 verticalPadding:5 inputViewMinHeight:36 inputViewMaxHeight:150];
    if (self) {
        //
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
            horizontalPadding:(CGFloat)horizontalPadding
              verticalPadding:(CGFloat)verticalPadding
           inputViewMinHeight:(CGFloat)inputViewMinHeight
           inputViewMaxHeight:(CGFloat)inputViewMaxHeight
{
    if (frame.size.height < (verticalPadding * 2 + inputViewMinHeight)) {
        frame.size.height = verticalPadding * 2 + inputViewMinHeight;
    }
    self = [super initWithFrame:frame];
    if (self) {
        _horizontalPadding = horizontalPadding;
        _verticalPadding = verticalPadding;
        _inputViewMinHeight = inputViewMinHeight;
        _inputViewMaxHeight = inputViewMaxHeight;
        
        _leftItems = [NSMutableArray array];
        _rightItems = [NSMutableArray array];
    }
    return self;
}

#pragma mark - setup subviews

- (void)_setupBackgroundImageView
{
    
}

- (void)_setupSubviews
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    self.version = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    self.activityButtomView = nil;
    self.isShowButtomView = NO;
    
    //backgroundImageView
    _backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _backgroundImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:_backgroundImageView];
    
    //toolbar
    _toolbarView = [[UIView alloc] initWithFrame:self.bounds];
    _toolbarView.backgroundColor = [UIColor clearColor];
    [self addSubview:_toolbarView];
    
    _toolbarBackgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _toolbarView.frame.size.width, _toolbarView.frame.size.height)];
    _toolbarBackgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _toolbarBackgroundImageView.backgroundColor = [UIColor clearColor];
    [_toolbarView addSubview:_toolbarBackgroundImageView];
    
    //输入框
    _inputTextView = [[DXTextView alloc] initWithFrame:CGRectMake(self.horizontalPadding, self.verticalPadding, self.frame.size.width - self.verticalPadding * 2, self.frame.size.height - self.horizontalPadding * 2)];
    _inputTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _inputTextView.scrollEnabled = YES;
    _inputTextView.returnKeyType = UIReturnKeySend;
    _inputTextView.enablesReturnKeyAutomatically = YES; // UITextView内部判断send按钮是否可以用
    _inputTextView.placeHolder = NSLocalizedString(@"message.toolBar.inputPlaceHolder", @"input a new message");
    _inputTextView.delegate = self;
    _inputTextView.backgroundColor = [UIColor clearColor];
    _inputTextView.layer.borderColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
    _inputTextView.layer.borderWidth = 0.65f;
    _inputTextView.layer.cornerRadius = 6.0f;
    _previousTextViewContentHeight = [self _getTextViewContentH:_inputTextView];
    [_toolbarView addSubview:_inputTextView];
    
    //转变输入样式
    UIButton *styleChangeButton = [[UIButton alloc] init];
    [styleChangeButton setImage:[UIImage imageNamed:@"chatBar_record"] forState:UIControlStateNormal];
    [styleChangeButton setImage:[UIImage imageNamed:@"chatBar_keyboard"] forState:UIControlStateSelected];
    [styleChangeButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    EMChatToolbarItem *styleItem = [[EMChatToolbarItem alloc] initWithButton:styleChangeButton withView:nil];
    [self setInputViewLeftItems:@[styleItem]];
    
    //更多
    UIButton *moreButton = [[UIButton alloc] init];
    [moreButton setImage:[UIImage imageNamed:@"chatBar_more"] forState:UIControlStateNormal];
    [moreButton setImage:[UIImage imageNamed:@"chatBar_moreSelected"] forState:UIControlStateHighlighted];
    [moreButton setImage:[UIImage imageNamed:@"chatBar_keyboard"] forState:UIControlStateSelected];
    [moreButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    DXChatBarMoreView *moreView = [[DXChatBarMoreView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_toolbarView.frame), self.frame.size.width, 80) type:ChatMoreTypeGroupChat];
    moreView.backgroundColor = [UIColor lightGrayColor];
    moreView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    EMChatToolbarItem *moreItem = [[EMChatToolbarItem alloc] initWithButton:moreButton withView:moreButton];
    
    //表情
    UIButton *faceButton = [[UIButton alloc] init];
    [faceButton setImage:[UIImage imageNamed:@"chatBar_face"] forState:UIControlStateNormal];
    [faceButton setImage:[UIImage imageNamed:@"chatBar_faceSelected"] forState:UIControlStateHighlighted];
    [faceButton setImage:[UIImage imageNamed:@"chatBar_keyboard"] forState:UIControlStateSelected];
    [faceButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    DXFaceView *faceView = [[DXFaceView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_toolbarView.frame), self.frame.size.width, 200)];
    [(DXFaceView *)faceView setDelegate:self];
    faceView.backgroundColor = [UIColor lightGrayColor];
    faceView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    EMChatToolbarItem *faceItem = [[EMChatToolbarItem alloc] initWithButton:faceButton withView:faceView];
    [self setInputViewRightItems:@[faceItem, moreItem]];
}

#pragma mark - UITextViewDelegate

#pragma mark - input view

- (CGFloat)_getTextViewContentH:(UITextView *)textView
{
    if (self.version >= 7.0)
    {
        return ceilf([textView sizeThatFits:textView.frame.size].height);
    } else {
        return textView.contentSize.height;
    }
}

#pragma mark - UIKeyboardNotification

- (void)_willShowBottomHeight:(CGFloat)bottomHeight
{
    CGRect fromFrame = self.frame;
    CGFloat toHeight = self.toolbarView.frame.size.height + bottomHeight;
    CGRect toFrame = CGRectMake(fromFrame.origin.x, fromFrame.origin.y + (fromFrame.size.height - toHeight), fromFrame.size.width, toHeight);
    
    //如果需要将所有扩展页面都隐藏，而此时已经隐藏了所有扩展页面，则不进行任何操作
    if(bottomHeight == 0 && self.frame.size.height == self.toolbarView.frame.size.height)
    {
        return;
    }
    
    if (bottomHeight == 0) {
        self.isShowButtomView = NO;
    }
    else{
        self.isShowButtomView = YES;
    }
    
    self.frame = toFrame;
    
//    if (_delegate && [_delegate respondsToSelector:@selector(didChangeFrameToHeight:)]) {
//        [_delegate didChangeFrameToHeight:toHeight];
//    }
}

- (void)_willShowKeyboardFromFrame:(CGRect)beginFrame toFrame:(CGRect)toFrame
{
    if (beginFrame.origin.y == [[UIScreen mainScreen] bounds].size.height)
    {
        //一定要把self.activityButtomView置为空
        [self _willShowBottomHeight:toFrame.size.height];
        if (self.activityButtomView) {
            [self.activityButtomView removeFromSuperview];
        }
        self.activityButtomView = nil;
    }
    else if (toFrame.origin.y == [[UIScreen mainScreen] bounds].size.height)
    {
        [self _willShowBottomHeight:0];
    }
    else{
        [self _willShowBottomHeight:toFrame.size.height];
    }
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect beginFrame = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    void(^animations)() = ^{
        [self _willShowKeyboardFromFrame:beginFrame toFrame:endFrame];
    };
    
    [UIView animateWithDuration:duration delay:0.0f options:(curve << 16 | UIViewAnimationOptionBeginFromCurrentState) animations:animations completion:nil];
}

#pragma mark - setter

- (void)setInputViewLeftItems:(NSArray *)inputViewLeftItems
{
    for (EMChatToolbarItem *item in self.leftItems) {
        [item.button removeFromSuperview];
        [item.button2View removeFromSuperview];
    }
    [self.leftItems removeAllObjects];
    
    CGFloat oX = self.horizontalPadding;
    CGFloat itemHeight = self.toolbarView.frame.size.height - self.verticalPadding * 2;
    for (id item in inputViewLeftItems) {
        if ([item isKindOfClass:[EMChatToolbarItem class]]) {
            EMChatToolbarItem *chatItem = (EMChatToolbarItem *)item;
            if (chatItem.button) {
                CGRect itemFrame = chatItem.button.frame;
                if (itemFrame.size.height == 0) {
                    itemFrame.size.height = itemHeight;
                }
                
                if (itemFrame.size.width == 0) {
                    itemFrame.size.width = itemFrame.size.height;
                }
                
                itemFrame.origin.x = oX;
                itemFrame.origin.y = (self.toolbarView.frame.size.height - itemFrame.size.height) / 2;
                chatItem.button.frame = itemFrame;
                oX += (itemFrame.size.width + self.horizontalPadding);
                
                [self.leftItems addObject:chatItem];
            }
        }
    }
    
    CGRect inputFrame = self.inputTextView.frame;
    CGFloat value = inputFrame.origin.x - oX;
    inputFrame.origin.x = oX;
    inputFrame.size.width += value;
    self.inputTextView.frame = inputFrame;
}

- (void)setInputViewRightItems:(NSArray *)inputViewRightItems
{
    for (EMChatToolbarItem *item in self.rightItems) {
        [item.button removeFromSuperview];
        [item.button2View removeFromSuperview];
    }
    [self.rightItems removeAllObjects];
    
    CGFloat oMaxX = self.toolbarView.frame.size.width - self.horizontalPadding;
    CGFloat itemHeight = self.toolbarView.frame.size.height - self.verticalPadding * 2;
    if ([inputViewRightItems count] > 0) {
        for (NSInteger i = (inputViewRightItems.count - 1); i >= 0; i--) {
            id item = [inputViewRightItems objectAtIndex:i];
            if ([item isKindOfClass:[EMChatToolbarItem class]]) {
                EMChatToolbarItem *chatItem = (EMChatToolbarItem *)item;
                if (chatItem.button) {
                    CGRect itemFrame = chatItem.button.frame;
                    if (itemFrame.size.height == 0) {
                        itemFrame.size.height = itemHeight;
                    }
                    
                    if (itemFrame.size.width == 0) {
                        itemFrame.size.width = itemFrame.size.height;
                    }
                    
                    oMaxX -= itemFrame.size.width;
                    itemFrame.origin.x = oMaxX;
                    itemFrame.origin.y = (self.toolbarView.frame.size.height - itemFrame.size.height) / 2;
                    chatItem.button.frame = itemFrame;
                    oMaxX -= self.horizontalPadding;
                    
                    [self.rightItems addObject:item];
                }
            }
        }
    }
    
    CGRect inputFrame = self.inputTextView.frame;
    CGFloat value = oMaxX - CGRectGetMaxX(inputFrame);
    inputFrame.size.width += value;
    self.inputTextView.frame = inputFrame;
}

#pragma mark - action

#pragma mark - public

/**
 *  默认高度
 *
 *  @return 默认高度
 */
+ (CGFloat)defaultHeight
{
    return 5 * 2 + 36;
}

@end
