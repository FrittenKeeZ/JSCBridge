//
//  JSCWebView.h
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
