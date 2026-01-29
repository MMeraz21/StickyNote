import AppKit
import SwiftUI

// Hide from dock - must be set before NSApplication.shared is accessed
NSApplication.shared.setActivationPolicy(.accessory)

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.run()
