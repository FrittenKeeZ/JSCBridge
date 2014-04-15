//
//  JSCViewController.m
//  JSCBridge
//
//  Created by Reg Dwarf on 31/03/14.
//  Copyright (c) 2014 Dwarf. All rights reserved.
//

#import "JSCViewController.h"

@interface JSCViewController ()

@end

@implementation JSCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _webView.delegate = self;
    
    NSURL* htmlURL = [[NSBundle mainBundle] URLForResource: @"testBridge"
                                             withExtension: @"html"];
    
    [_webView loadRequest: [NSURLRequest requestWithURL: htmlURL]];
    
    // Receive tests
    [_webView on:@"send1" perform:^(NSDictionary *data) {
        _lblLog.text = @"Send event received";
    }];
    
    [_webView on:@"send2" perform:^(NSDictionary *data) {
        _lblLog.text = [NSString stringWithFormat:@"jQuery version: %@", [data objectForKey:@"version"]];
    }];
    
    [_webView on:@"send3" performWithCallback:^(NSDictionary *data, JSCHandler callback) {
        callback(@{@"text": [[data objectForKey:@"text"] uppercaseString]});
    }];
    
    [_webView on:@"send4" performWithCallback:^(NSDictionary *data, JSCHandler callback) {
        callback(@{@"model": [UIDevice currentDevice].model});
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [_webView refreshContext];
    if ([_webView isAttached]) {
        _lblLog.text = @"JSCBridge attached!";
    }
}

- (IBAction)sendOne:(UIButton *)sender {
    [_webView send:@"send1"];
}

- (IBAction)sendTwo:(UIButton *)sender {
    NSDictionary *data = @{@"version": [UIDevice currentDevice].systemVersion};
    [_webView send:@"send2" withData:data];
}

- (IBAction)sendThree:(UIButton *)sender {
    NSDictionary *data = @{@"text": _txtInput.text};
    [_webView send:@"send3" withData:data andCallback:^(NSDictionary *data) {
        _lblLog.text = [NSString stringWithFormat:@"Scrambled: %@", [data objectForKey:@"text"]];
    }];
}

- (IBAction)sendFour:(UIButton *)sender {
    [_webView send:@"send4" withData:nil andCallback:^(NSDictionary *data) {
        _lblLog.text = [NSString stringWithFormat:@"UserAgent: %@", [data objectForKey:@"ua"]];
    }];
}

@end
