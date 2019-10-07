//
//  Context.swift
//  PhotoNotes
//
//  Created by Li-Heng Hsu on 2019/10/7.
//  Copyright © 2019 Li-Heng Hsu. All rights reserved.
//

import Foundation

typealias MutableContext<Value> = (@escaping (inout Value) -> Void) -> Void
typealias Context<Value> = (@escaping (Value) -> Void) -> Void
