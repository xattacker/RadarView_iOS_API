//
//  UIRadarView.swift
//  SwiftTester
//
//  Created by xattacker on 2018/2/13.
//  Copyright © 2018年 xattacker. All rights reserved.
//

import UIKit
import CoreLocation


@IBDesignable public class UIRadarView: UIView
{
    @IBInspectable public var radius: Float = 1
    
    @IBInspectable public var frameColor: UIColor = UIColor.green
    {
        didSet
        {
            self.backgroundView?.frameColor = self.frameColor
            self.backgroundView?.setNeedsDisplay()
            
            self.animationView?.animatedColor = self.frameColor
            self.animationView?.setNeedsDisplay()
        }
    }
    
    @IBInspectable public var pointColor: UIColor = UIColor.red
    {
        didSet
        {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable public var sectorColor: UIColor?
    {
        set
        {
            if let color = newValue
            {
                self.sectorView?.sectorColor = color
                self.sectorView?.setNeedsDisplay()
            }
        }
        get
        {
            return self.sectorView?.sectorColor
        }
    }
  
    private var backgroundView: UIRadarBackgroundView?
    private var animationView: UIRadarAnimationView?
    private var sectorView: UIRadarSectorView?
    
    private var locManager: CLLocationManager?
    private var range: Double = 2
    private var rangeDistance: Double = 1
    private var points: [CLLocationCoordinate2D]?
    
    public override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        self.initView()
    }
    
    public required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        self.initView()
    }
    
    public func setPoints(_ points: [CLLocationCoordinate2D], autoRadius: Bool = true)
    {
        self.rangeDistance = 0
        
        if let location = self.locManager?.location?.coordinate,
           CLLocationCoordinate2DIsValid(location) && autoRadius
        {
            var distance: Double = 0
            
            for point in points
            {
                distance = LbsUtility.getDistance(location, coord2: point)
                if self.rangeDistance < distance
                {
                    self.rangeDistance = distance
                }
            }
            
            self.rangeDistance += self.rangeDistance / 50
        }
        
        self.points = points
        self.setNeedsDisplay()
    }
    
    public override func draw(_ rect: CGRect)
    {
        super.draw(rect)
        
        if let context = UIGraphicsGetCurrentContext()
        {
            let width = fmin(self.frame.size.width, self.frame.size.height)
            let offset_x = abs(width - self.frame.size.width)/2
            let offset_y = abs(width - self.frame.size.height)/2

            // draw point
            let radius_size = width/2.1 //(width/2) - (padding*8)
            let radius = fmax(Double(self.radius), self.rangeDistance)
            self.range = radius * 1000
            
            if let points = self.points, points.count > 0,
               let location = self.locManager?.location?.coordinate
            {
                let scale = CGFloat(self.range) / radius_size
                
                var point_size = self.frame.size.width / CGFloat(16)
                if point_size < 3
                {
                    point_size = 3
                }
                
                context.setFillColor(self.pointColor.cgColor)
                
                let altitude = self.locManager?.location?.altitude ?? 0
                
                for point in points
                {
                    let azimuth = self.angleFromCoordinate(location, second: point)
                    let distanceFromOrigin = LbsUtility.getDistance(location, coord2: point) * Double(1000)
                    let radialDistance = sqrt(pow(0 - altitude, 2) + pow(distanceFromOrigin, 2))
                    
                    if radialDistance < self.range
                    {
                        var x = CGFloat(0)
                        var y = CGFloat(0)
                        
                        //case1: azimiut is in the 1 quadrant of the radar
                        if (azimuth >= 0 && azimuth < Double.pi/2)
                        {
                            x = radius_size + CGFloat(cosf(Float((Double.pi/2) - azimuth))) * (CGFloat(radialDistance) / scale)
                            y = radius_size - CGFloat(sinf(Float((Double.pi/2) - azimuth))) * (CGFloat(radialDistance) / scale)
                        }
                        else if (azimuth > Double.pi/2 && azimuth < Double.pi)
                        {
                            //case2: azimiut is in the 2 quadrant of the radar
                            x = radius_size + CGFloat(cosf(Float(azimuth - (Double.pi/2)))) * (CGFloat(radialDistance) / scale)
                            y = radius_size + CGFloat(sinf(Float(azimuth - (Double.pi/2)))) * (CGFloat(radialDistance) / scale)
                        }
                        else if (azimuth > Double.pi && azimuth < (3 * Double.pi/2))
                        {
                            //case3: azimiut is in the 3 quadrant of the radar
                            x = radius_size - CGFloat(cosf(Float((3 * Double.pi/2) - azimuth))) * (CGFloat(radialDistance) / scale)
                            y = radius_size + CGFloat(sinf(Float((3 * Double.pi/2) - azimuth))) * (CGFloat(radialDistance) / scale)
                        }
                        else if (azimuth > (3 * Double.pi/2) && azimuth < (2 * Double.pi))
                        {
                            //case4: azimiut is in the 4 quadrant of the radar
                            x = radius_size - CGFloat(cosf(Float(azimuth - (3 * Double.pi/2)))) * (CGFloat(radialDistance) / scale)
                            y = radius_size - CGFloat(sinf(Float(azimuth - (3 * Double.pi/2)))) * (CGFloat(radialDistance) / scale)
                        }
                        else if (azimuth == 0)
                        {
                            x = radius_size
                            y = radius_size - CGFloat(radialDistance) / scale
                        }
                        else if (azimuth == Double.pi/2)
                        {
                            x = radius_size + CGFloat(radialDistance) / scale
                            y = radius_size
                        }
                        else if (azimuth == (3 * Double.pi/2))
                        {
                            x = radius_size
                            y = radius_size + CGFloat(radialDistance) / scale
                        }
                        else if (azimuth == (3 * Double.pi/2))
                        {
                            x = radius_size - CGFloat(radialDistance) / scale
                            y = radius_size
                        }
                        else
                        {
                            //If none of the above match we use the scenario where azimuth is 0
                            x = radius_size
                            y = radius_size - CGFloat(radialDistance) / scale
                        }
                        
                        //drawing the radar point
                        if x <= radius_size * 2 && x >= 0 && y >= 0 && y <= radius_size * 2
                        {
                            context.fillEllipse(in:
                                CGRect(
                                    x: x + offset_x,
                                    y: y + offset_y,
                                    width: point_size,
                                    height: point_size))
                        }
                    }
                }
            }
        }
    }
    
    private func angleFromCoordinate(_ first: CLLocationCoordinate2D, second: CLLocationCoordinate2D) -> Double
    {
        let longitudinalDifference = second.longitude - first.longitude
        let latitudinalDifference  = second.latitude  - first.latitude
        let possibleAzimuth        = (Double.pi * 0.5) - atan(latitudinalDifference / longitudinalDifference)
        
        if longitudinalDifference > 0
        {
            return possibleAzimuth
        }
        else if longitudinalDifference < 0
        {
            return possibleAzimuth + Double.pi
        }
        else if latitudinalDifference < 0
        {
            return Double.pi
        }
        
        return Double(0)
    }

    private func initView()
    {
        self.backgroundView = UIRadarBackgroundView(frame: self.bounds)
        self.backgroundView?.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        self.addSubview(self.backgroundView!)
        
        self.sectorView = UIRadarSectorView(frame: self.bounds)
        self.sectorView?.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        self.addSubview(self.sectorView!)
        
        self.animationView = UIRadarAnimationView(frame: self.bounds)
        self.animationView?.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        self.animationView?.animatedColor = self.frameColor
        self.addSubview(self.animationView!)
        
        self.locManager = CLLocationManager()
        self.locManager?.delegate = self
        self.locManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.locManager?.headingFilter = 2
        self.locManager?.distanceFilter = 1
        self.locManager?.startUpdatingHeading()
        self.locManager?.startUpdatingLocation()
        
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.notDetermined
        {
            self.locManager?.requestWhenInUseAuthorization()
        }
    }
    
    deinit
    {
        self.backgroundView = nil
        self.animationView = nil
        self.sectorView = nil
        
        self.locManager?.stopUpdatingHeading()
        self.locManager?.stopUpdatingLocation()
        self.locManager?.delegate = nil
        self.locManager = nil
        
        self.points = nil
    }
}


extension UIRadarView: CLLocationManagerDelegate
{
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        if status == .authorizedWhenInUse
        {
            self.locManager?.startUpdatingHeading()
            self.locManager?.startUpdatingLocation()
        }
    }
    
    public func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool
    {
        return true
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading)
    {
        self.sectorView?.roatedAngle = Float(newHeading.magneticHeading)
    }
}


private class UIRadarBackgroundView: UIView
{
    public var frameColor: UIColor = UIColor.green
    
    public override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
    }
    
    public required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        self.backgroundColor = UIColor.clear
    }
    
    public override func draw(_ rect: CGRect)
    {
        super.draw(rect)
        
        if let context = UIGraphicsGetCurrentContext()
        {
            let width = fmin(self.frame.size.width, self.frame.size.height)
            let offset_x = abs(width - self.frame.size.width)/2
            let offset_y = abs(width - self.frame.size.height)/2
            let padding = CGFloat(0.5)
            let radius_size = (width/2) - (padding*2)
            let circle_width = radius_size/4
            
            context.setStrokeColor(self.frameColor.cgColor)
            
            // Draw a circle
            for i in 0 ..< 4
            {
                let offset = CGFloat(i) * circle_width
                
                context.strokeEllipse(in:
                        CGRect(
                            x: padding + offset + offset_x,
                            y: padding + offset + offset_y,
                            width: (radius_size - offset)*2,
                            height: (radius_size - offset)*2))
            }
            
            
            // draw center marker
            let center_width = circle_width/8
            
            context.move(to: CGPoint(x: width/2 - center_width + offset_x, y: width/2 - center_width + offset_y))
            context.addLine(to: CGPoint(x: width/2 + center_width + offset_x, y: width/2 + center_width + offset_y))
            context.closePath()
            
            context.move(to: CGPoint(x: width/2 - center_width + offset_x, y: width/2 + center_width + offset_y))
            context.addLine(to: CGPoint(x: width/2 + center_width + offset_x, y: width/2 - center_width + offset_y))
            context.closePath()
            
            
            // draw line
            context.move(to: CGPoint(x: padding + offset_x, y: width/2 + offset_y))
            context.addLine(to: CGPoint(x: padding + (circle_width*3) + offset_x, y: width/2 + offset_y))
            context.closePath()
            
            context.move(to: CGPoint(x: width/2 + offset_x, y: padding + offset_y))
            context.addLine(to: CGPoint(x: width/2 + offset_x, y: padding + (circle_width*3) + offset_y))
            context.closePath()
            
            context.move(to: CGPoint(x: width/2 + circle_width + offset_x, y: width/2 + offset_y))
            context.addLine(to: CGPoint(x: width/2 + (circle_width*4) + offset_x, y: width/2 + offset_y))
            context.closePath()
            
            context.move(to: CGPoint(x: width/2 + offset_x, y: width/2 + circle_width + offset_y))
            context.addLine(to: CGPoint(x: width/2 + offset_x, y: width/2 + (circle_width*4) + offset_y))
            context.closePath()
            
            context.strokePath()
        }
    }
}


private class UIRadarSectorView: UIView
{
    public var sectorColor: UIColor = UIColor(white: CGFloat(200.0/255.0), alpha: CGFloat(0.8))
    
    public var roatedAngle: Float = 0
    {
        didSet
        {
            self.transform = CGAffineTransform(rotationAngle: CGFloat((Double.pi * Double(self.roatedAngle)) / 180))
        }
    }
    
    public override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
    }
    
    public required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        self.backgroundColor = UIColor.clear
    }
    
    public override func draw(_ rect: CGRect)
    {
        super.draw(rect)

        if let context = UIGraphicsGetCurrentContext()
        {
            let width = fmin(self.frame.size.width, self.frame.size.height)
            let offset_x = abs(width - self.frame.size.width)/2
            let offset_y = abs(width - self.frame.size.height)/2
            let new_rect = CGRect(x: offset_x, y: offset_y, width: width, height: width)
            let rgb = self.sectorColor.toRGBValue()
            
            let components = [
                            rgb.red, rgb.green, rgb.blue, (rgb.alpha / 6),
                            rgb.red, rgb.green, rgb.blue, (rgb.alpha / 4),
                            rgb.red, rgb.green, rgb.blue, (rgb.alpha / 3),
                            rgb.red, rgb.green, rgb.blue, (rgb.alpha / 2),
                            rgb.red, rgb.green, rgb.blue, (rgb.alpha / 1.8),
                            rgb.red, rgb.green, rgb.blue, (rgb.alpha / 1.5),
                            rgb.red, rgb.green, rgb.blue, (rgb.alpha / 1.2),
                            rgb.red, rgb.green, rgb.blue, rgb.alpha]

            let space = CGColorSpaceCreateDeviceRGB()
            
            if let gradient = CGGradient(colorSpace: space, colorComponents: components, locations: nil, count: 8)
            {
                context.saveGState()
                context.addEllipse(in: new_rect)
                context.clip()
                
                let start_point = CGPoint(x: new_rect.midX, y: new_rect.minY)
                var end_point = CGPoint(x: new_rect.midX, y: new_rect.maxY)
                end_point.y /= 2.0
                
                context.drawRadialGradient(
                    gradient,
                    startCenter: start_point,
                    startRadius: width / 4.2,
                    endCenter: end_point,
                    endRadius: 1,
                    options: CGGradientDrawingOptions.drawsBeforeStartLocation)
            }
        }
    }
}


private class UIRadarAnimationView: UIView
{
    private let DEFAULT_TIME_ALIQUOTS: TimeInterval = 10
    private let DEFAULT_ALIQUOTS: TimeInterval      = 10
    private let WAVE_UPDATE_FREQUENCY: TimeInterval = 1
    
    private var aliquotsCount: Int = 0
    private var aliquots: Int = 10  /* 動畫等份 */
    private var timer: Timer?
    public var animatedColor: UIColor = UIColor.green
    
    public override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        self.startTimer()
    }
    
    public required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        self.backgroundColor = UIColor.clear
        self.startTimer()
    }
    
    public override func draw(_ rect: CGRect)
    {
        super.draw(rect)
        
        if self.aliquots > 0,
           let context = UIGraphicsGetCurrentContext()
        {
            context.setStrokeColor(self.animatedColor.cgColor)
            
            let width = fmin(self.frame.size.width, self.frame.size.height)
            let padding = CGFloat(0.5)
            let radiusSize = (width/2) - (padding*2)
            let circle_width = radiusSize / CGFloat(self.aliquots)
            let offset_x = abs(width - self.frame.size.width)/2
            let offset_y = abs(width - self.frame.size.height)/2
            
            if self.aliquotsCount < -(self.aliquots/2)
            {
                self.aliquotsCount = aliquots
            }
            else
            {
                self.aliquotsCount -= 1
            }
            
            if self.aliquotsCount >= 0
            {
                let offset = CGFloat(self.aliquotsCount) * circle_width
                
                context.strokeEllipse(in:
                        CGRect(x: padding + offset + offset_x,
                               y: padding + offset + offset_y,
                               width: (radiusSize - offset)*2,
                               height: (radiusSize - offset)*2))
            }
        }
    }
    
    private func startTimer()
    {
        self.stopTimer()
        
        if self.aliquots > 0
        {
            // avoid retain cycle
            self.timer = Timer.scheduledTimer(
                            WAVE_UPDATE_FREQUENCY / DEFAULT_TIME_ALIQUOTS,
                            fire:
                            {
                                [weak self] in
                                self?.setNeedsDisplay()
                            },
                            repeats: true)
            
            // avoid touch event to block timer callback
            RunLoop.current.add(self.timer!, forMode: RunLoop.Mode.common)
        }
    }
    
    private func stopTimer()
    {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    deinit
    {
        self.stopTimer()
    }
}
