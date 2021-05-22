# YetiiLiib

YetiiLiib is a relatively small project which contains code that is shared across various of [Yetii's apps](https://yetii.net).

## Features

- Boilerplate "About" screen, displaying the app's icon, a short message, and the names of people to be thanked, including a link to their Twitter
- "More Apps" screen, allowing for all apps by a single developer to be displayed to the user and linked to the App Store, allowing for cross promotion
- A utility to apply the iOS 7 icon rounding mask to any image, such as an app icon. Rounding is performed on-the-fly and uses Apple's own rounding mask SVG
- Convenience classes for boilerplate `UITableViewCell`s:
  - Basic
  - Subtitle
  - Right Detail
  - Right Detail and Subtitle

## Version Support

YetiiLiib supports iOS 7.0+, although the majority of the testing is performed on iOS 8.0+ (due to simulator limitations). Due to this, you will see some compilers warnings when compiling the framework. These can be ignored.

## Installation

### iOS 8.0+

When using iOS 8.0+, Carthage may be used. To use Carthage, add the following to your Cartfile:

```
github "YetiiNet/YetiiLiib"
```

### iOS 7.0+

To support iOS 7, you must include the source files directly. This is done most easily using CocoaSeeds, with the following in your Seedfile:

```
github "YetiiNet/YetiiLiib", "master", :files => "YetiiLiib/**.{swift,xcassets,xib}"
```

## iOS 9 Considerations

When loading the list of apps by a provided developer (see the `OtherAppsTableViewController.swift` file), the initial load is performed over HTTPS. However, to load the app icons, HTTP is used. To enable the loading of icons you will need to add the following to your `Info.plist` file:

```
<dict>
	<key>NSExceptionDomains</key>
	<dict>
		<key>mzstatic.com</key>
		<dict>
			<key>NSIncludesSubdomains</key>
			<true/>
			<key>NSExceptionAllowsInsecureHTTPLoads</key>
			<true/>
		</dict>
	</dict>
</dict>
</plist>
```
