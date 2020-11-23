//
//  navRootViewController.m
//  wkwebviewDemo
//
//  Created by farben on 2020/11/20.
//

#import "navRootViewController.h"
#import "yellowViewController.h"
@interface navRootViewController ()

@end

@implementation navRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    
    
    self.navigationItem.title = @"redView";
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"yellowView" style:UIBarButtonItemStylePlain target:self action:@selector(gogo)];
    self.navigationItem.rightBarButtonItem=leftBarButtonItem;
    
    
}
-(void)gogo{
    [self.navigationController pushViewController:[[yellowViewController alloc]init] animated:YES];
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
