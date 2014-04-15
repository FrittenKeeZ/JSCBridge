//
//  JSCViewController.h
//  JSCBridge
//
//  Created by Reg Dwarf on 31/03/14.
//  Copyright (c) 2014 Dwarf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSCWebView.h"

@interface JSCViewController : UIViewController <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet JSCWebView *webView;
@property (weak, nonatomic) IBOutlet UILabel *lblLog;
@property (weak, nonatomic) IBOutlet UITextField *txtInput;

- (IBAction)sendOne:(UIButton *)sender;
- (IBAction)sendTwo:(UIButton *)sender;
- (IBAction)sendThree:(UIButton *)sender;
- (IBAction)sendFour:(UIButton *)sender;

@end
