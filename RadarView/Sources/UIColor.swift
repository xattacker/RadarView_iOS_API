//
//  UIColor.swift
//  RadarView_iOS
//
//  Created by tao on 2016/7/19.
//  Copyright © 2016年 xattacker. All rights reserved.
//

import UIKit


extension UIColor
{
    internal var rgb: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)
    {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        if let rgb = self.cgColor.components
        {
            let size = self.cgColor.numberOfComponents
            
            if size == 2
            {
                // white
                r = rgb[0]
                g = rgb[0]
                b = rgb[0]
                
                a = rgb[1]
            }
            else
            {
                r = rgb[0]
                g = rgb[1]
                b = rgb[2]
                
                a = rgb[3]
            }
        }
        
        return (r, g, b, a)
    }
}
