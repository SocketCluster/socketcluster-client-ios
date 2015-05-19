//
//  SocketClusterDelegate.h
//  SocketClusteriOSDemo
//
//  Created by Lihan Li on 23/04/2015.
//  Copyright (c) 2015 TopCloud. All rights reserved.
//

#import <Foundation/Foundation.h>


@class SocketCluster;

@protocol SocketClusterDelegate<NSObject>

@optional

- (void)socketClusterDidConnect;
- (void)socketClusterDidDisconnect;
- (void)socketClusterOnError:(NSString *)error;
- (void)socketClusterOnStatusChange;
- (void)socketClusterOnKickOut;
- (void)socketClusterOnSubscribe;
- (void)socketClusterOnSubscribeFail;
- (void)socketClusterOnUnsubscribe;

- (void)socketClusterReceivedEvent:(NSString *)eventName WithData:(NSDictionary *)data;
- (void)socketclusterChannelReceivedEvent:(NSString *)eventName WithData:(NSDictionary *)data;
@end
