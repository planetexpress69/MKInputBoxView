# MKInputBoxView

MKInputBoxView is a class to replace UIAlertView. It is basically an Objective-C port of [BMInputBox](https://github.com/blackmirror-media/BMInputBox), which is written in Swift.

![alt tag](http://teambender.de/pub/github/MKInputBoxViewLoginAndPassword.png)
![alt tag](http://teambender.de/pub/github/MKInputBoxViewNumber.png)
![alt tag](http://teambender.de/pub/github/MKInputBoxViewPlainText.png)

## Requirements

Built in Objective-C for iOS 8.0 and above. ARC-enabled. For both iPhone and iPad.

## Adding MKInputBoxView To Your Project

### Cocoapods

This branch is not available as Pod. Go to [master](https://github.com/planetexpress69/MKInputBoxView/tree/master)...
Just add `MKInputBoxView.h`and `MKInputBoxView.m` to your project.

## Usage

#### Creating an input box

```Objective-C
MKInputBoxView *inputBoxView = [MKInputBoxView boxOfType:NumberInput];
[inputBoxView show];
```

Available styles:
* `PlainTextInput` - Simple text field
* `NumberInput` - Text field accepting numbers only - numeric keyboard
* `PhoneNumberInput` - Text field accepting numbers only - phone keyboard
* `EmailInput` - Text field accepting email addresses -  email keyboard
* `SecureTextInput` - Secure text field for passwords
* `LoginAndPasswordInput` - Two text fields for user and password entry
* `EmailAndNameAndEmail` - Three text fields for email address, name and another email address with the appr. keyboards.

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

Set text of the buttons
```Objective-C
[inputBoxView setSubmitButtonText:@"OK"];
[inputBoxView setCancelButtonText:@"Cancel"];
```

Decimals for the `NumberInput` type. Default is 0. If set, the user input will be converted to Double with 2 decimals.

```Objective-C
[inputBoxView setNumberOfDecimals:2];
```

Easy way to manipulate the textField's properties.

```Objective-C
inputBoxView.customise = ^(UITextField *textField) {
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
inputBoxView.onSubmit = ^(NSString *value1, NSString *value2, NSString *value3) {
    NSLog(@"value1: %@", value1);
    NSLog(@"value2: %@", value2);
    NSLog(@"value3: %@", value3);
    if (someCondition) {
      return YES; // YES to hide the inputBoxView
    } else {
      return NO; // NO will keep the inputBoxView open
    }
};
```
```Objective-C
inputBoxView.onCancel = ^{
    NSLog(@"Cancel!");
};
```
