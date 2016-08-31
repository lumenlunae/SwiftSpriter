//
//  ModelMath.swift
//  SwiftSpriter
//
//  Created by Matt on 8/27/16.
//  Copyright © 2016 BiminiRoad. All rights reserved.
//

import Foundation

func ScalarNearOtherWithVariance(value: CGFloat, other: CGFloat, variance: CGFloat) -> Bool {
    if value <= (other + variance) && value >= (other - variance) {
        return true
    }
    return false
}

func LinearInterpolation(a: CGFloat, b: CGFloat, t: CGFloat) -> CGFloat {
    if a == b {
        return a
    }
    return ((b - a) * t) + a
}

func LinearAngleInterpolationDegrees(angleA: CGFloat, angleB: CGFloat, spin: Int, t: CGFloat) -> CGFloat {
    var b = angleB
    
    if spin > 0 {
        if angleB < angleA {
            b += 360.0
        }
    } else if spin < 0 {
        if angleB > angleA {
            b -= 360.0
        }
    } else {
        return angleA
    }
    
    return LinearInterpolation(a: angleA, b: b, t: t)
}

func LinearAngleInterpolationRadian(angleA: CGFloat, angleB: CGFloat, spin: Int, t: CGFloat) -> CGFloat {
    var b = angleB
    if spin > 0 {
        if angleB < angleA {
            b += CGFloat(2 * M_PI)
        }
    } else if spin < 0 {
        if angleB > angleA {
            b -= CGFloat(2 * M_PI)
        }
    } else {
        return angleA
    }
    
    return LinearInterpolation(a: angleA, b: b, t: t)
}
