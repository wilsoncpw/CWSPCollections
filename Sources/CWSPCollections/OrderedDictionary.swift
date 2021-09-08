//
//  OrderedDictionary.swift
//  CWCollections
//
//  Created by Colin Wilson on 27/11/2017.
//  Copyright © 2017 Colin Wilson. All rights reserved.
//

import Foundation

public protocol KeyProvider {
    associatedtype T: Hashable, Comparable
    
    var key: T { get }
}

//========================================================================
// Provide a dictionary of objects that provide a key.  Maintain an
// additional sorted array of keys so that the objects can be kept ordered
public struct OrderedDictionary <Value: KeyProvider>: MutableCollection {
    private var keys = Array<Value.T> ()
    private var dict = Dictionary<Value.T, Value> ()
    
    public init () {
    }
    
    public typealias Index = Int
    
    //---------------------------------------------------------------------
    // Use key subscript to get or set/add values.
    // eg.
    // let providerObj = MyKeyProvider ("fred")
    // dict ["fred"] = providerObj (or dict [providerObj.key] = providerObj
    public subscript (key: Value.T) -> Value? {
        get {
            return dict [key]
        }
        set (newValue) {
            if !dict.keys.contains(key) {
                keys.append(key)
            }
            dict [key] = newValue
        }
    }
    
    // MutableCollection protocol
    //-----------------------------------------------------------------------
    // Integer subscript
    // eg.
    // let x = dict [3]
    // dict [3] = providerObj
    
    public subscript (idx: Index) -> Value {
        get {
            return dict [keys [idx]]!
        } set (newValue) {
            if idx < keys.count {
                let key = newValue.key
                let oldKey = keys [idx]
                keys [idx] = key
                if oldKey != key {
                    dict.removeValue(forKey: oldKey)
                }
                dict [key] = newValue
            }
        }
    }
    
    // Collection protocol
    //--------------------------------------------------------------------------
    // startIndex
    public var startIndex: Index {
        return 0
    }
    
    //--------------------------------------------------------------------------
    // endIndex
    public var endIndex: Index {
        return keys.count-1
    }
    
    //--------------------------------------------------------------------------
    // index:after
    public func index(after i:Index) -> Index {
        return i + 1
    }
    
    
    //--------------------------------------------------------------------------
    // count.  Note that Collection provides a default implementation, but may
    // be inefficient
    public var count: Int {
        return keys.count
    }
    
    //--------------------------------------------------------------------------
    // Sort the collection by sorting the keys
    public mutating func sort () {
        keys.sort()
    }
    
    //--------------------------------------------------------------------------
    // removeAll
    public mutating func removeAll () {
        keys.removeAll()
        dict.removeAll()
    }
    
    //--------------------------------------------------------------------------
    // remove: at: Index
    //
    // Remove a value by index and return it
    @discardableResult public mutating func remove (at: Index) -> Value? {
        if at < keys.count {
            let key = keys [at]
            keys.remove(at: at)
            return dict.removeValue(forKey: key)
        }
        return nil
    }
    
    //--------------------------------------------------------------------------
    // removeValue forKey:
    //
    // Remove a value by key, and return it
    @discardableResult public mutating func removeValue (forKey: Value.T) -> Value? {
        guard let idx = keys.firstIndex(of: forKey) else {
            return nil
        }
        
        keys.remove(at: idx)
        return dict.removeValue(forKey: forKey)
    }
}
