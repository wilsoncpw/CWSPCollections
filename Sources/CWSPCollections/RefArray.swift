//
//  RefArray.swift
//  CWCollections
//
//  Created by Colin Wilson on 02/01/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Foundation

public class RefArray<T>: Sequence {
    /*
    public  func next() -> T? {
        return nil
    }
    */
    
    public typealias Element = T
    
    public var values = [T]()
    
    public var count: Int {
        return values.count
    }
    
    public init () {
    }
    
    public init (_ values: [T]) {
        self.values = values
    }
    
    public func removeAll () {
        values.removeAll()
    }
    
    public func append (_ value: T) {
        values.append(value)
    }
    
    @discardableResult public func remove (at idx: Int)->T {
        return values.remove(at: idx)
    }
    
    public subscript (idx: Int)-> T {
        return values [idx]
    }
    
    public struct Iterator: IteratorProtocol {
        var idx = 0
        let array: RefArray<T>
        init (array: RefArray<T>) {
            self.array = array
        }
        public mutating func next() -> Element? {
            guard idx < array.count else {
                return nil
            }
            defer {
                idx += 1
            }
            return array [idx]
        }
        
        // typealias Element = T
    }
    
    public func makeIterator() -> RefArray<T>.Iterator {
        return Iterator (array: self)
    }
}
