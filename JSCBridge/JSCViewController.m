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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [_webView refreshContext];
}

@end
