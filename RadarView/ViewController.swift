//
//  ViewController.swift
//  RadarView
//
//  Created by xattacker on 2018/2/17.
//  Copyright © 2018年 xattacker. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController
{
    @IBOutlet private var radarView: UIRadarView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var points = [CLLocationCoordinate2D]()
        points.append(CLLocationCoordinate2D(latitude: 22.662705, longitude: 120.250990))
        points.append(CLLocationCoordinate2D(latitude: 22.635442, longitude: 120.355306))
        points.append(CLLocationCoordinate2D(latitude: 22.705310, longitude: 120.353300))
        self.radarView.setPoints(points, autoRadius: true)
    }
}

