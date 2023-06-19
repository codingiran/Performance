//
//  Performance.swift
//  Performance
//
//  Created by iran.qiu on 2023/6/19.
//

import Foundation
import MachO
#if os(iOS) || os(tvOS)
import QuartzCore
#endif

open class Performance {
    public init() {}

#if os(iOS) || os(tvOS)
    private var displayLink: CADisplayLink?
    private var lastTime: TimeInterval = 0
    private var count: UInt = 0
    private var _fps: UInt?
#endif
}

// MARK: - Memory

public extension Performance {
    /// 获取设备已使用的内存
    var memoryUsage: Double? {
        guard let memory = memoryFootprint() else { return nil }
        let memoryInMB = Double(memory) / (1024 * 1024)
        return round(memoryInMB * 10) / 10
    }

    /// https://developer.apple.com/forums/thread/105088?answerId=357415022#357415022
    private func memoryFootprint() -> mach_vm_size_t? {
        // The `TASK_VM_INFO_COUNT` and `TASK_VM_INFO_REV1_COUNT` macros are too
        // complex for the Swift C importer, so we have to define them ourselves.
        let TASK_VM_INFO_COUNT = mach_msg_type_number_t(MemoryLayout<task_vm_info_data_t>.size / MemoryLayout<integer_t>.size)
        let TASK_VM_INFO_REV1_COUNT = mach_msg_type_number_t(MemoryLayout.offset(of: \task_vm_info_data_t.min_address)! / MemoryLayout<integer_t>.size)
        var info = task_vm_info_data_t()
        var count = TASK_VM_INFO_COUNT
        let kernelReturn = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
                task_info(mach_task_self_, task_flavor_t(TASK_VM_INFO), $0, &count)
            }
        }
        guard kernelReturn == KERN_SUCCESS, count >= TASK_VM_INFO_REV1_COUNT else { return nil }
        return info.phys_footprint
    }
}

// MARK: - CPU

public extension Performance {
    /// 获取设备 CPU 的占用率
    var cpuUsage: Double? {
        var totalUsageOfCPU: Double?
        var threadsList: thread_act_array_t?
        var threadsCount: mach_msg_type_number_t = 0
        let threadsResult = task_threads(mach_task_self_, &threadsList, &threadsCount)
        if let threadsList = threadsList, threadsResult == KERN_SUCCESS {
            for index in 0 ..< threadsCount {
                var threadInfo = thread_basic_info()
                var threadInfoCount = mach_msg_type_number_t(THREAD_INFO_MAX)
                let infoResult = withUnsafeMutablePointer(to: &threadInfo) {
                    $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                        thread_info(threadsList[Int(index)], thread_flavor_t(THREAD_BASIC_INFO), $0, &threadInfoCount)
                    }
                }
                guard infoResult == KERN_SUCCESS else {
                    break
                }
                let threadBasicInfo = threadInfo as thread_basic_info
                if threadBasicInfo.flags & TH_FLAGS_IDLE == 0 {
                    totalUsageOfCPU = ((totalUsageOfCPU ?? 0) + (Double(threadBasicInfo.cpu_usage) / Double(TH_USAGE_SCALE) * 100.0))
                }
            }
        }
        vm_deallocate(mach_task_self_, vm_address_t(UInt(bitPattern: threadsList)), vm_size_t(Int(threadsCount) * MemoryLayout<thread_t>.stride))
        return totalUsageOfCPU
    }
}

#if os(iOS) || os(tvOS)

// MARK: - FPS

public extension Performance {
    /// 获取设备的屏幕刷新率
    var fps: UInt? {
        if displayLink == nil || displayLink?.isPaused == true {
            configureDisplayLink()
            return nil
        }
        return _fps
    }

    private func configureDisplayLink() {
        displayLink = CADisplayLink(target: self, selector: #selector(displayLinkAction(link:)))
        displayLink?.isPaused = false
        displayLink?.add(to: .main, forMode: .common)
    }

    @objc private func displayLinkAction(link: CADisplayLink) {
        guard lastTime != 0 else {
            lastTime = link.timestamp
            return
        }
        count += 1
        let delta = link.timestamp - lastTime
        guard delta >= 1 else { return }
        lastTime = link.timestamp
        let fps = Double(count) / delta
        count = 0
        _fps = UInt(round(fps))
    }
}

#endif
