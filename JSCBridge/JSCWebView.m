//
//  JSCWebView.m
//  JSCBridge
//
//  Copyright (C) 2014, Frederik Buus Sauer
//
//  Permission is hereby granted, free of charge, to any person obtaining
//  a copy of this software and associated documentation files (the
//  "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish,
//  distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to
//  the following conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
//  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
//  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "JSCWebView.h"

/*!
 @methodgroup Converting to Objective-C Types
 @discussion When converting between JavaScript values and Objective-C objects a copy is
 performed. Values of types listed below are copied to the corresponding
 types on conversion in each direction. For NSDictionaries, entries in the
 dictionary that are keyed by strings are copied onto a JavaScript object.
 For dictionaries and arrays, conversion is recursive, with the same object
 conversion being applied to all entries in the collection.
 
 <pre>
 @textblock
   Objective-C type  |   JavaScript type
 --------------------+---------------------
         nil         |     undefined
        NSNull       |        null
       NSString      |       string
       NSNumber      |   number, boolean
     NSDictionary    |   Object object
       NSArray       |    Array object
        NSDate       |     Date object
       NSBlock (1)   |   Function object (1)
          id (2)     |   Wrapper object (2)
        Class (3)    | Constructor object (3)
 @/textblock
 </pre>
 
 (1) Instances of NSBlock with supported arguments types will be presented to
 JavaScript as a callable Function object. For more information on supported
 argument types see JSExport.h. If a JavaScript Function originating from an
 Objective-C block is converted back to an Objective-C object the block will
 be returned. All other JavaScript functions will be converted in the same
 manner as a JavaScript object of type Object.
 
 (2) For Objective-C instances that do not derive from the set of types listed
 above, a wrapper object to provide a retaining handle to the Objective-C
 instance from JavaScript. For more information on these wrapper objects, see
 JSExport.h. When a JavaScript wrapper object is converted back to Objective-C
 the Objective-C instance being retained by the wrapper is returned.
 
 (3) For Objective-C Class objects a constructor object containing exported
 class methods will be returned. See JSExport.h for more information on
 constructor objects.
 
 For all methods taking arguments of type id, arguments will be converted
 into a JavaScript value according to the above conversion.
 */

@implementation JSCWebView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _messageCount = @0;
        _listeners = [[NSMutableDictionary alloc] init];
        _callbacks = [[NSMutableDictionary alloc] init];
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
        }
        [self setupLog];
        [self setupBridge];
    }
}

- (void)setupLog {
    if (_jsContext != nil) {
        _jsContext[@"console"][@"log"] = ^(JSValue *msg, JSValue *obj) {
            if ([obj isUndefined]) {
                NSLog(@"JSLog: %@", msg);
            } else {
                NSLog(@"JSLog: %@ %@", msg, obj);
            }
        };
        NSLog(@"JS console.log attached");
    }
}

- (void)setupBridge {
    _triggerJS = nil;
    if (_jsContext != nil) {
        // Check if JSCBridge exists
        if (![_jsContext[@"JSCBridge"] isUndefined]) {
            NSLog(@"JSCBridge found");
            // Grab JS trigger - it's a function object
            JSValue *triggerJS = _jsContext[@"JSCBridge"][@"triggerJS"];
            if ([triggerJS isObject]) {
                _triggerJS = triggerJS;
                NSLog(@"JSCBridge.triggerJS grabbed");
            }
            // Attach OS trigger to JS
            JSCTrigger triggerOS = ^(NSString *event, NSString *type, NSDictionary *data) {
                [self recv:event ofType:type withPayload:data];
            };
            _jsContext[@"JSCBridge"][@"triggerOS"] = triggerOS;
            NSLog(@"JSCBridge.triggerOS attached");
            [self send:@"attached"];
        }
    }
}

- (void)on:(NSString *)event perform:(JSCHandler)handler {
    JSCCallbackHandler callbackHandler = ^(NSDictionary *data, JSCHandler callback) {
        handler(data);
        callback(nil);
    };
    [self on:event performWithCallback:callbackHandler];
}

- (void)on:(NSString *)event performWithCallback:(JSCCallbackHandler)handler {
    [_listeners setObject:handler forKey:event];
}

- (void)off {
    [_listeners removeAllObjects];
}

- (void)off:(NSString *)event {
    [_listeners removeObjectForKey:event];
}

- (void)send:(NSString *)event {
    [self send:event withData:nil andCallback:nil];
}

- (void)send:(NSString *)event withData:(NSDictionary *)data {
    [self send:event withData:data andCallback:nil];
}

- (void)send:(NSString *)event withData:(NSDictionary *)data andCallback:(JSCHandler)callback {
    if (_triggerJS != nil) {
        NSString *msgId = [event stringByAppendingString:[_messageCount stringValue]];
        if (callback != nil) {
            [_callbacks setObject:callback forKey:msgId];
        }
        if (data == nil) {
            data = @{};
        }
        
        NSDictionary *package = @{@"id": msgId, @"data": data, @"has_callback": @(callback != nil)};
        [_triggerJS callWithArguments:@[event, @"message", package]];
        
        _messageCount = @([_messageCount integerValue] + 1);
    } else {
        NSLog(@"JSCBridge.triggerJS not attached!");
    }
}

- (BOOL)isAttached {
    return _triggerJS != nil;
}

- (void)recv:(NSString *)event ofType:(NSString *)type withPayload:(NSDictionary *)payload {
    if ([type isEqualToString:@"message"]) {
        [self recvMessage:event withPayload:payload];
    } else if ([type isEqualToString:@"callback"]) {
        [self recvCallback:event withPayload:payload];
    } else {
        NSLog(@"JS Unknown trigger type received");
    }
}

- (void)recvMessage:(NSString *)event withPayload:(NSDictionary *)payload {
    JSCCallbackHandler handler = [_listeners objectForKey:event];
    if (handler != nil) {
        handler([payload objectForKey:@"data"], ^(NSDictionary *data) {
            if ([[payload objectForKey:@"has_callback"] boolValue]) {
                if (data == nil) {
                    data = @{};
                }
                NSDictionary *package = @{@"id": [payload objectForKey:@"id"], @"data": data};
                [_triggerJS callWithArguments:@[event, @"callback", package]];
            }
        });
    } else {
        NSLog(@"JS missing event handler: %@", event);
    }
}

- (void)recvCallback:(NSString *)event withPayload:(NSDictionary *)payload {
    JSCHandler handler = [_callbacks objectForKey:[payload objectForKey:@"id"]];
    if (handler != nil) {
        handler([payload objectForKey:@"data"]);
        [_callbacks removeObjectForKey:[payload objectForKey:@"id"]];
    } else {
        NSLog(@"JS missing event callback: %@", event);
    }
}

@end
