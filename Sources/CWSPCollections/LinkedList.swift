//
//  LinkedList.swift
//  CWCollections
//
//  Created by Colin Wilson on 05/12/2017.
//  Copyright © 2017 Colin Wilson. All rights reserved.
//

import Foundation

public class ListNode <T: Hashable, V> {
    var value: V
    let key: T
    weak var prev: ListNode?
    var next: ListNode?
    
    init (key: T, value: V) {
        self.value = value
        self.key = key
    }
    
    func changeValue (newValue: V) {
        value = newValue
    }
}

//===========================================================
// LinkedList class
//
// Doubly linked list.  Note that the strong references are
// first, next....  Weak ones are last, prev...


public class LinkedList <T: Hashable, V> {
    private var firstNode: ListNode<T,V>?
    private weak var lastNode: ListNode<T,V>?
    
    @discardableResult public func removeNode (_ node: ListNode<T,V>)->ListNode<T,V> {
        if let prev = node.prev {
            prev.next = node.next
        } else {
            firstNode = node.next
        }
        
        if let next = node.next {
            next.prev = node.prev
        } else {
            lastNode = node.prev
        }
        node.next = nil
        node.prev = nil
        return node
    }
    
    @discardableResult public func appendNode (_ node: ListNode<T,V>)->ListNode<T,V> {
        node.prev = lastNode
        
        if let last = lastNode {
            last.next = node
        } else {
            firstNode = node
        }
        lastNode = node
        return node
    }
    
    public func moveToEnd (node: ListNode<T,V>) {
        if node !== lastNode {
            appendNode (removeNode (node))
        }
    }
    
    public func removeAll () {
        firstNode = nil
        lastNode = nil
    }
    
    public func removeFirst ()->ListNode<T,V>? {
        if let n = firstNode {
            return removeNode (n)
        } else {
            return nil
        }
    }
}

