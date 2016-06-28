//Copyright (c) 2016
//
//Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
import Foundation

/// A set of preset bezier curves.
public enum TimingFunctionType {
    /// Equivalent to `kCAMediaTimingFunctionDefault`.
    case Default
    
    /// Equivalent to `kCAMediaTimingFunctionEaseIn`.
    case EaseIn
    
    /// Equivalent to `kCAMediaTimingFunctionEaseOut`.
    case EaseOut
    
    /// Equivalent to `kCAMediaTimingFunctionEaseInEaseOut`.
    case EaseInEaseOut
    
    /// No easing.
    case Linear
    
    /// Inspired by the default curve in Google Material Design.
    case SwiftOut
    /// 
    case BackEaseIn
    ///
    case BackEaseOut
    ///
    case BackEaseInOut
    ///
    case BounceOut
    /// custom
    case CustomUnitBezier(Double, Double, Double, Double)
    
    
    func easing() -> TimingSolvable {
        switch self {
        case .Default:
            return UnitBezier(p1x: 0.25, p1y: 0.1, p2x: 0.25, p2y: 1.0)
        case .EaseIn:
            return UnitBezier(p1x: 0.42, p1y: 0.0, p2x: 1.0, p2y: 1.0)
        case .EaseOut:
            return UnitBezier(p1x: 0.0, p1y: 0.0, p2x: 0.58, p2y: 1.0)
        case .EaseInEaseOut:
            return UnitBezier(p1x: 0.42, p1y: 0.0, p2x: 0.58, p2y: 1.0)
        case .Linear: 
            return UnitBezier(p1x: 0.0, p1y: 0.0, p2x: 1.0, p2y: 1.0)
        case .SwiftOut: 
            return UnitBezier(p1x: 0.4, p1y: 0.0, p2x: 0.2, p2y: 1.0)
        case .BackEaseIn:
            return EasingContainer(easing: { (t: Double) in
                return t * t * t - t * sin(t * M_PI)
            })
        case .BackEaseOut:
            return EasingContainer(easing: { (t: Double) in
                let f = (1 - t);
                return 1 - (f * f * f - f * sin(f * M_PI));
            })
        case .BackEaseInOut:
            return EasingContainer(easing: { (t: Double) in
                if(t < 0.5) {
                    let f = 2 * t;
                    return 0.5 * (f * f * f - f * sin(f * M_PI));
                } else {
                    let f = (1.0 - (2.0 * t - 1.0));
                    let cubic = f * f * f
                    return 0.5 * (1.0 - (cubic - f * sin(f * M_PI))) + 0.5;
                }
            })
        case .BounceOut:
            return EasingContainer(easing: { (t: Double) in
                if(t < 4/11.0){
                    return (121 * t * t)/16.0;
                } else if(t < 8/11.0){
                    return (363/40.0 * t * t) - (99/10.0 * t) + 17/5.0;
                }else if(t < 9/10.0){
                    return (4356/361.0 * t * t) - (35442/1805.0 * t) + 16061/1805.0;
                }else{
                    return (54/5.0 * t * t) - (513/25.0 * t) + 268/25.0;
                }
            })
        case .CustomUnitBezier(let p1x,let p1y,let p2x,let p2y):
            return UnitBezier(p1x: p1x, p1y: p1y, p2x: p2x, p2y: p2y)
        }
    }
}

class EasingContainer: TimingSolvable {
    let easing: (Double) -> Double
    
    init(easing: (Double) -> Double) {
        self.easing = easing
    }
    
    //
    func solveOn(time: Double, epslion: Double) -> Double {
        return self.easing(time)
    }
    
}
