//
//  Context.swift
//  PhotoNotes
//
//  Created by Li-Heng Hsu on 2019/10/7.
//  Copyright © 2019 Li-Heng Hsu. All rights reserved.
//

import Foundation


typealias Context<Value> = ((Value) -> Void) -> Void
typealias MutableContext<Value> = ((inout Value) -> Void) -> Void
typealias AsynchronousContext<Value> = (@escaping (Value) -> Void) -> Void
typealias AsynchronousMutableContext<Value> = (@escaping (inout Value) -> Void) -> Void
