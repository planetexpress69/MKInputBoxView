//
//  MKInputBoxView.h
//  FileCloud
//
//  Created by Martin Kautz on 24.02.15.
//  Copyright (c) 2015 Martin Kautz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MKInputBoxStyle) {
    PlainTextInput,
    NumberInput,
    PhoneNumberInput,
    EmailInput,
    SecureTextInput,
    LoginAndPasswordInput,
    DatePickerInput,
    PickerInput
};

@interface MKInputBoxView : UIView
// -------------------------------------------------------------------------------------------------------------------------------------------------------------
+ (MKInputBoxView *)boxWithStyle:(MKInputBoxStyle)style;
// -------------------------------------------------------------------------------------------------------------------------------------------------------------
- (void)setBlurEffectStyle:(UIBlurEffectStyle)blurEffectStyle;
- (void)setTitle:(NSString *)title;
- (void)setMessage:(NSString *)message;
- (void)setNumberOfDecimals:(int)numberOfDecimals;
// -------------------------------------------------------------------------------------------------------------------------------------------------------------
- (void)show;                                                                           
- (void)hide;
// -------------------------------------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, copy) void(^onSubmit)(NSString *, NSString *);                // block to handle submit
@property (nonatomic, copy) void(^onCancel)(void);                                  // block to handle cancel
@property (nonatomic, copy) UITextField *(^customiseInputElement)(UITextField *);   // block to modify the textfield conveniently
// -------------------------------------------------------------------------------------------------------------------------------------------------------------
- (void)submitButtonTapped; // just exposed for testing...
- (void)textInputDidChange; // just exposed for testing...
@end
