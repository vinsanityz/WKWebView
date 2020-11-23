//
//  yellowViewController.m
//  wkwebviewDemo
//
//  Created by farben on 2020/11/20.
//
#import "webViewController.h"
#import "yellowViewController.h"

@interface yellowViewController ()

@end

@implementation yellowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"yellowView";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"goback" style:UIBarButtonItemStylePlain target:self action:@selector(goback)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"webview" style:UIBarButtonItemStylePlain target:self action:@selector(gogo)];
    self.view.backgroundColor = [UIColor yellowColor];
}
-(void)goback{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)gogo{
    [self.navigationController pushViewController:[[webViewController alloc]init] animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
