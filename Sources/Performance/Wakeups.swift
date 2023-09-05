//
//  Wakeup.swift
//  Performance
//
//  Created by iran.qiu on 2023/8/30.
//

import Foundation
import PerformanceC

public enum Wakeups {
    public static var interruptWakeups: Int? {
        var interruptWakeup = 0
        guard FetchSystemWakeup(&interruptWakeup, nil) else {
            return nil
        }
        return interruptWakeup
    }

    public static var timerWakeups: Int? {
        var timerWakeup = 0
        guard FetchSystemWakeup(nil, &timerWakeup) else {
            return nil
        }
        return timerWakeup
    }
}
