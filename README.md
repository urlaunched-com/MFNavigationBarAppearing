# MFNavigationBarAppearing
[![Author](https://img.shields.io/badge/author-Max_Kuznetsov-orange.svg)](http://urlaunched.com/)
![Version](https://img.shields.io/badge/version-1.0.7-blue.svg)
![iOS 9.0+](https://img.shields.io/badge/iOS-9.0%2B-blue.svg)
![Xcode 10.0](https://img.shields.io/badge/Xcode-10.0-blue.svg)
![Swift 4.2](https://img.shields.io/badge/Swift-4.2-blue.svg)
![License](https://img.shields.io/badge/license-MIT-black.svg)

![](https://github.com/Molfar-io/MFNavigationBarAppearing/blob/master/example_300.gif)

"the app is developed by [You are launched](https://www.urlaunched.com)"

## Requirements
* Xcode 10+
* iOS 9.0+
* Swift 4.2

## Example

Open and run the **MFNavigationBarAppearing.xcodeproj** in Xcode to see example

## Installation

### CocoaPods

``` ruby
source "https://github.com/Molfar-io/MFPodSpecs.git"

pod 'MFNavigationBarAppearing'
```

### Manual

Add MFNavigationBarAppearing/**Code** folder into your project.

## Usage

First of all you need to setup **content insets** of your scroll view 

![Content insets](https://github.com/Molfar-io/MFNavigationBarAppearing/blob/master/content_insets.png)

### Important 
You need to use **`MFNavigationBarAppearingController`** instead of UINavigationContoller for presenting your UIViewController. This UIViewController should implement **`MFNavigationBarAppearer`** protocol

```swift
let navigationController = MFNavigationBarAppearingController(rootViewController: UIViewController<MFNavigationBarAppearer>())
present(navigationController, animated: true, completion: nil)
```

Next step is implement **`MFNavigationBarAppearer`** protocol in your **`UIViewController`**:

```swift
import MFNavigationBarAppearing

//MARK: - MFNavigationBarAppearer
extension UIViewController: MFNavigationBarAppearer {
    
    var appearingScrollView: UIScrollView? {
        return scrollView
    }

    var navigationBarStartAppearingOffset: CGFloat {
        return collectionViewContainer.frame.height - collectionViewBottomSpacing
    }
    
    var navigationBarEndAppearingOffset: CGFloat? {
        return collectionViewContainer.frame.height
    }
    
    var appearingTitle: String? {
        return place.title?.uppercased()
    }
    
    var appearingTitleStartOffsetAfterAppearingNavBar: CGFloat? {
        return collectionViewContainer.frame.height + titleLabelTopSpacing
    }
    
    var appearingTitleEndOffsetAfterAppearingNavBar: CGFloat? {
        return collectionViewContainer.frame.height + placeTitleLabel.frame.height
    }
}
```

#### appearingScrollView
It's **UIScrollView** which we will use to handle content offset for calculating appearing state of the navigation bar.

#### navigationBarStartAppearingOffset
The offset from the top of the screen, when you need to start navigation bar appearing.

#### navigationBarEndAppearingOffset (Optional)
The offset when navigation bar appearing should end. If the value is not provided, it will be calculated depending on the height of the navigation bar.

#### appearingTitle (Optional)
The title that will be appearing interactively.

#### appearingTitleStartOffsetAfterAppearingNavBar (Optional)
The offset (delay in pixels) befor starting title appearing. 0 by default.

#### appearingTitleEndOffsetAfterAppearingNavBar (Optional)
The offset when navigation bar appearing should be finish. By default title will be appeared together with navigation bar.


## Contacts
If you have any questions regarding pod usage or any improvements ideas, just contact me by email mx.kuznetsov.dev@gmail.com

P.S. If you have ideas for this pod, but don't have time to implement it - write us your idea and we will do it.

## Our resources
[Official website](https://www.urlaunched.com)<br>
[Our company timeline](https://www.urlaunched.com/timeline)<br>
[You are launched expertise](https://www.urlaunched.com/expertise)<br>
[You are launched iOS expertise](https://www.urlaunched.com/expertise/mvp/ios)<br>
[You are launched Android expertise](https://www.urlaunched.com/expertise/mvp/android)<br>
[You are launched design expertise](https://www.urlaunched.com/expertise/design)<br>
[You are launched web expertise](https://www.urlaunched.com/expertise/web)<br>
[You are launched Lean Startup expertise](https://www.urlaunched.com/expertise/idea)<br>
[You are launched successful startups](https://www.urlaunched.com/launched)<br>
[Official blog](https://blog.urlaunched.com/)

## License

	The MIT License (MIT)

	Copyright © 2018 Max Kuznetsov

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:
	
	The above copyright notice and this permission notice shall be included in
	all copies or substantial portions of the Software.
	
	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
	THE SOFTWARE.

