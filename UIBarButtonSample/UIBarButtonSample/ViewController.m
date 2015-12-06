//
//  ViewController.m
//  UIBarButtonSample
//
//  Created by yokotasan on 2015/12/06.
//  Copyright © 2015年 yokotasan. All rights reserved.
//

#import "ViewController.h"

#define AppliedTestCase LayoutTestCaseDefault
typedef NS_ENUM (NSUInteger, LayoutTestCase) {
    LayoutTestCaseDefault = 1,
    LayoutTestCaseAdjustSideMargin
};

@interface YYButton : UIButton
typedef void (^TouchBlock)(void);
@property (nonatomic, strong) TouchBlock onTouch;
@end

@implementation YYButton
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    if (CGRectContainsPoint(self.bounds, [touch locationInView:self]))
    {
        if (self.onTouch) self.onTouch();
    }
}
@end

@interface ViewController ()
@property (nonatomic, assign) NSUInteger count;
@end

@implementation ViewController

#pragma mark - LifeCycle

- (void)dealloc {
    
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.count = 1;
    }
    return self;
}

- (void)viewDidLoad {
#ifdef AppliedTestCase
    [self setupNavigationController];
    [self setup];
    [super viewDidLoad];
#else
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:@"AppliedTestCaseに値を設定してください"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction *action) {
                                                NSAssert(nil, nil);
                                            }]];
    [self presentViewController:alert animated:YES completion:nil];
#endif
}

#pragma mark - View Initialization

- (void)setupNavigationController
{
    UIColor *defaultColor = [UIColor colorWithRed:100.0f/255.0f
                                            green:199.0f/255.0f
                                             blue:199.0f/255.0f
                                            alpha:1.0f];
    self.navigationController.navigationBar.backgroundColor = defaultColor;
    self.navigationController.toolbar.barTintColor = defaultColor;
    self.navigationController.toolbar.translucent = YES;
    self.navigationController.toolbarHidden = NO;
    
    switch (AppliedTestCase) {
        case LayoutTestCaseDefault:
            [self testCaseDefaultLayout];
            break;
        case LayoutTestCaseAdjustSideMargin:
            [self testCaseAdjustSideMargin];
            break;
        default:
            break;
    }
}

- (void)setup
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    YYButton *nextButton = [self nextButton];
    nextButton.center = self.view.center;
    
    [self.view addSubview:nextButton];
}

#pragma mark - sample Code

- (void)testCaseDefaultLayout
{
    self.navigationItem.title = @"デフォルトレイアウト";
    
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:[self customButton]]];
    [self setToolbarItems:@[[[UIBarButtonItem alloc] initWithCustomView:[self customButton]],
                            [[UIBarButtonItem alloc] initWithCustomView:[self customButton]],
                            [[UIBarButtonItem alloc] initWithCustomView:[self customButton]],
                            [[UIBarButtonItem alloc] initWithCustomView:[self customButton]]]];
    
    
}

- (void)testCaseAdjustSideMargin
{
    self.navigationItem.title = @"マージンなしレイアウト";
    
    //マイナスの横幅でFixedSpaceをいれてあげると、NavigationBar/ToolBar両端のマージンを調整できる
    UIBarButtonItem *sideMarginSpaceAdjustment = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                               target:nil
                                                                                               action:nil];
    /**
     OS側で設定されている両脇のマージンは
     Plus系の機種は20
     その他iPhoneは16
     iPadとかは知らない
     */
    sideMarginSpaceAdjustment.width = -20.0f;
    
    self.navigationItem.rightBarButtonItems = @[sideMarginSpaceAdjustment,
                                                [[UIBarButtonItem alloc] initWithCustomView:[self customButton]]];
    [self setToolbarItems:@[sideMarginSpaceAdjustment,
                            [[UIBarButtonItem alloc] initWithCustomView:[self customButton]],
                            [[UIBarButtonItem alloc] initWithCustomView:[self customButton]],
                            [[UIBarButtonItem alloc] initWithCustomView:[self customButton]],
                            [[UIBarButtonItem alloc] initWithCustomView:[self customButton]]]];
}

#pragma mark - etc.

- (YYButton *)nextButton
{
    YYButton *object = [YYButton buttonWithType:UIButtonTypeSystem];
    [object setTitle:@"次へ" forState:UIControlStateNormal];
    [object sizeToFit];
    
    __weak typeof(self) _weakSelf = self;
    object.onTouch = ^{
        [_weakSelf.navigationController pushViewController:[[ViewController alloc] init] animated:YES];
    };
    
    return object;
}

- (UIButton *)customButton
{
    UIButton *object = [UIButton buttonWithType:UIButtonTypeSystem];
    [object setTitle:[NSString stringWithFormat:@"%@%lu", @"ボタン", (unsigned long)self.count] forState:UIControlStateNormal];
    object.backgroundColor = [self buttonColor];
    object.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    object.layer.borderWidth = 1.0f;
    
    self.count++;
    
    [object sizeToFit];
    
    return object;
}

- (UIColor *)buttonColor
{
    return [UIColor colorWithRed:255.0f/255.0f
                           green:255.0f/255.0f
                            blue:222.0f/255.0f
                           alpha:1.0f];
}

@end