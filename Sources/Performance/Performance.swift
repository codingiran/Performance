//
//  Performance.swift
//  Performance
//
//  Created by iran.qiu on 2023/6/19.
//

import Foundation

// Enforce minimum Swift version for all platforms and build systems.
#if swift(<5.5)
#error("Performance doesn't support Swift versions below 5.5.")
#endif

/// Current Performance version 1.1.3. Necessary since SPM doesn't use dynamic libraries. Plus this will be more accurate.
let version = "1.1.3"

public struct Performance: Sendable {
    public init() {}
}

// MARK: - Memory

public extension Performance {
    var memoryUsage: Double? { Memory.memoryUsage }
}

// MARK: - CPU

public extension Performance {
    var cpuUsage: Double? { CPU.cpuUsage }
}

// MARK: - Wakeups

public extension Performance {
    var interruptWakeups: UInt64? { Wakeups.interruptWakeups }
}
