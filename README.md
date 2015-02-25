# MKInputBoxView

MKInputBoxView is a class to replace UIAlertView. It is basically an Objective-C port of [BMInputBox](https://github.com/blackmirror-media/BMInputBox), which is written in Swift.

![alt tag](http://teambender.de/pub/github/MKInputBoxViewLoginAndPassword.png)
![alt tag](http://teambender.de/pub/github/MKInputBoxViewNumber.png)
![alt tag](http://teambender.de/pub/github/MKInputBoxViewPlainText.png)

## Requirements

Built in Objective-C for iOS 8.0 and above. ARC-enabled. For both iPhone and iPad.

## Adding MKInputBoxView To Your Project

### Cocoapods

CocoaPods will be the recommended way to add MKInputBoxView to your project. Just need to get the podfile done...
**Until that time, simply add the `MKInputBoxView.h` and `MKInputBoxView.m` files to your project.**

## Usage

#### Creating an input box

```Objective-C
MKInputBoxView *inputBoxView = [MKInputBoxView boxWithStyle:NumberInput];
[inputBoxView show];
```

Available styles:
* `PlainTextInput` - Simple text field
* `NumberInput` - Text field accepting numbers only - numeric keyboard
* `PhoneNumberInput` - Text field accepting numbers only - phone keyboard
* `EmailInput` - Text field accepting email addresses -  email keyboard
* `SecureTextInput` - Secure text field for passwords
* `LoginAndPasswordInput` - Two text fields for user and password entry

#### Customising the box
Changing the blur effect (UIBlurEffectStyle: ExtraLight, Light, Dark).

```Objective-C
[inputBoxView setBlurEffectStyle:UIBlurEffectStyleDark];
```

Set title and message.

```Objective-C
[inputBoxView setTitle:@"Who are you?"];
[inputBoxView setMessage:@"Please enter your username and password to get access to the system."];
```

Decimals for the `NumberInput` type. Default is 0. If set, the user input will be converted to Double with 2 decimals.

```Objective-C
[inputBoxView setNumberOfDecimals:2];
```

Easy way to manipulate the textField's properties.

```Objective-C
inputBoxView.customiseInputElement = ^(UITextField *textField) {
    textField.placeholder = @"Your eMail address";
    if (textField.secureTextEntry) {
        textField.placeholder = @"Your password";
    }
    textField.textColor = [UIColor whiteColor];
    textField.layer.cornerRadius = 4.0f;
    return textField;
};
```

### Closures for submission and cancellation

```Objective-C
inputBoxView.onSubmit = ^(NSString *value1, NSString *value2) {
    NSLog(@"user: %@", value1);
    NSLog(@"pass: %@", value2);
};
```
```Objective-C
inputBoxView.onCancel = ^{
    NSLog(@"Cancel!");
};
```