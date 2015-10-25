//
//  AsObservable.swift
//  Rx
//
//  Created by Krunoslav Zaher on 2/27/15.
//  Copyright (c) 2015 Krunoslav Zaher. All rights reserved.
//

import Foundation

class AsObservableSink<O: ObserverType> : Sink<O>, ObserverType {
    typealias Element = O.E
    
    override init(observer: O, cancel: Disposable) {
        super.init(observer: observer, cancel: cancel)
    }
    
    func on(event: Event<Element>) {
        observer?.on(event)
        
        switch event {
        case .Error, .Completed:
            dispose()
        default: break
        }
    }
}

class AsObservable<Element> : Producer<Element> {
 
    private let _source: Observable<Element>
    
    init(source: Observable<Element>) {
        _source = source
    }
    
    override func run<O: ObserverType where O.E == Element>(observer: O, cancel: Disposable, setSink: (Disposable) -> Void) -> Disposable {
        let sink = AsObservableSink(observer: observer, cancel: cancel)
        setSink(sink)
        return _source.subscribeSafe(sink)
    }
}
