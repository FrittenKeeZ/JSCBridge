//
//  JSCWebView.m
//  JSCBridge
//
//  Created by Reg Dwarf on 31/03/14.
//  Copyright (c) 2014 Dwarf. All rights reserved.
//

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
            _jsContext[@"JSCBridge"][@"triggerOS"] = ^(NSString *event, NSString *type, NSString *msgId, NSDictionary *data) {
                
            };
            NSLog(@"JSCBridge.triggerOS attached");
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
