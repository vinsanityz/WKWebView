//
//  webViewController.m
//  wkwebviewDemo
//
//  Created by farben on 2020/11/20.
//

#import "webViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "SceneDelegate.h"

#import <WebKit/WebKit.h>

@interface webViewController ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>
@property(weak,nonatomic) WKWebView * webview;
@end

@implementation webViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"redView";

    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    
    config.selectionGranularity = WKSelectionGranularityDynamic;
    //yes是使用h5的视频播放器在线播放, no使用原生播放器全屏播放
    config.allowsInlineMediaPlayback = YES;
    //设置视频是否需要用户手动播放  设置为NO则会允许自动播放
    config.requiresUserActionForMediaPlayback = YES;
    //设置是否允许画中画技术 在特定设备上有效
    config.allowsPictureInPictureMediaPlayback = YES;

    WKPreferences *preferences = [WKPreferences new];
    //是否支持JavaScript
    preferences.javaScriptEnabled = YES;
    //最小字体大小 当将javaScriptEnabled属性设置为NO时，可以看到明显的效果
    preferences.minimumFontSize = 0;
    //不通过用户交互，是否可以打开窗口
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    config.preferences = preferences;
    
    //这个类主要用来做native与JavaScript的交互管理
    WKUserContentController * wkUController = [[WKUserContentController alloc] init];
    //注册一个name为jsToOcNoPrams的js方法，设置处理接收JS方法的代理
//    [wkUController addScriptMessageHandler:self  name:@"jsToOcNoPrams"];
    [wkUController addScriptMessageHandler:self  name:@"funzcz"];
    [wkUController addScriptMessageHandler:self  name:@"funzcz22"];
    
    config.userContentController = wkUController;
    
    WKWebView *webview = [[WKWebView alloc] initWithFrame:CGRectMake(0, [self isPhoneX]==YES?88:64, [UIScreen mainScreen].bounds.size.width,[self isPhoneX]==YES? [UIScreen mainScreen].bounds.size.height-34-88:[UIScreen mainScreen].bounds.size.height-64) configuration:config];
    webview.navigationDelegate = self;
    webview.UIDelegate = self;
    webview.scrollView.bounces = NO;
    [webview loadRequest:[NSURLRequest requestWithURL:[[NSBundle mainBundle] URLForResource:@"zcz.html" withExtension:nil]]];
    self.webview = webview;
    [self.webview addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:0];
    [self.view addSubview:webview];


    ////    /* 加载服务器url的方法*/
//    NSString *url = @"https://www.baidu.com";
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
//    [webview loadRequest:request];
//
  


}

- (BOOL)isPhoneX {
    BOOL iPhoneX = NO;
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {//判断是否是手机
        return iPhoneX;
    }
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [[UIApplication sharedApplication].windows firstObject];
        if (mainWindow.safeAreaInsets.bottom > 0.0) {
            iPhoneX = YES;
        }
    }
    return iPhoneX;
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    NSLog(@"%@",change[@"new"]);
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.webview.configuration.userContentController removeScriptMessageHandlerForName:@"funzcz"];
    [self.webview.configuration.userContentController removeScriptMessageHandlerForName:@"funzcz22"];
    [self.webview removeObserver:self forKeyPath:@"estimatedProgress"];
}
#pragma mark - WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{

}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{

}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [webView evaluateJavaScript:
    @"var script = document.createElement('script');"
    "script.type = 'text/javascript';"
    "script.text = \"function ResizeImages() { "
        "var myimg,oldwidth;"
        "var maxwidth=375;" // WebView中显示的图片最大宽度
        "for(i=0;i <document.images.length;i++){"
            "myimg = document.images[i];"
            "oldwidth = myimg.width;"
            "if(oldwidth > maxwidth){"//原图大于最大宽度
                "if(myimg.width>myimg.height){"//原图的宽度大于高度
                    "myimg.width=maxwidth*2/3;"
                    "myimg.height = myimg.width*myimg.height/oldwidth;" //修改高度
                "}else{"//原图的宽度小于高度
                    "myimg.width=maxwidth*2/3;"
                    "myimg.height = myimg.width*myimg.height/oldwidth;" //修改高度
                "}"
            "}"
        "}"
    "}\";"
    "document.getElementsByTagName('head')[0].appendChild(script);" completionHandler:nil];
    [webView evaluateJavaScript:@"ResizeImages();" completionHandler:nil];
    __weak typeof(self) weakself = self;
    [webView evaluateJavaScript:@"document.title" completionHandler:^(id object, NSError * error) {
        weakself.navigationItem.title = object;
    }];
    
    //阻止双击放大
    NSString *injectionJSString = @"var script = document.createElement('meta');"
        "script.name = 'viewport';"
        "script.content=\"width=device-width, user-scalable=no\";"
        "document.getElementsByTagName('head')[0].appendChild(script);";
        [webView evaluateJavaScript:injectionJSString completionHandler:nil];

}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{

}
// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{

    NSLog(@"%@",navigationResponse.response.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationResponsePolicyCancel);
}
// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{

     NSLog(@"%@",navigationAction.request.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationActionPolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationActionPolicyCancel);
}
#pragma mark - WKUIDelegate
// 创建一个新的WebView
//- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
//    return [[WKWebView alloc]init];
//}
// 输入框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler{
    completionHandler(@"http");
}
// 确认框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler{
    completionHandler(YES);
}
// 警告框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    NSLog(@"%@",message);
    completionHandler();
}


- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    if([message.name isEqual:@"funzcz"]){

        UIAlertController * ac = [UIAlertController alertControllerWithTitle:@"funzcz" message:@"这是一个弹窗" preferredStyle:UIAlertControllerStyleAlert];
        [ac addAction:[UIAlertAction actionWithTitle:@"choose" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    
        }]];

        [self presentViewController:ac animated:YES completion:nil];
        NSLog(@"%@",message.body);
    
    }else if([message.name isEqualToString:@"funzcz22"]){
        UIAlertController * ac = [UIAlertController alertControllerWithTitle:@"funzcz22" message:@"这是一个弹窗" preferredStyle:UIAlertControllerStyleAlert];
        [ac addAction:[UIAlertAction actionWithTitle:@"choose" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    
        }]];

        [self presentViewController:ac animated:YES completion:nil];
        
        
    }
    
    
    
    
}

-(void)dealloc
{
    NSLog(@"%s",__func__);
}
@end
