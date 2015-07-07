//
//  MKInputBoxView.h
//  FileCloud
//
//  Created by Martin Kautz on 24.02.15.
//  Copyright (c) 2015 Martin Kautz. All rights reserved.
//

#import <UIKit/UIKit.h>

/** These constants determine the style of the view.
 *
 */
typedef NS_ENUM(NSInteger, MKInputBoxType) {
    /** An input view that contains just one text field
     * to receive plain text.
     */
    PlainTextInput,

    /** An input view that contains just one text field
     * to receive numbers.
     */
    NumberInput,

    /** An input view that contains just one text field
     * to receive phone numbers.
     */
    PhoneNumberInput,

    /** An input view that contains just one text field
     * to receive an email address.
     */
    EmailInput,

    /** An input view that contains just one text field
     * to receive secure text.
     */
    SecureTextInput,

    /** An input view that contains two text field
     * to receive plain text for an username and secure text for a password.
     */
    LoginAndPasswordInput
};


/** The `MKInputBoxView` is a simple class to replace the UIAlertView with 
 * having input fields.
 * It is highly customizable and features one or two text fields to receive 
 * user input.
 * Instead of talking to a delegate, it's block-based.
 *
 * @warning It's not ready yet...
 */
@interface MKInputBoxView : UIView

/**-----------------------------------------------------------------------------
 * @name Create an instance of MKInputBoxView
 * -----------------------------------------------------------------------------
 */

/** Returns an `MKInputBoxView` instance.
 *
 * @return The shared `MRBrew` instance.
 */
+ (instancetype)boxOfType:(MKInputBoxType)boxType;

/**-----------------------------------------------------------------------------
 * @name Customization of the box.
 * -----------------------------------------------------------------------------
 */

/** Sets the blurEffect style.
 *
 * @param blurEffectStyle from enum UIBlurEffectStyle.
 *
 */
- (void)setBlurEffectStyle:(UIBlurEffectStyle)blurEffectStyle;

/** Sets the title of the box.
 *
 * @param title The title of the box.
 *
 */
- (void)setTitle:(NSString *)title;

/** Sets the message of the box.
 *
 * @param title The message of the box. Up to two lines, centered.
 *
 */
- (void)setMessage:(NSString *)message;

/** Sets the text of the submit button.
 *
 * @param title The text of the submit button. 'OK' if not set explicitly.
 *
 */
- (void)setSubmitButtonText:(NSString *)submitButtonText;

/** Sets the text of the cancel button.
 *
 * @param title The text of the cancel button. 'Cancel' if not set explicitly.
 *
 */
- (void)setCancelButtonText:(NSString *)cancelButtonText;

/** Sets the title of the box.
 *
 * @param numberOfDecimals The optional number of decimals when using the
 * `NumberInput` style.
 *
 */
- (void)setNumberOfDecimals:(int)numberOfDecimals;

/**-----------------------------------------------------------------------------
 * @name Showing/hiding the box.
 * -----------------------------------------------------------------------------
 */

/** Shows the box.
 *
 * Simply brings up the box.
 */
- (void)show;

/** Hides the box.
 *
 * Hides the box (actually this doesn't needs to be exposed to the public, huh?)
 */
- (void)hide;

/**-----------------------------------------------------------------------------
 * @name Blocks to handle button actions.
 * -----------------------------------------------------------------------------
 */

/** Gets the string(s) out of the form.
 *
 * @return valueOne The string as entered in the upper textfield.
 * @return valueTwo The string as entered in the lower textfield. 
 * Nil if boxType != `LoginAndPasswordInput`.
 */
@property (nonatomic, copy) BOOL(^onSubmit)(NSString *, NSString *);

/** Block being called if the cancel button got touched.
 *
 */
@property (nonatomic, copy) void(^onCancel)(void);

/**-----------------------------------------------------------------------------
 * @name Block to expose the text field(s) for customisation.
 * -----------------------------------------------------------------------------
 */
@property (nonatomic, copy) UITextField *(^customise)(UITextField *);

@end
