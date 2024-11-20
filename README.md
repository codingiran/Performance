# Performance

A lightweight performance monitoring library for Apple platforms that helps track various system metrics including CPU usage, memory consumption, FPS, network traffic, and system wakeups.

## Features

- 📊 CPU Usage Monitoring
- 🎯 FPS (Frames Per Second) Tracking
- 💾 Memory Usage Statistics
- 🌐 Network Traffic Analysis
- ⚡ System Wakeups Detection
- ⏱️ System Uptime Information

## Requirements

- iOS 13.0+ / tvOS 13.0+
- Swift 5.5+
- Xcode 13.0+

## Installation

### Swift Package Manager

Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/iranqiu/Performance.git", from: "1.1.2")
]
```

## Usage

### Basic Setup

```swift
import Performance

let performance = Performance()
```

### CPU Usage

Monitor CPU usage percentage:

```swift
if let cpuUsage = performance.cpuUsage {
    print("CPU Usage: \(cpuUsage)%")
}
```

### Memory Usage

Monitor memory usage:

```swift
if let memoryUsage = performance.memoryUsage {
    print("Memory Usage: \(memoryUsage) MB")
}
```

### System Wakeups

Monitor system wakeups:

```swift
if let interruptWakeups = performance.interruptWakeups {
    print("Interrupt Wakeups: \(interruptWakeups)")
}
```

### System Uptime

Monitor system uptime:

```swift
if let systemUptime = performance.systemUptime {
    print("System Uptime: \(systemUptime) seconds")
}
```

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Author

codingiran@gmail.com

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.