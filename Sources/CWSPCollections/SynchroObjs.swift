//
//  SynchroObjs.swift
//  CWCollections
//
//  Created by Colin Wilson on 05/12/2017.
//  Copyright © 2017 Colin Wilson. All rights reserved.
//

import Foundation

//==========================================================================
// SynchroDictionary class.  Synchronizes access to an underlying dictionary
public class SynchroDictionary <Key: Hashable,Value: Any> {
    fileprivate var dict = [Key:Value] ()
    fileprivate let queue = DispatchQueue (label: "SynchroDictionary", attributes: .concurrent)
    
    public init () {
    }
    
    public func setValueForKey (key: Key, value: Value) {
        queue.async (flags: .barrier) {
            self.dict [key] = value
        }
    }
    
    @discardableResult public func removeValue (forKey: Key) -> Value? {
        var rv: Value? = nil
        
        queue.sync (flags: .barrier)  {
            rv = self.dict.removeValue(forKey: forKey)
        }
        return rv
    }
    
    public func rawDictionary () -> [Key:Value] {
        var rv : [Key:Value]?
        
        queue.sync (flags: .barrier) {
            rv = self.dict
        }
        
        return rv!
    }
    
    public func containsKey (key: Key)-> Bool {
        var rv = false
        
        queue.sync (flags: .barrier) {
            rv = self.dict.index(forKey: key) != nil
        }
        return rv
    }
}

//==========================================================================
// SynchroSet class.  Synchronizes access to an underlying Set
public class SynchroSet <Element: Hashable> {
    fileprivate var set = Set <Element> ()
    fileprivate let queue = DispatchQueue (label: "SynchroSet", attributes: .concurrent)
    
    public init () {
    }
    
    public func insert (elem: Element) {
        queue.async (flags: .barrier) { // Async - it can do it in it's own sweet time
            self.set.insert (elem)
        }
    }
    
    public func contains (elem: Element)->Bool {
        var rv = false
        
        queue.sync (flags: .barrier) {  // Sync - because we can't return until we've got the result
            rv = self.set.contains (elem)
        }
        return rv
    }
    
    public func removeAll ()  -> Set<Element> {
        var rv : Set<Element>?
        
        queue.sync {
            rv = self.set
            self.set.removeAll ()
        }
        
        return rv!
    }
}
