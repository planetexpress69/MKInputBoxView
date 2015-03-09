//
//  ViewController.m
//  MKInputBoxView
//
//  Created by Martin Kautz on 25.02.15.
//  Copyright (c) 2015 JAKOTA Design Group. All rights reserved.
//

#import "ViewController.h"
#import "MKInputBoxView.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)show:(id)sender
{
    MKInputBoxView *inputBoxView = [MKInputBoxView boxOfType:LoginAndPasswordInput];
    [inputBoxView setTitle:@"Who are you?"];
    [inputBoxView setMessage:@"Please enter your username and password to get access to the system."];
    [inputBoxView setBlurEffectStyle:UIBlurEffectStyleExtraLight];

    [inputBoxView setCancelButtonText:@"Not yet"];

    inputBoxView.customise = ^(UITextField *textField) {
        textField.placeholder = @"Your eMail address";
        if (textField.secureTextEntry) {
            textField.placeholder = @"Your password";
        }
        textField.textColor = [UIColor blackColor];
        textField.layer.cornerRadius = 4.0f;
        return textField;
    };

    inputBoxView.onSubmit = ^(NSString *value1, NSString *value2) {
        NSLog(@"user: %@", value1);
        NSLog(@"pass: %@", value2);
    };

    inputBoxView.onCancel = ^{
        NSLog(@"Cancel!");
    };

    [inputBoxView show];
}

@end
