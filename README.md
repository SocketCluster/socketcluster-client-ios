# socketcluster-client-ios
Native iOS client for SocketCluster

The project is in beta.

### Setup

#### Cocoapods

**Podfile**

```
platform :ios, '8.0'
 
pod 'SocketClusteriOS', '0.2.2'

```

Run ``pod install``, you are all set.

Notice: Do not use ``use_frameworks!`` in Podfile, it will put the bundle in frameworks folder to cause incorrect path issue. If you need to use this, please consider to send a pull request.

### Subproject

1. Drag this project into your project as subproject
2. Setup this project as build dependency
3. Import the header files ``#import <SocketClusteriOS/SocketCluster.h>``

### Static Library

1. Add ``libSocketClusteriOS.a``, ``SocketCluster.h`` and ``SocketClusterDelegate.h`` and ``SocketClusteriOSBundle.bundle`` to your project.
2. Import the module by ``#import <SocketClusteriOS/SocketCluster.h>``
3. In the header file, confront to the protocol ``<SocketClusterDelegate>``, eg. ``@interface ViewController : UIViewController <SocketClusterDelegate>``
4. Initialize the module and set the delegate to self.
  ```
      SocketCluster *sc = [[SocketCluster alloc] init];
      sc.delegate = self; //Self 
    ```
  
### Connect to host

  ``[socketCluster connectToHost:@"127.0.0.1" onPort:8000 securly:NO];``
  
### Disconnect to host

  ``[socketCluster disconnect];``

### Get state of a connection

  ``[socketCluster getState];``

### Listen to an event

Make sure you have implemented protocol ``<SocketClusterDelegate>``

```
- (void)socketClusterReceivedEvent:(NSString *)eventName WithData:(NSDictionary *)data;
{
    if ([@"rand" isEqualToString:eventName]) {
        NSArray *positiveFaces = @[@";p", @":D", @":)", @":3", @";)"];
        NSNumber *index = data[@"rand"];
        NSString *face = [positiveFaces objectAtIndex:[index intValue]];
        NSString *msg = [NSString stringWithFormat:@"rand event received: %@", face];
        [self logMessage:msg];
    }
}
```

### Emit an event
  ``data`` can be any format, but they should be serializable
  ``[socketCluster emitEvent:@"eventName" WithData:data];``
  
### Subscribe to a channel

  ``[socketCluster subscribeToChannel:@"channelName"];``

### Unsubscribe to a channel
  
  ``[socketCluster unsubscribeFromChannel:@"channelName"];``

### Publish to a channel
  ``data`` can be in any format
  ``[socketCluster publishToChannel:@"channelName" WithData:data];``
  
### Listen to channelEvents (``watch`` in JS client)

Make sure you have implemented protocol ``<SocketClusterDelegate>``

  ```
- (void)socketclusterChannelReceivedEvent:(NSString *)channel WithData:(NSDictionary *)data
{
    if ([@"pong" isEqualToString:channel]) {
        [self logMessage:[NSString stringWithFormat:@"Channel %@ received message %@", channel, data[@"data"]]];
    }
    
}
```

### Get list of all subscriptions

  ``NSArray * subscriptions = [socketCluster getSubscriptions];``
  
### Get list of all subscriptions including pending subscriptions
  
  ``NSArray * subscriptions = [socketCluster getSubscriptionsIncludingPending];``


### Some other useful callbacks

All these callback would only work if you have implemented protocol ``<SocketClusterDelegate>``

```
- (void)socketClusterDidConnect
{
    [self logMessage:@"Connected"];
}
- (void)socketClusterDidDisconnect
{
    [self logMessage:@"Disconnected"];
}
- (void)socketClusterOnError
{
    [self logMessage:@"Error"];
}
```
