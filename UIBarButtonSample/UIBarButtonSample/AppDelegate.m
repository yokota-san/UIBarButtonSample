//
//  AppDelegate.m
//  UIBarButtonSample
//
//  Created by yokotasan on 2015/12/06.
//  Copyright © 2015年 yokotasan. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "UIColor+Addition.h"
#import <QuartzCore/QuartzCore.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    ViewController *rootViewController = [[ViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

// 参照: http://qiita.com/odorry/items/b5e0ccc8bfec2681a047
UIImage *(^createImageFromUIColor)(UIColor *) = ^(UIColor *color)
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(contextRef, [color CGColor]);
    CGContextFillRect(contextRef, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
};

@end