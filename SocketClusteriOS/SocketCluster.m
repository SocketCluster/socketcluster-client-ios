//
//  SocketCluster.m
//  SocketClusteriOSDemo
//
//  Created by Lihan Li on 23/04/2015.
//  Copyright (c) 2015 TopCloud. All rights reserved.
//

#import "SocketCluster.h"



@interface SocketCluster()

@property (strong, nonatomic) UIWebView *webView;
@property WebViewJavascriptBridge* bridge;
@property (strong, nonatomic) JSContext *ctx;


@end


@implementation SocketCluster



- (instancetype)init
{
    if (self = [super init]) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"SocketClusteriOSBundle" withExtension:@"bundle"]];
        NSString* htmlPath = [bundle pathForResource:@"socketcluster-webwrapper" ofType:@"enc"];
        NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
        NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
        [_webView loadHTMLString:appHtml baseURL:baseURL];

        self.bridge = [WebViewJavascriptBridge bridgeForWebView:_webView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        } resourceBundle:bundle];
        
        self.ctx = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
        [WebViewJavascriptBridge enableLogging];
        [self.bridge registerHandler:@"onConnectHandler" handler:^(id data, WVJBResponseCallback responseCallback){
            if ([self.delegate respondsToSelector:@selector(socketClusterDidConnect)]){
                [self.delegate socketClusterDidConnect];
            }
        }];
        [self.bridge registerHandler:@"onDisconnectedHandler" handler:^(id data, WVJBResponseCallback responseCallback){
            if ([self.delegate respondsToSelector:@selector(socketClusterDidDisconnect)]){
                [self.delegate socketClusterDidDisconnect];
            }
        }];
        
        [self.bridge registerHandler:@"onErrorHandler" handler:^(id data, WVJBResponseCallback responseCallback){
            if ([self.delegate respondsToSelector:@selector(socketClusterOnError)]){
                [self.delegate socketClusterOnError];
            }
        }];
        
        [self.bridge registerHandler:@"onStatusHandler" handler:^(id data, WVJBResponseCallback responseCallback){
            if ([self.delegate respondsToSelector:@selector(socketClusterOnStatusChange)]){
                [self.delegate socketClusterOnStatusChange];
            }
        }];
        
        [self.bridge registerHandler:@"onKickoutHandler" handler:^(id data, WVJBResponseCallback responseCallback){
            if ([self.delegate respondsToSelector:@selector(socketClusterOnKickOut)]){
                [self.delegate socketClusterOnKickOut];
            }
        }];

        [self.bridge registerHandler:@"onSubscribeFailHandler" handler:^(id data, WVJBResponseCallback responseCallback){
            if ([self.delegate respondsToSelector:@selector(socketClusterOnSubscribeFail)]){
                [self.delegate socketClusterOnSubscribeFail];
            }
        }];
        
        [self.bridge registerHandler:@"onUnsubscribeHandler" handler:^(id data, WVJBResponseCallback responseCallback){
            if ([self.delegate respondsToSelector:@selector(socketClusterOnUnsubscribe)]){
                [self.delegate socketClusterOnUnsubscribe];
            }
        }];

        [self.bridge registerHandler:@"onSubscribeHandler" handler:^(id data, WVJBResponseCallback responseCallback){
            if ([self.delegate respondsToSelector:@selector(socketClusterOnSubscribe)]){
                [self.delegate socketClusterOnSubscribe];
            }
        }];
        
        [self.bridge registerHandler:@"onEventReceivedFromSocketCluster" handler:^(id data, WVJBResponseCallback responseCallback){
            if ([self.delegate respondsToSelector:@selector(socketClusterReceivedEvent:WithData:)]){
                [self.delegate socketClusterReceivedEvent:data[@"event"] WithData:data[@"data"]];
            }
        }];

        [self.bridge registerHandler:@"onChannelReceivedEventFromSocketCluster" handler:^(id data, WVJBResponseCallback responseCallback){
            if ([self.delegate respondsToSelector:@selector(socketclusterChannelReceivedEvent:WithData:)]){
                [self.delegate socketclusterChannelReceivedEvent:data[@"channel"] WithData:data];
            }
        }];
        
    }
    return self;
}

- (NSString *)socketId
{
    JSValue *jsFunction = self.ctx[@"getSocketId"];
    JSValue *value = [jsFunction callWithArguments:@[]];
    return  [value toString];
}

- (void)connectToHost:(NSString *)host onPort:(NSInteger)port securly:(BOOL)isSecureConnection
{
    [self.bridge callHandler:@"connectHandler" data:@{
        @"hostname": host,
        @"port": [NSString stringWithFormat:@"%ld", (long)port],
        @"secure": isSecureConnection ? @"true" : @"false"
    }];
}

- (void)disconnect
{
    [self.bridge callHandler:@"disconnectHandler"];
}

- (NSString *)getState
{
    JSValue *jsFunction = self.ctx[@"getSocketStateBridge"];
    JSValue *value = [jsFunction callWithArguments:@[]];
    NSString *resultState = [value toString];
    
    return resultState;
}

- (void)emitEvent:(NSString *)eventName WithData:(id)socketData
{
    if (nil == socketData){
        socketData = [NSNull null];
    }
    NSDictionary *tempData = @{
       @"event": eventName,
       @"data": socketData
    };
    [self.bridge callHandler:@"emitEventHandler" data:tempData];
}


- (void)registerEvent:(NSString *)eventName
{
    NSDictionary *data = @{
        @"event": eventName
    };
    [self.bridge callHandler:@"onEventHandler" data:data];
}

- (void)publishToChannel:(NSString *)channelName WithData:(id)data
{
    NSDictionary *channelData = @{
        @"channel": channelName,
        @"data": data
    };
    [self.bridge callHandler:@"publishHandler" data:channelData];

}

- (void)subscribeToChannel:(NSString *)channelName
{
    NSDictionary *data = @{
        @"channel": channelName
    };
    [self.bridge callHandler:@"subscribeHandler" data:data];
}


- (void)unsubscribeFromChannel:(NSString *)channelName
{
    NSDictionary *data = @{
        @"channel": channelName
    };
    [self.bridge callHandler:@"unsubscribeHandler" data:data];
}


- (NSArray *)getSubscriptions
{
    JSValue *jsFunction = self.ctx[@"getSubscriptionsBridge"];
    JSValue *value = [jsFunction callWithArguments:@[]];
    NSArray *result = [value toArray];
    return result;
}

- (NSArray *)getSubscriptionsIncludingPending
{
    JSValue *jsFunction = self.ctx[@"getSubscriptionsBridge"];
    JSValue *value = [jsFunction callWithArguments:@[@YES]];
    NSArray *result = [value toArray];
    return result;
}



@end
