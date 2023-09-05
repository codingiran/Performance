//
//  Wakeup.swift
//  Performance
//
//  Created by CodingIran on 2023/8/30.
//

import Foundation
import PerformanceC

public enum Wakeup {
    public static var interruptWakeups: Int? {
        var interruptWakeup = 0
        guard GetSystemWakeup(&interruptWakeup, nil) else {
            return nil
        }
        return interruptWakeup
    }

    public static var timerWakeups: Int? {
        var timerWakeup = 0
        guard GetSystemWakeup(nil, &timerWakeup) else {
            return nil
        }
        return timerWakeup
    }
}
