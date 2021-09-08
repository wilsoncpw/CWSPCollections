//
//  LRUCache.swift
//  CWCollections
//
//  Created by Colin Wilson on 05/12/2017.
//  Copyright © 2017 Colin Wilson. All rights reserved.
//

import Foundation

//==========================================================================
// LRUCache class
//
// Stores key/objects pairs by adding them to the end of a linked list,
// discarding objects at the beginning of the list if there are too many.
//
// Also maintains a dictionary of keys and nodes in the liked list so we
// can quickly check whether the cache contains an object.
//
// Accessing an existing object updates its position in the cache by moving it
// to the end of the list

public class LRUCache <T: Hashable, V> {
    private var dict = Dictionary <T, ListNode<T,V>> ()
    private var list = LinkedList<T,V> ()
    private var lock: NSLock?
    
    private func deleteTooManyObjects () {
        while dict.count > countLimit {
            if let f = list.removeFirst() {
                dict.removeValue(forKey: f.key)
            }
        }
    }
    
    public var count : Int {
        return dict.count
    }
    
    public init () {
    }
    
    public func setObject (_ value: V, forKey: T) {
        lock?.lock()
        defer {
            lock?.unlock()
        }
        
        if let v = dict [forKey] {
            v.changeValue(newValue: value)
            list.moveToEnd(node: v)
        } else {
            dict [forKey] = list.appendNode (ListNode (key: forKey, value: value))
        }
        
        deleteTooManyObjects()
    }
    
    public func object (forKey: T)->V? {
        lock?.lock()
        defer {
            lock?.unlock()
        }
        if let v = dict [forKey] {
            list.moveToEnd(node: v)
            return v.value
        } else {
            return nil
        }
    }
    
    public func removeAllObjects () {
        lock?.lock()
        defer {
            lock?.unlock()
        }
        dict.removeAll ()
        list.removeAll ()
    }
    
    public func removeObject (forKey: T) {
        lock?.lock()
        defer {
            lock?.unlock()
        }
        if let idx = dict.index(forKey: forKey) {
            list.removeNode (dict [idx].value)
            dict.remove(at: idx)
        }
    }
    
    public var countLimit = 20 {
        didSet {
            lock?.lock()
            defer {
                lock?.unlock()
            }
            
            deleteTooManyObjects()
        }
    }
    
    public var threadSafe = false {
        didSet {
            if threadSafe {
                lock = NSLock ()
            } else {
                lock = nil
            }
        }
    }
}



