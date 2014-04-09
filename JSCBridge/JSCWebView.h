//
//  JSCWebView.h
//  JSCBridge
//
//  Created by Reg Dwarf on 31/03/14.
//  Copyright (c) 2014 Dwarf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

typedef void (^ JSCHandler)(NSDictionary *data);
typedef void (^ JSCCallbackHandler)(NSDictionary *data, JSCHandler callback);
typedef void (^ JSCTrigger)(NSString *event, NSString *type, NSDictionary *data);

@interface JSCWebView : UIWebView

@property (strong, nonatomic) JSContext *jsContext;
@property (strong, nonatomic) JSValue *triggerJS;
@property (strong, atomic) NSNumber *messageCount;
@property (strong, nonatomic) NSMutableDictionary *listeners;
@property (strong, nonatomic) NSMutableDictionary *callbacks;

- (void)refreshContext;
- (void)on:(NSString *)event perform:(JSCHandler)handler;
- (void)on:(NSString *)event performWithCallback:(JSCCallbackHandler)handler;
- (void)off:(NSString *)event;
- (void)send:(NSString *)event;
- (void)send:(NSString *)event withData:(NSDictionary *)data;
- (void)send:(NSString *)event withData:(NSDictionary *)data andCallback:(JSCHandler)callback;
- (BOOL)isAttached;

@end
