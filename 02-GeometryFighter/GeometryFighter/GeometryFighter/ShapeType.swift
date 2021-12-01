//
//  ShapeType.swift
//  GeometryFighter
//
//  Created by anker on 2021/12/1.
//

import Foundation

enum ShapeType: Int {
    case box = 0
    case sphere
    case pyramid    //金字塔
    case torus  //环面
    case capsule    //胶囊
    case cylinder   //圆筒
    case cone   //锥体
    case tube   //管子
    
    static func random() -> ShapeType {
        let maxValue = tube.rawValue
        let rand = arc4random_uniform(UInt32(maxValue + 1))
        return ShapeType(rawValue: Int(rand))!
    }
}
