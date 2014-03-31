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

@synthesize webView;

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    webView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.webView refreshContext];
}

@end
