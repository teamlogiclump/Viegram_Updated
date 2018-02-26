![Build Status](https://travis-ci.org/abdullahselek/SwiftyNotifications.svg?branch=master)
![CocoaPods Compatible](https://img.shields.io/cocoapods/v/SwiftyNotifications.svg)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
![Platform](https://img.shields.io/cocoapods/p/SwiftyNotifications.svg?style=flat)
![License](https://img.shields.io/dub/l/vibe-d.svg)

# SwiftyNotifications

Highly configurable iOS UIView for presenting notifications that doesn't block the UI.

## Screenshots
![info](https://github.com/abdullahselek/SwiftyNotifications/blob/master/Screenshots/info.png)
![error](https://github.com/abdullahselek/SwiftyNotifications/blob/master/Screenshots/error.png)
![success](https://github.com/abdullahselek/SwiftyNotifications/blob/master/Screenshots/success.png)
![warning](https://github.com/abdullahselek/SwiftyNotifications/blob/master/Screenshots/warning.png)
![custom](https://github.com/abdullahselek/SwiftyNotifications/blob/master/Screenshots/custom.png)

## Requirements

iOS 8.0+ / Swift 3.0+

## CocoaPods

CocoaPods is a dependency manager for Cocoa projects. You can install it with the following command:
```
$ gem install cocoapods
```

To integrate SwiftyNotifications into your Xcode project using CocoaPods, specify it in your Podfile:
```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

target '<Your Target Name>' do
	pod 'SwiftyNotifications', '~>0.2'
end
```

Then, run the following command:
```
$ pod install
```

## Carthage

Carthage is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with Homebrew using the following command:

```
brew update
brew install carthage
```

To integrate SwiftyNotifications into your Xcode project using Carthage, specify it in your Cartfile:

```
github "abdullahselek/SwiftyNotifications" ~> 0.2
```

## Example Usage
```
import SwiftyNotifications
````

Than initiate notification and add to your view
```
let notification = SwiftyNotifications.withStyle(style: .info,
                                                 title: "Swifty Notifications",
                                                 subtitle: "Highly configurable iOS UIView for presenting notifications that doesn't block the UI")
view.addSubview(notification)
```

You can customize this notification anytime in your view
```
notification.customize(style: .warning)
```

and update texts
```
notification.setTitle(title: "New title", subtitle: "New subtitle")
```

To show the notification
```
notification.show()
```

To dismiss
```
notification.dismiss()
```

Creating custom notification
```
let customNotification = SwiftyNotifications.withStyle(style: .custom,
                                                       title: "Custom",
                                                       subtitle: "Custom notification with custom image and colors")
customNotification.leftAccessoryView.image = UIImage(named: "apple_logo")!
customNotification.setCustomColors(backgroundColor: UIColor.cyan, textColor: UIColor.white)
view.addSubview(customNotification)
```

Other available functions for creating notifications
> With a time interval option for auto dismissing
```
let notification = SwiftyNotifications.withStyle(style: .warning,
                                                 title: "Title",
                                                 subtitle: "Subtitle",
                                                 dismissDelay: 3.0)
```
> With touch handler
```
let notification = SwiftyNotifications.withStyle(style: .error,
                                                 title: "Title",
                                                 subtitle: "Subtitle",
                                                 dismissDelay: 5.0) {
                                                            
        }
```

Optional delegates that gives informations about showing and dismissing notification screen
- `func willShowNotification(notification: SwiftyNotifications)`
- `func didShowNotification(notification: SwiftyNotifications)`
- `func willDismissNotification(notification: SwiftyNotifications)`
- `func didDismissNotification(notification: SwiftyNotifications)`

Adding touch handler to catch tap gestures on notification
```
notification.addTouchHandler {

        }
```