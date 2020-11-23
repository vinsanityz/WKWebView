//
//  ViewController.m
//  wkwebviewDemo
//
//  Created by farben on 2020/11/18.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
#import "webViewController.h"
#import "navRootViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:[[navRootViewController alloc]init]];
//    [nav pushViewController:[[webViewController alloc]init] animated:NO];
    [nav addChildViewController:[[webViewController alloc]init]];
    [nav popToViewController:nav.viewControllers[0] animated:YES];
    [self addChildViewController:nav];
    [self.view addSubview:nav.view];
}
@end
