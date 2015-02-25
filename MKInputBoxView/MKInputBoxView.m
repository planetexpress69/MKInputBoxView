//
//  MKInputBoxView.m
//  FileCloud
//
//  Created by Martin Kautz on 24.02.15.
//  Copyright (c) 2015 Martin Kautz. All rights reserved.
//

#import "MKInputBoxView.h"

@interface MKInputBoxView ()
// -------------------------------------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, copy)     NSString            *title;
@property (nonatomic, copy)     NSString            *message;
@property (nonatomic, copy)     NSString            *submitButtonText;
@property (nonatomic, copy)     NSString            *cancelButtonText;
@property (nonatomic, assign)   MKInputBoxStyle     style;
@property (nonatomic, assign)   int                 numberOfDecimals;
@property (nonatomic, strong)   NSMutableArray      *elements;
@property (nonatomic, assign)   UIBlurEffectStyle   blurEffectStyle;
@property (nonatomic, strong)   UIVisualEffectView  *visualEffectView;
@property (nonatomic, strong)   UITextField         *textInput;
@property (nonatomic, strong)   UITextField         *secureInput;
// -------------------------------------------------------------------------------------------------------------------------------------------------------------
@end


@implementation MKInputBoxView
// -------------------------------------------------------------------------------------------------------------------------------------------------------------
#pragma mark - Init & lifecycle
// -------------------------------------------------------------------------------------------------------------------------------------------------------------
+ (MKInputBoxView *)boxWithStyle:(MKInputBoxStyle)style
{
    UIWindow *window = [UIApplication sharedApplication].windows[0];
    CGRect boxFrame = CGRectMake(0,0, MIN(325, window.frame.size.width - 50), 210);
    MKInputBoxView *inputBox = [[MKInputBoxView alloc]initWithFrame:boxFrame];
    inputBox.center = CGPointMake(window.center.x, window.center.y - 30);
    inputBox.style = style;
    return inputBox;
}


// -------------------------------------------------------------------------------------------------------------------------------------------------------------
#pragma mark - Setters for box' properties.
// -------------------------------------------------------------------------------------------------------------------------------------------------------------
- (void)setBlurEffectStyle:(UIBlurEffectStyle)blurEffectStyle
{
    _blurEffectStyle = blurEffectStyle;
}

// -------------------------------------------------------------------------------------------------------------------------------------------------------------
- (void)setTitle:(NSString *)title
{
    _title = title;
}

// -------------------------------------------------------------------------------------------------------------------------------------------------------------
- (void)setMessage:(NSString *)message
{
    _message = message;
}

// -------------------------------------------------------------------------------------------------------------------------------------------------------------
- (void)setNumberOfDecimals:(int)numberOfDecimals
{
    _numberOfDecimals = numberOfDecimals;
}




// -------------------------------------------------------------------------------------------------------------------------------------------------------------
#pragma mark - Show & hide
// -------------------------------------------------------------------------------------------------------------------------------------------------------------
-(void)show
{
    self.alpha = 0.0f;
    [self setupView];

    [UIView animateWithDuration:0.3f animations:^{
        self.alpha = 1.0f;
    }];


    UIWindow *window = [UIApplication sharedApplication].windows[0];
    [window addSubview:self];
    [window bringSubviewToFront:self];

    // Start firing orientation notifications
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];

    // Register for device orientation changes
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceOrientationDidChange)
                                                 name:@"UIDeviceOrientationDidChangeNotification"
                                               object:nil];

    // Register for keyboard events
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:@"UIKeyboardDidShowNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:@"UIKeyboardDidHideNotification" object:nil];
}

// -------------------------------------------------------------------------------------------------------------------------------------------------------------
- (void)hide
{
    [UIView animateWithDuration:0.3f animations:^{
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        // Stop firing device orientation notifications
        [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];

        // Remove from those notifications
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIDeviceOrientationDidChangeNotification" object:nil];

        // Remove from listening to keyboard notifications
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIKeyboardDidShowNotification" object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIKeyboardDidHideNotification" object:nil];
    }];
}




// -------------------------------------------------------------------------------------------------------------------------------------------------------------
#pragma mark - Sets up the box.
// -------------------------------------------------------------------------------------------------------------------------------------------------------------
- (void)setupView
{
    self.elements = [NSMutableArray new];

    self.layer.cornerRadius     = 4.0;
    self.layer.masksToBounds    = true;

    UIVisualEffect *effect      = [UIBlurEffect effectWithStyle:self.blurEffectStyle ? self.blurEffectStyle : UIBlurEffectStyleLight];
    self.visualEffectView       = [[UIVisualEffectView alloc]initWithEffect:effect];

    CGFloat padding             = 20.0f;
    CGFloat width               = self.frame.size.width - padding * 2;

    UILabel *titleLabel         = [[UILabel alloc]initWithFrame:CGRectMake(padding, padding, width, 20)];
    titleLabel.font             = [UIFont boldSystemFontOfSize:18.0f];
    titleLabel.text             = self.title;
    titleLabel.textAlignment    = NSTextAlignmentCenter;
    titleLabel.textColor        = self.blurEffectStyle == UIBlurEffectStyleDark ? [UIColor whiteColor] : [UIColor blackColor];
    [self.visualEffectView.contentView addSubview:titleLabel];

    UILabel *messageLabel       = [[UILabel alloc]initWithFrame:CGRectMake(padding, padding + titleLabel.frame.size.height + 10, width, 20)];
    messageLabel.numberOfLines  = 4;
    messageLabel.font           = [UIFont systemFontOfSize:14.0f];
    messageLabel.text           = self.message;
    messageLabel.textAlignment  = NSTextAlignmentCenter;
    messageLabel.textColor      = self.blurEffectStyle == UIBlurEffectStyleDark ? [UIColor whiteColor] : [UIColor blackColor];
    [messageLabel sizeToFit];
    [self.visualEffectView.contentView addSubview:messageLabel];

    switch (self.style) {

        case PlainTextInput:
            self.textInput = [[UITextField alloc]initWithFrame:
                              CGRectMake(padding, messageLabel.frame.origin.y + messageLabel.frame.size.height + padding / 1.5, width, 35)];
            self.textInput.textAlignment = NSTextAlignmentCenter;
            if (self.customiseInputElement) {
                self.textInput = self.customiseInputElement(self.textInput);
            }
            [self.elements addObject:self.textInput];
            break;


        case NumberInput:
            self.textInput = [[UITextField alloc] initWithFrame:
                              CGRectMake(padding, messageLabel.frame.origin.y + messageLabel.frame.size.height + padding / 1.5, width, 35)];
            self.textInput.textAlignment = NSTextAlignmentCenter;
            if (self.customiseInputElement) {
                self.textInput = self.customiseInputElement(self.textInput);
            }
            [self.elements addObject:self.textInput];
            self.textInput.keyboardType = UIKeyboardTypeNumberPad;
            [self.textInput addTarget:self action:@selector(textInputDidChange) forControlEvents:UIControlEventEditingChanged];
            break;


        case EmailInput:
            self.textInput = [[UITextField alloc] initWithFrame:
                              CGRectMake(padding, messageLabel.frame.origin.y + messageLabel.frame.size.height + padding / 1.5, width, 35)];
            self.textInput.textAlignment = NSTextAlignmentCenter;
            if (self.customiseInputElement) {
                self.textInput = self.textInput = self.customiseInputElement(self.textInput);
            }
            [self.elements addObject:self.textInput];
            self.textInput.keyboardType = UIKeyboardTypeEmailAddress;
            break;


        case SecureTextInput:
            self.textInput = [[UITextField alloc] initWithFrame:
                              CGRectMake(padding, messageLabel.frame.origin.y + messageLabel.frame.size.height + padding / 1.5, width, 35)];
            self.textInput.textAlignment = NSTextAlignmentCenter;
            if (self.customiseInputElement) {
                self.textInput = self.customiseInputElement(self.textInput);
            }
            [self.elements addObject:self.textInput];
            break;


        case PhoneNumberInput:
            self.textInput = [[UITextField alloc] initWithFrame:
                              CGRectMake(padding, messageLabel.frame.origin.y + messageLabel.frame.size.height + padding / 1.5, width, 35)];
            self.textInput.textAlignment = NSTextAlignmentCenter;
            if (self.customiseInputElement) {
                self.textInput = self.customiseInputElement(self.textInput);
            }
            [self.elements addObject:self.textInput];
            self.textInput.keyboardType = UIKeyboardTypePhonePad;
            break;


        case LoginAndPasswordInput:

            self.textInput = [[UITextField alloc] initWithFrame:
                              CGRectMake(padding, messageLabel.frame.origin.y + messageLabel.frame.size.height + padding / 1.5, width, 35)];
            self.textInput.textAlignment = NSTextAlignmentCenter;

            if (self.customiseInputElement) {
                self.textInput = self.customiseInputElement(self.textInput);
            }

            [self.elements addObject:self.textInput];

            self.secureInput = [[UITextField alloc] initWithFrame:
                                CGRectMake(padding, self.textInput.frame.origin.y + self.textInput.frame.size.height + padding / 2, width, 35)];
            self.secureInput.textAlignment = NSTextAlignmentCenter;
            self.secureInput.secureTextEntry = YES;

            if (self.customiseInputElement) {
                self.secureInput = self.customiseInputElement(self.secureInput);
            }

            [self.elements addObject:self.secureInput];

            CGRect extendedFrame = self.frame;
            extendedFrame.size.height += 45;
            self.frame = extendedFrame;
            break;

        default:
            NSAssert(NO, @"Boom! You should set a proper MKInputStyle! Bailing out...");
            break;
    }

    for (UITextField *element in self.elements) {
        element.layer.borderColor   = [UIColor colorWithWhite:0.0f alpha:0.1f].CGColor;
        element.layer.borderWidth   = 0.5;
        element.backgroundColor     = self.blurEffectStyle == UIBlurEffectStyleDark ? [UIColor colorWithWhite:1.0f alpha: 0.07f] :
        [UIColor colorWithWhite:1.0f alpha: 0.5f];
        [self.visualEffectView.contentView addSubview:element];
    }

    CGFloat buttonHeight    = 45.0f;
    CGFloat buttonWidth     = self.frame.size.width / 2;

    UIButton *cancelButton  = [[UIButton alloc] initWithFrame:CGRectMake(0, self.frame.size.height - buttonHeight, buttonWidth, buttonHeight)];
    [cancelButton setTitle:self.cancelButtonText != nil ? self.cancelButtonText : @"Cancel" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [cancelButton setTitleColor:self.blurEffectStyle == UIBlurEffectStyleDark ? [UIColor whiteColor] : [UIColor blackColor] forState: UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor grayColor] forState: UIControlStateHighlighted];
    cancelButton.backgroundColor = self.blurEffectStyle == UIBlurEffectStyleDark ? [UIColor colorWithWhite:1.0f alpha: 0.07f] :
    [UIColor colorWithWhite:1.0f alpha: 0.2f];
    cancelButton.layer.borderColor = [UIColor colorWithWhite: 0.0f alpha: 0.1f].CGColor;
    cancelButton.layer.borderWidth = 0.5;
    [self.visualEffectView.contentView addSubview:cancelButton];

    UIButton *submitButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonWidth, self.frame.size.height - buttonHeight, buttonWidth, buttonHeight)];
    [submitButton setTitle:self.submitButtonText != nil ? self.submitButtonText : @"OK" forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(submitButtonTapped) forControlEvents: UIControlEventTouchUpInside];
    submitButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [submitButton setTitleColor:self.blurEffectStyle == UIBlurEffectStyleDark ? [UIColor whiteColor] : [UIColor blackColor] forState: UIControlStateNormal];
    [submitButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    submitButton.backgroundColor = self.blurEffectStyle == UIBlurEffectStyleDark ? [UIColor colorWithWhite:1.0f alpha: 0.07f] :
    [UIColor colorWithWhite:1.0f alpha: 0.2f];
    submitButton.layer.borderColor = [UIColor colorWithWhite:0.0f alpha: 0.1f].CGColor;
    submitButton.layer.borderWidth = 0.5;
    [self.visualEffectView.contentView addSubview:submitButton];

    self.visualEffectView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self addSubview:self.visualEffectView];
}




// -------------------------------------------------------------------------------------------------------------------------------------------------------------
#pragma mark - Handle device rotation
// -------------------------------------------------------------------------------------------------------------------------------------------------------------
- (void)deviceOrientationDidChange
{
    [self resetFrame:YES];
}




// -------------------------------------------------------------------------------------------------------------------------------------------------------------
#pragma mark - Button handlers
// -------------------------------------------------------------------------------------------------------------------------------------------------------------
- (void)cancelButtonTapped
{
    if (self.onCancel != nil) {
        self.onCancel();
    }
    [self hide];
}

// -------------------------------------------------------------------------------------------------------------------------------------------------------------
- (void)submitButtonTapped {
    if (self.onSubmit != nil) {
        NSString *textValue = self.textInput.text;
        NSString *passValue = self.secureInput.text;
        self.onSubmit(textValue, passValue);        
    }
    [self hide];
}




// -------------------------------------------------------------------------------------------------------------------------------------------------------------
#pragma mark - Beautify numbers...
// -------------------------------------------------------------------------------------------------------------------------------------------------------------
- (void)textInputDidChange
{
    NSString *sText = self.textInput.text;
    sText = [sText stringByReplacingOccurrencesOfString:@"." withString:@""];
    double power = pow(10.0f, (double)self.numberOfDecimals);
    double number = sText.doubleValue / power;
    NSString *sPattern = [NSString stringWithFormat:@"%%.%df", self.numberOfDecimals];
    self.textInput.text = [NSString stringWithFormat:sPattern, number];
}




// -------------------------------------------------------------------------------------------------------------------------------------------------------------
#pragma mark - Keyboard appearance/disappearance handlers & helpers
// -------------------------------------------------------------------------------------------------------------------------------------------------------------
- (void)keyboardDidShow:(NSNotification *)notification
{
    [self resetFrame:YES];

    [UIView animateWithDuration:0.2f animations:^{
        CGRect frame = self.frame;
        frame.origin.y -= [self yCorrection];
        self.frame = frame;
    }];
}

// -------------------------------------------------------------------------------------------------------------------------------------------------------------
- (void)keyboardDidHide:(NSNotification *)notification {
    [self resetFrame:YES];
}




// -------------------------------------------------------------------------------------------------------------------------------------------------------------
// Helper to calculate how much we need to lift the input box not to get covered by the keyboard
// -------------------------------------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)yCorrection
{
    CGFloat yCorrection = 30.0f;

    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
            yCorrection = 60.0f;
        }
        else if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            yCorrection = 100.0f;
        }

        if (self.style == LoginAndPasswordInput) {
            yCorrection += 45.0f;
        }
    }
    else {
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            yCorrection = 0.0f;
        }
    }
    return yCorrection;
}




// -------------------------------------------------------------------------------------------------------------------------------------------------------------
// Helper to calculate where to put back the input view after hiding the keyboard.
// -------------------------------------------------------------------------------------------------------------------------------------------------------------
- (void)resetFrame:(BOOL)animated
{
    CGFloat topMargin = (self.style == LoginAndPasswordInput) ? 0.0f : 45.0f;
    UIWindow *window = [UIApplication sharedApplication].windows[0];

    if (animated) {
        [UIView animateWithDuration:0.3f animations:^{
            self.center = CGPointMake(window.center.x, window.center.y - topMargin);
        }];
    }
    else {
        self.center = CGPointMake(window.center.x, window.center.y - topMargin);
    }
}

@end
