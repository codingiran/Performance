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

/// Current Performance version 2.0.1. Necessary since SPM doesn't use dynamic libraries. Plus this will be more accurate.
let version = "2.0.1"

open class Performance {
#if os(iOS) || os(tvOS)
    private lazy var fps = FPS()
#endif
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
    var interruptWakeups: Int? { Wakeups.interruptWakeups }
    var timerWakeups: Int? { Wakeups.timerWakeups }
}

#if os(iOS) || os(tvOS)

// MARK: - FPS

public extension Performance {
    /// 获取设备的屏幕刷新率
    var currentFPS: UInt? { self.fps.fps }
}

#endif
