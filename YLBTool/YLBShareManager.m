//
//  YLBShareManager.m
//  WhiteDragon
//
//  Created by 杨相伟 on 16/7/13.
//  Copyright © 2016年 YongLibao. All rights reserved.
//

#import "YLBShareManager.h" 
#import "TFHpple.h"
#import "ShareSheet.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import "YLBLogManager.h"
#import "YLBMemoryManager.h"
#import "NSArray+YLBUtil.h"
#import "YLBShareInfo.h"
#import "NSObject+YYModel.h"
@interface YLBShareManager ()

@property(nonatomic,strong)YLBShareInfo *evShareInfo;
@end

@implementation YLBShareManager

static YLBShareManager *shareManager = nil;

+(instancetype)sharedInstance{
    
    static dispatch_once_t onece;
    dispatch_once(&onece, ^{
        shareManager = [[self alloc] init];
    });
    return shareManager;
}

-(void)efExecShare:(YLBShareInfo *)shareInfo{
    _evShareInfo = shareInfo;
    if (shareInfo.sUrl.length >0) {
        if (shareInfo.sShareFromHtml) {
            [self shareFromhtml:shareInfo.sUrl];
        }else{
            [self shareClickTitle:shareInfo.sTitle connent:shareInfo.sContent url:shareInfo.sUrl imgUrl:shareInfo.sImageUrl];
        }
    }else{
        [[YLBLogManager sharedInstance] efAddLogWithTitle:[NSString stringWithFormat:@"share url ->%@",shareInfo.sUrl] detail:[shareInfo yy_modelToJSONString]];
    }
}

+(void)efExecShare:(YLBShareInfo *)shareInfo{
    [[YLBShareManager sharedInstance] efExecShare:shareInfo];
}


- (void)shareClickTitle:(NSString *)title connent:(NSString *)connent url:(NSString *)url imgUrl:(id)imgUrl {
    // 图片为空，引用icon图标
    if (imgUrl == nil) {
        imgUrl = [NSString stringWithFormat:@"%@%@",[[YLBMemoryManager sharedInstance] efGetServerIp],@"/dist/mobile/images/modules/global/appicon114.png"];
    }
    // 内容为空，引用标题
    if (connent == nil) {
        connent = title;
    }
    
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:3];
    NSArray *titles = @[@"微信", @"朋友圈", @"QQ"];
    for (int i = 0; i< 3; i++) {
        NSDictionary *dic = @{@"image": [NSString stringWithFormat:@"shareicon%d",i + 1], @"title": titles[i]};
        [array addObject:dic];
    }
    // 创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:connent
                                     images:imgUrl
                                        url:[NSURL URLWithString:url]
                                      title:title
                                       type:SSDKContentTypeAuto];
    __weak typeof(self) weakSelf = self;
    ShareSheet *shareSheet = [[[NSBundle mainBundle] loadNibNamed:@"ShareSheet" owner:nil options:nil] firstObject];
    shareSheet.shareClick = ^(NSInteger index){
        //设置分享平台
        SSDKPlatformType platformType = [self getSharePlatformType:index];
        
        //进行分享
        [weakSelf shareWithType:platformType param:shareParams];
    };
    shareSheet.shareContents = array;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    shareSheet.frame = window.frame;
    
    [window addSubview:shareSheet];
    [shareSheet show];
    
    NSLog(@"\n分享时数据：url = %@,\n title = %@,\n imageurl = %@,\n text = %@", url, title, imgUrl, connent);
}

-(SSDKPlatformType)getSharePlatformType:(NSInteger)index{
    SSDKPlatformType platformType = SSDKPlatformSubTypeWechatSession;
    switch (index) {
        case 1:
        {
            // 微信
            platformType = SSDKPlatformSubTypeWechatSession;
        }
            break;
        case 2:
        {
            // 朋友圈
            platformType = SSDKPlatformSubTypeWechatTimeline;
        }
            break;
        case 3:
        {
            // QQ
            platformType = SSDKPlatformTypeQQ;
        }
            break;
            
        default:
            break;
    }
    return platformType;
}

-(void)shareWithType:(SSDKPlatformType)type param:(NSMutableDictionary *)param{
    [ShareSDK share:type
         parameters:param
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         
         switch (state) {
                 // 分享成功
             case SSDKResponseStateSuccess:
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                     message:nil
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                 [alertView show];
                 break;
             }
                 // 分享失败
             case SSDKResponseStateFail:
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                     message:[NSString stringWithFormat:@"%@", error]
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                 [alertView show];
                 break;
             }
                 // 分享取消
             case SSDKResponseStateCancel:
             {
                 break;
             }
             default:
                 break;
         }
         
     }];
}

//分享内容从html获取
- (void)shareFromhtml:(NSString *)url {
    
    // 加载url获取图片数组分享图片
    NSString *shareImg =  [self getImgWithUrl:url];
    
    
    // 分享标题
    NSString *shareTitle = [self.evWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    // 分享文本
    NSString *shareText = [self.evWebView stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerText"];
    
    [self shareClickTitle:shareTitle connent:shareText url:url imgUrl:shareImg];
    
    //清除变量信息
    self.evWebView = nil;
}

- (NSString *)getImgWithUrl:(NSString *)url
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    if (response == nil){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"警告！" message:@"无法连接到该网站！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [alertView show];
        return nil;
    }
    
    NSArray *imagesData =  [self parseData:response];
    NSMutableArray *images = [self downLoadPicture:imagesData];
    return images.firstObject;
}

- (NSArray*)parseData:(NSData*) data
{
    //解析html数据
    {
        TFHpple *doc = [[TFHpple alloc] initWithHTMLData:data];
        
        //在页面中查找img标签
        NSArray *images = [doc searchWithXPathQuery:@"//img"];
        return images;
    }
}

- (NSMutableArray*)downLoadPicture:(NSArray *)images
{
    //下载图片的方法
    {
        //创建存放UIImage的数组
        NSMutableArray *downloadImages = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < [images count]; i++){
            NSString *prefix = [[[images objectAtIndexCheck:i] objectForKey:@"src"] substringToIndex:4];
            NSString *url = [[images objectAtIndexCheck:i] objectForKey:@"src"];
            
            //判断图片的下载地址是相对路径还是绝对路径，如果是以http开头，则是绝对地址，否则是相对地址
            if ([prefix isEqualToString:@"http"] == NO){
                url = [self.evShareInfo.sUrl stringByAppendingPathComponent:url];
            }
            
            NSURL *downImageURL = [NSURL URLWithString:url];
            
            UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:downImageURL]];
            
            if(image != nil){
                [downloadImages addObject:url];
            }
        }
        
        //清除变量信息
        self.evShareInfo = nil;
        
        return downloadImages;
    }
}


#pragma mark- 设置ShareSDK分享  @"33488d77d000"
- (void)efSetShareWithAppKey:(NSString *)appKey platformInfo:(NSDictionary *)platformInfo{
    
    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册，
     *  在将生成的AppKey传入到此方法中。
     *  方法中的第二个参数用于指定要使用哪些社交平台，以数组形式传入。第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
   
    [ShareSDK registerApp:appKey
          activePlatforms:@[
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ),
                            @(SSDKPlatformSubTypeWechatTimeline)
                            ]
                 onImport:^(SSDKPlatformType platformType) {
                     switch (platformType)
                     {
                         case SSDKPlatformTypeWechat:
                             [ShareSDKConnector connectWeChat:[WXApi class] delegate:self];
                             break;
                         case SSDKPlatformTypeQQ:
                             [ShareSDKConnector connectQQ:[QQApiInterface class]
                                        tencentOAuthClass:[TencentOAuth class]];
                             break;
                         default:
                             break;
                     }
                     
                 }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
              
              NSLog(@"%@",[platformInfo valueForKeyPath:@"SSDKPlatformTypeWechat.appId"]);
              if ([platformInfo allKeys].count == 0) {
                  return;
              }
              switch (platformType)
              {
                  case SSDKPlatformTypeWechat:
                      [appInfo SSDKSetupWeChatByAppId:[platformInfo valueForKeyPath:@"SSDKPlatformTypeWechat.appId"]
                                            appSecret:[platformInfo valueForKeyPath:@"SSDKPlatformTypeWechat.appKey"]];
                      break;
                  case SSDKPlatformTypeQQ:
                      [appInfo SSDKSetupQQByAppId:[platformInfo valueForKeyPath:@"SSDKPlatformTypeQQ.appId"]
                                           appKey:[platformInfo valueForKeyPath:@"SSDKPlatformTypeQQ.appKey"]
                                         authType:SSDKAuthTypeBoth];
                      break;
                  default:
                      break;
              }
          }];

}

+ (void)efSetShareWithAppKey:(NSString *)appKey platformInfo:(NSDictionary *)platformInfo{
    [[YLBShareManager sharedInstance] efSetShareWithAppKey:appKey platformInfo:(NSDictionary *)platformInfo];
}


@end
