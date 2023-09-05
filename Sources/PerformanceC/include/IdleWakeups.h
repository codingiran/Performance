//
//  SystemWakeup.h
//  
//
//  Created by iran.qiu on 2023/8/30.
//

#import <Foundation/Foundation.h>
#include <mach/task.h>
#include <mach/mach.h>

BOOL FetchSystemWakeup(NSInteger * _Nullable interrupt_wakeup, NSInteger * _Nullable timer_wakeup) {
    struct task_power_info info = {0};
    mach_msg_type_number_t count = TASK_POWER_INFO_COUNT;
    kern_return_t ret = task_info(current_task(), TASK_POWER_INFO, (task_info_t)&info, &count);
    if (ret == KERN_SUCCESS) {
        if (interrupt_wakeup) {
            *interrupt_wakeup = info.task_interrupt_wakeups;
        }
        if (timer_wakeup) {
            *timer_wakeup = info.task_timer_wakeups_bin_1 + info.task_timer_wakeups_bin_2;
        }
        return true;
    }
    else {
        if (interrupt_wakeup) {
            *interrupt_wakeup = 0;
        }
        if (timer_wakeup) {
            *timer_wakeup = 0;
        }
        return false;
    }
}
