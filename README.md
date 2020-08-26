# RadarView_iOS_API
an iOS swift Radar UI View component 
<br><br>
Development Target: iOS 10
<br><br><br>

![avatar](/rm_res/record.gif)<br><br>


# Installation

### Cocoapods
RadarView can be added to your project using CocoaPods 0.36 or later by adding the following line to your Podfile:
```
pod 'RadarView_iOS'
```
### Swift Package Manager
To add RadarView to a [Swift Package Manager](https://swift.org/package-manager/) based project, add:

```swift
.package(url: "https://github.com/xattacker/RadarView_iOS_API.git", .upToNextMajor(from: "1.0.1")),
```
to your `Package.swift` files `dependencies` array.



### How to use:

```
import RadarView_iOS

var radarView: UIRadarView!

var points = [CLLocationCoordinate2D]()
points.append(CLLocationCoordinate2D(latitude: 22.662705, longitude: 120.250990))
points.append(CLLocationCoordinate2D(latitude: 22.635442, longitude: 120.355306))
points.append(CLLocationCoordinate2D(latitude: 22.705310, longitude: 120.353300))
radarView.setPoints(points, autoRadius: true)
```

