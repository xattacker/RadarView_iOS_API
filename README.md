# RadarView_iOS_API
an iOS swift Radar UI View component 
<br><br>
Development Target: iOS 13
<br><br><br>

![avatar](/rm_res/record.gif)<br><br>


# Installation

### Swift Package Manager
To add RadarView to a [Swift Package Manager](https://swift.org/package-manager/) based project, add:

```swift
.package(url: "https://github.com/xattacker/RadarView_iOS_API.git", .upToNextMajor(from: "1.1.0")),
```
to your `Package.swift` files `dependencies` array.
<br><br>

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

