# RadarView_iOS_API
an iOS swift Radar UI View component 

Android version API: https://github.com/xattacker/RadarView_Android_API<br>


![avatar](/rm_res/record.gif)<br><br>


# Installation

### Cocoapods
RadarView can be added to your project using CocoaPods 0.36 or later by adding the following line to your Podfile:
```
pod 'RadarView_iOS'
```


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

