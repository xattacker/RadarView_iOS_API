//
//  Timer.swift
//  UtilToolKit_Swift
//
//  Created by xattacker on 2017/12/9.
//  Copyright © 2017年 xattacker. All rights reserved.
//

import Foundation


extension Timer
{
    // the same effect function will be existed from iOS 10
    public static func scheduledTimer(
    _ timeInterval: TimeInterval,
    fire: @escaping () -> Void,
    repeats: Bool) -> Timer
    {
        let timer = Timer(
                    timeInterval: timeInterval,
                    target: self,
                    selector: #selector(Timer.onFire),
                    userInfo: fire,
                    repeats: true)
        return timer
    }
    
    @objc static func onFire(_ timer: Timer)
    {
        if let fire = timer.userInfo as? (() -> Void)
        {
            fire()
        }
    }
}
