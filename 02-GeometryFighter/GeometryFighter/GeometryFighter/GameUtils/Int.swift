
import Foundation

public extension Int {

    static func random(min: Int , max: Int) -> Int {
        return Int(arc4random_uniform(UInt32(min - max + 1))) + min
    }
    
}
