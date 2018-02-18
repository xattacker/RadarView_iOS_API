//
//  UIColor.swift
//  UtilToolKit
//
//  Created by tao on 2016/7/19.
//  Copyright © 2016年 xattacker. All rights reserved.
//

import UIKit


public extension UIColor
{
    public func getRGBValue(_ red: inout CGFloat, green: inout CGFloat, blue: inout CGFloat, alpha: inout CGFloat)
    {
        let rgb = self.cgColor.components
        let size = self.cgColor.numberOfComponents
        
        if size == 2
        {
            // white
            red = (rgb?[0])!
            green = (rgb?[0])!
            blue = (rgb?[0])!
            
            alpha = (rgb?[1])!
        }
        else
        {
            red = (rgb?[0])!
            green = (rgb?[1])!
            blue = (rgb?[2])!
            
            alpha = (rgb?[3])!
        }
    }
    
    public func getRGBValue(_ red: inout CGFloat, green: inout CGFloat, blue: inout CGFloat)
    {
        var alpha = CGFloat(0) // inout parameter could not set default value for nil
        self.getRGBValue(&red, green: &green, blue: &blue, alpha: &alpha)
    }
    
    public func getAlphaValue(_ alpha: inout CGFloat)
    {
        var r = CGFloat(0)
        var g = CGFloat(0)
        var b = CGFloat(0)
        self.getRGBValue(&r, green: &g, blue: &b, alpha: &alpha)
    }
}
