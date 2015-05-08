//
//  SocketCluster.h
//  SocketClusteriOS
//
//  Created by Lihan Li on 23/04/2015.
//  Copyright (c) 2015 TopCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "SocketClusterDelegate.h"

typedef void(^SocketClusterCallback)(id argsData);

typedef NS_ENUM(NSInteger, SocketClusterState) {
    SocketClusterStateConnecting,
    SocketClusterStateOpen,
    SocketClusterStateClosing,
    SocketClusterStateClosed
};


/**
 * The SocketCluster class defines the methods you use to interact with 
 * SocketCluster NodeJS server
 **/
@interface SocketCluster : NSObject <UIWebViewDelegate>


@property (assign, nonatomic) id <SocketClusterDelegate>delegate;
@property (nonatomic, readonly) NSString* socketId;

- (void)connectToHost:(NSString *)host onPort:(NSInteger)port securly:(BOOL)isSecureConnection;
- (void)disconnect;
- (NSString *)getState;
- (void)registerEvent:(NSString *)eventName;
- (void)emitEvent:(NSString *)eventName WithData:(id)data;
- (void)publishToChannel:(NSString *)channelName WithData:(id)data;
- (void)subscribeToChannel:(NSString *)channelName;
- (void)unsubscribeFromChannel:(NSString *)channelName;

- (NSArray *)getSubscriptions;
- (NSArray *)getSubscriptionsIncludingPending;

@end
