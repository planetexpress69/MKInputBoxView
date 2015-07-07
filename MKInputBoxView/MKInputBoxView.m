//
//  MKInputBoxView.m
//  FileCloud
//
//  Created by Martin Kautz on 24.02.15.
//  Copyright (c) 2015 Martin Kautz. All rights reserved.
//

#import "MKInputBoxView.h"

@interface MKInputBoxView ()
// -----------------------------------------------------------------------------
@property (nonatomic, copy)     NSString            *title;
@property (nonatomic, copy)     NSString            *message;
@property (nonatomic, copy)     NSString            *submitButtonText;
@property (nonatomic, copy)     NSString            *cancelButtonText;
@property (nonatomic, assign)   MKInputBoxType      boxType;
@property (nonatomic, assign)   int                 numberOfDecimals;
@property (nonatomic, assign)   UIBlurEffectStyle   blurEffectStyle;
@property (nonatomic, strong)   NSMutableArray      *elements;
@property (nonatomic, strong)   UIVisualEffectView  *visualEffectView;
@property (nonatomic, strong)   UITextField         *textInput;
@property (nonatomic, strong)   UITextField         *secureInput;
@property (nonatomic, strong)   UIView              *actualBox;
// -----------------------------------------------------------------------------
@end


@implementation MKInputBoxView
// -----------------------------------------------------------------------------
#pragma mark - Init
// -----------------------------------------------------------------------------
+ (instancetype)boxOfType:(MKInputBoxType)boxType
{
    return [[self alloc]initWithBoxType:boxType];
}

// -----------------------------------------------------------------------------
- (instancetype)init
{
    return [self initWithBoxType:PlainTextInput];
}

// -----------------------------------------------------------------------------
- (instancetype)initWithBoxType:(MKInputBoxType)boxType
{
    CGFloat actualBoxHeight = 155.0f;
    UIWindow *window        = [UIApplication sharedApplication].windows[0];
    CGRect allFrame         = window.frame;

    CGRect boxFrame         = CGRectMake(0,
                                         0,
                                         MIN(325, window.frame.size.width - 50),
                                         actualBoxHeight);

    if ((self = [super initWithFrame:allFrame])) {
        self.boxType            = boxType;
        self.backgroundColor    = [UIColor colorWithWhite:1.0 alpha:0.0];
        self.autoresizingMask   = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleHeight;
        self.actualBox          = [[UIView alloc] initWithFrame:boxFrame];
        self.actualBox.center   = CGPointMake(window.center.x, window.center.y);
        self.center             = CGPointMake(window.center.x, window.center.y);
        [self addSubview:self.actualBox];
    }
    return self;
}




// -----------------------------------------------------------------------------
#pragma mark - Setters
// -----------------------------------------------------------------------------
- (void)setBlurEffectStyle:(UIBlurEffectStyle)blurEffectStyle
{
    _blurEffectStyle = blurEffectStyle;
}

// -----------------------------------------------------------------------------
- (void)setTitle:(NSString *)title
{
    _title = title;
}

// -----------------------------------------------------------------------------
- (void)setMessage:(NSString *)message
{
    _message = message;
}

// -----------------------------------------------------------------------------
- (void)setNumberOfDecimals:(int)numberOfDecimals
{
    _numberOfDecimals = numberOfDecimals;
}

// -----------------------------------------------------------------------------
- (void)setSubmitButtonText:(NSString *)submitButtonText
{
    _submitButtonText = submitButtonText;
}

// -----------------------------------------------------------------------------
- (void)setCancelButtonText:(NSString *)cancelButtonText
{
    _cancelButtonText = cancelButtonText;
}




// -----------------------------------------------------------------------------
#pragma mark - Show & hide
// -----------------------------------------------------------------------------
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

    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];

    // Register for device orientation changes
    [center addObserver:self
               selector:@selector(deviceOrientationDidChange)
                   name:@"UIDeviceOrientationDidChangeNotification"
                 object:nil];

    // Register for keyboard events
    [center addObserver:self
               selector:@selector(keyboardDidShow:)
                   name:@"UIKeyboardDidShowNotification" object:nil];

    [center addObserver:self
               selector:@selector(keyboardDidHide:)
                   name:@"UIKeyboardDidHideNotification" object:nil];
}

// -----------------------------------------------------------------------------
- (void)hide
{
    [UIView animateWithDuration:0.3f animations:^{
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        // Stop firing device orientation notifications
        [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];

        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];


        // Remove from those notifications
        [center removeObserver:self
                          name:@"UIDeviceOrientationDidChangeNotification"
                        object:nil];

        // Remove from listening to keyboard notifications
        [center removeObserver:self
                          name:@"UIKeyboardDidShowNotification"
                        object:nil];
        [center removeObserver:self
                          name:@"UIKeyboardDidHideNotification"
                        object:nil];
    }];
}




// -----------------------------------------------------------------------------
#pragma mark - Sets up the box.
// -----------------------------------------------------------------------------
- (void)setupView
{
    self.elements                       = [NSMutableArray new];

    self.actualBox.layer.cornerRadius   = 4.0;
    self.actualBox.layer.masksToBounds  = true;

    UIColor *titleLabelTextColor        = nil;
    UIColor *messageLabelTextColor      = nil;
    UIColor *elementBackgroundColor     = nil;
    UIColor *buttonBackgroundColor      = nil;

    UIBlurEffectStyle style = UIBlurEffectStyleLight;
    if (self.blurEffectStyle) {
        style = self.blurEffectStyle;
    }

    switch (style) {
        case UIBlurEffectStyleDark:
            titleLabelTextColor     = [UIColor whiteColor];
            messageLabelTextColor   = [UIColor whiteColor];
            elementBackgroundColor  = [UIColor colorWithWhite:1.0f alpha: 0.07f];
            buttonBackgroundColor   = [UIColor colorWithWhite:1.0f alpha: 0.07f];
            break;
        default:
            titleLabelTextColor     = [UIColor blackColor];
            messageLabelTextColor   = [UIColor blackColor];
            elementBackgroundColor  = [UIColor colorWithWhite:1.0f alpha: 0.50f];
            buttonBackgroundColor   = [UIColor colorWithWhite:1.0f alpha: 0.2f];
            break;
    }

    UIVisualEffect *effect  = [UIBlurEffect effectWithStyle:style];
    self.visualEffectView   = [[UIVisualEffectView alloc]initWithEffect:effect];

    CGFloat padding         = 10.0f;
    CGFloat width           = self.actualBox.frame.size.width - padding * 2;

    UILabel *titleLabel     = [[UILabel alloc] initWithFrame:
                               CGRectMake(padding, padding, width, 20)];
    titleLabel.font         = [UIFont boldSystemFontOfSize:17.0f];
    titleLabel.text         = self.title;
    titleLabel.textAlignment= NSTextAlignmentCenter;
    titleLabel.textColor    = titleLabelTextColor;
    [self.visualEffectView.contentView addSubview:titleLabel];

    UILabel *messageLabel   = [[UILabel alloc]initWithFrame:
                               CGRectMake(padding, padding + titleLabel.frame.size.height + 5, width, 31.5)];
    messageLabel.numberOfLines  = 2;
    messageLabel.font       = [UIFont systemFontOfSize:13.0f];
    messageLabel.text       = self.message;
    messageLabel.textAlignment  = NSTextAlignmentCenter;
    messageLabel.textColor  = messageLabelTextColor;
    [messageLabel sizeToFit];
    [self.visualEffectView.contentView addSubview:messageLabel];

    switch (self.boxType) {

        case PlainTextInput:
            self.textInput = [[UITextField alloc]initWithFrame:
                              CGRectMake(padding, messageLabel.frame.origin.y + messageLabel.frame.size.height + padding / 1.5, width, 30)];
            self.textInput.textAlignment = NSTextAlignmentCenter;
            if (self.customise) {
                self.textInput = self.customise(self.textInput);
            }
            [self.elements addObject:self.textInput];
            self.textInput.autocorrectionType = UITextAutocorrectionTypeNo;
            break;


        case NumberInput:
            self.textInput = [[UITextField alloc] initWithFrame:
                              CGRectMake(padding, messageLabel.frame.origin.y + messageLabel.frame.size.height + padding / 1.5, width, 30)];
            self.textInput.textAlignment = NSTextAlignmentCenter;
            if (self.customise) {
                self.textInput = self.customise(self.textInput);
            }
            [self.elements addObject:self.textInput];
            self.textInput.keyboardType = UIKeyboardTypeNumberPad;
            [self.textInput addTarget:self action:@selector(textInputDidChange) forControlEvents:UIControlEventEditingChanged];
            break;


        case EmailInput:
            self.textInput = [[UITextField alloc] initWithFrame:
                              CGRectMake(padding, messageLabel.frame.origin.y + messageLabel.frame.size.height + padding / 1.5, width, 30)];
            self.textInput.textAlignment = NSTextAlignmentCenter;
            if (self.customise) {
                self.textInput = self.textInput = self.customise(self.textInput);
            }
            [self.elements addObject:self.textInput];
            self.textInput.keyboardType = UIKeyboardTypeEmailAddress;
            self.textInput.autocorrectionType = UITextAutocorrectionTypeNo;
            break;


        case SecureTextInput:
            self.textInput = [[UITextField alloc] initWithFrame:
                              CGRectMake(padding, messageLabel.frame.origin.y + messageLabel.frame.size.height + padding / 1.5, width, 30)];
            self.textInput.textAlignment = NSTextAlignmentCenter;
            if (self.customise) {
                self.textInput = self.customise(self.textInput);
            }
            [self.elements addObject:self.textInput];
            break;


        case PhoneNumberInput:
            self.textInput = [[UITextField alloc] initWithFrame:
                              CGRectMake(padding, messageLabel.frame.origin.y + messageLabel.frame.size.height + padding / 1.5, width, 30)];
            self.textInput.textAlignment = NSTextAlignmentCenter;
            if (self.customise) {
                self.textInput = self.customise(self.textInput);
            }
            [self.elements addObject:self.textInput];
            self.textInput.keyboardType = UIKeyboardTypePhonePad;
            break;


        case LoginAndPasswordInput:

            self.textInput = [[UITextField alloc] initWithFrame:
                              CGRectMake(padding, messageLabel.frame.origin.y + messageLabel.frame.size.height + padding, width, 30)];
            self.textInput.textAlignment = NSTextAlignmentCenter;

            if (self.customise) {
                self.textInput = self.customise(self.textInput);
            }
            self.textInput.autocorrectionType = UITextAutocorrectionTypeNo;
            [self.elements addObject:self.textInput];

            self.secureInput = [[UITextField alloc] initWithFrame:
                                CGRectMake(padding, self.textInput.frame.origin.y + self.textInput.frame.size.height + padding, width, 30)];
            self.secureInput.textAlignment = NSTextAlignmentCenter;
            self.secureInput.secureTextEntry = YES;

            if (self.customise) {
                self.secureInput = self.customise(self.secureInput);
            }

            [self.elements addObject:self.secureInput];

            // adjust height!
            CGRect extendedFrame = self.actualBox.frame;
            extendedFrame.size.height += 45;
            self.actualBox.frame = extendedFrame;
            break;

        default:
            NSAssert(NO, @"Boom! You should set a proper MKInputStyle! Bailing out...");
            break;
    }

    for (UITextField *element in self.elements) {
        element.layer.borderColor   = [UIColor colorWithWhite:0.0f alpha:0.1f].CGColor;
        element.layer.borderWidth   = 0.5;
        element.backgroundColor     = elementBackgroundColor;
        [self.visualEffectView.contentView addSubview:element];
    }

    CGFloat buttonHeight    = 40.0f;
    CGFloat buttonWidth     = self.actualBox.frame.size.width / 2;

    UIButton *cancelButton  = [[UIButton alloc] initWithFrame:CGRectMake(0, self.actualBox.frame.size.height - buttonHeight, buttonWidth, buttonHeight)];
    [cancelButton setTitle:self.cancelButtonText != nil ? self.cancelButtonText : @"Cancel" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [cancelButton setTitleColor:titleLabelTextColor forState: UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor grayColor] forState: UIControlStateHighlighted];
    cancelButton.backgroundColor = buttonBackgroundColor;
    cancelButton.layer.borderColor = [UIColor colorWithWhite: 0.0f alpha: 0.1f].CGColor;
    cancelButton.layer.borderWidth = 0.5;
    [self.visualEffectView.contentView addSubview:cancelButton];

    UIButton *submitButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonWidth, self.actualBox.frame.size.height - buttonHeight, buttonWidth, buttonHeight)];
    [submitButton setTitle:self.submitButtonText != nil ? self.submitButtonText : @"OK" forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(submitButtonTapped) forControlEvents: UIControlEventTouchUpInside];
    submitButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [submitButton setTitleColor:self.blurEffectStyle == UIBlurEffectStyleDark ? [UIColor whiteColor] : [UIColor blackColor] forState: UIControlStateNormal];
    [submitButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    submitButton.backgroundColor = buttonBackgroundColor;
    submitButton.layer.borderColor = [UIColor colorWithWhite:0.0f alpha: 0.1f].CGColor;
    submitButton.layer.borderWidth = 0.5;
    [self.visualEffectView.contentView addSubview:submitButton];

    self.visualEffectView.frame = CGRectMake(0, 0, self.actualBox.frame.size.width, self.actualBox.frame.size.height + 45);
    [self.actualBox addSubview:self.visualEffectView];
    self.actualBox.center = self.center;
}



// -----------------------------------------------------------------------------
#pragma mark - Handle device rotation
// -----------------------------------------------------------------------------
- (void)deviceOrientationDidChange
{
    [self resetFrame:YES];
}




// -----------------------------------------------------------------------------
#pragma mark - Button handlers
// -----------------------------------------------------------------------------
- (void)cancelButtonTapped
{
    if (self.onCancel != nil) {
        self.onCancel();
    }
    [self hide];
}

// -----------------------------------------------------------------------------
- (void)submitButtonTapped {
    if (self.onSubmit != nil) {
        NSString *textValue = self.textInput.text;
        NSString *passValue = self.secureInput.text;
        if (self.onSubmit(textValue, passValue)){
            [self hide];
        }
    } else {
        [self hide];
    }
}




// -----------------------------------------------------------------------------
#pragma mark - Beautify numbers...
// -----------------------------------------------------------------------------
- (void)textInputDidChange
{
    NSString *sText = self.textInput.text;
    sText = [sText stringByReplacingOccurrencesOfString:@"." withString:@""];
    double power = pow(10.0f, (double)self.numberOfDecimals);
    double number = sText.doubleValue / power;
    NSString *sPattern = [NSString stringWithFormat:@"%%.%df", self.numberOfDecimals];
    self.textInput.text = [NSString stringWithFormat:sPattern, number];
}




// -----------------------------------------------------------------------------
#pragma mark - Keyboard appearance/disappearance handlers & helpers
// -----------------------------------------------------------------------------
- (void)keyboardDidShow:(NSNotification *)notification
{
    [self resetFrame:YES];

    [UIView animateWithDuration:0.2f animations:^{
        CGRect frame = self.actualBox.frame;
        frame.origin.y -= [self yCorrection];
        self.actualBox.frame = frame;
    }];
}

// -----------------------------------------------------------------------------
- (void)keyboardDidHide:(NSNotification *)notification {
    [self resetFrame:YES];
}




// -----------------------------------------------------------------------------
// Helper to calculate how much we need to lift the input box
// -----------------------------------------------------------------------------
- (CGFloat)yCorrection
{
    CGFloat yCorrection = 115.0f;

    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
            yCorrection = 80.0f;
        }
        else if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            yCorrection = 100.0f;
        }

        if (self.boxType == LoginAndPasswordInput) {
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




// -----------------------------------------------------------------------------
// Helper to calculate where to put the input view after hiding the keyboard.
// -----------------------------------------------------------------------------
- (void)resetFrame:(BOOL)animated
{
    UIWindow *window = [UIApplication sharedApplication].windows[0];
    self.frame = window.frame;

    if (animated) {
        [UIView animateWithDuration:0.3f animations:^{
            self.center = CGPointMake(window.center.x, window.center.y);
            self.actualBox.center = self.center;
        }];
    }
    else {
        self.center = CGPointMake(window.center.x, window.center.y);
        self.actualBox.center = self.center;
    }
}



@end
