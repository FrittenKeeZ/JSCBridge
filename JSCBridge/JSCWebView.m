//
//  JSCWebView.m
//  JSCBridge
//
//  Created by Reg Dwarf on 31/03/14.
//  Copyright (c) 2014 Dwarf. All rights reserved.
//

#import "JSCWebView.h"

@implementation JSCWebView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark - Bridge public methods

- (void)refreshContext {
    JSContext *jsContext = [self valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    if (_jsContext != jsContext) {
        _jsContext = jsContext;
        if (_jsContext != nil) {
            NSLog(@"JSContext loaded for: %@", [self request]);
            _jsContext[@"console"][@"log"] = ^(JSValue *msg, JSValue *obj) {
                if ([obj isUndefined]) {
                    NSLog(@"JSLog: %@", msg);
                } else {
                    NSLog(@"JSLog: %@ %@", msg, obj);
                }
            };
        }
    }
}

- (void)on:(NSString *)event perform:(JSCHandler)handler {
    
}

- (void)on:(NSString *)event performWithCallback:(JSCCallbackHandler)handler {
    
}

- (void)off:(NSString *)event {
    
}

- (void)send:(NSString *)event {
    [self send:event withData:nil andCallback:nil];
}

- (void)send:(NSString *)event withData:(NSDictionary *)data {
    [self send:event withData:data andCallback:nil];
}

- (void)send:(NSString *)event withData:(NSDictionary *)data andCallback:(JSCHandler)callback {
    
}

@end
