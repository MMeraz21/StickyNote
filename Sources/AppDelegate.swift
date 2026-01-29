import AppKit
import SwiftUI

@MainActor
class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!
    private var panel: NSPanel!
    private var noteStore: NoteStore!
    private var eventMonitor: Any?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        noteStore = NoteStore()
        
        // Setup the Edit menu for copy/paste to work
        setupMainMenu()
        
        // Create the floating panel instead of popover
        setupPanel()
        
        // Create status bar item
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "note.text", accessibilityDescription: "Sticky Note")
            button.action = #selector(togglePanel)
            button.target = self
        }
        
        // Monitor for clicks outside the panel to close it
        eventMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown]) { [weak self] event in
            guard let self = self, self.panel.isVisible else { return }
            
            // Check if click is outside the panel
            let screenLocation = NSEvent.mouseLocation
            
            if !self.panel.frame.contains(screenLocation) {
                self.hidePanel()
            }
        }
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        if let eventMonitor = eventMonitor {
            NSEvent.removeMonitor(eventMonitor)
        }
    }
    
    private func setupPanel() {
        // Create a floating panel with resizable style
        panel = NSPanel(
            contentRect: NSRect(x: 0, y: 0, width: 320, height: 400),
            styleMask: [.nonactivatingPanel, .titled, .closable, .resizable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        
        panel.isFloatingPanel = true
        panel.level = .floating
        panel.titleVisibility = .hidden
        panel.titlebarAppearsTransparent = true
        panel.isMovableByWindowBackground = true
        panel.becomesKeyOnlyIfNeeded = false
        panel.backgroundColor = NSColor.windowBackgroundColor
        panel.isOpaque = false
        panel.hasShadow = true
        
        // Set min/max sizes
        panel.minSize = NSSize(width: 200, height: 150)
        panel.maxSize = NSSize(width: 800, height: 1000)
        
        // Round the corners
        panel.contentView?.wantsLayer = true
        panel.contentView?.layer?.cornerRadius = 12
        panel.contentView?.layer?.masksToBounds = true
        
        // Set the SwiftUI content
        let hostingView = NSHostingView(rootView: StickyNoteView(noteStore: noteStore))
        panel.contentView = hostingView
        
        // Handle window close
        panel.delegate = self
    }
    
    private func setupMainMenu() {
        let mainMenu = NSMenu()
        
        // App menu
        let appMenuItem = NSMenuItem()
        let appMenu = NSMenu()
        appMenu.addItem(NSMenuItem(title: "Quit StickyNote", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        appMenuItem.submenu = appMenu
        mainMenu.addItem(appMenuItem)
        
        // Edit menu (required for copy/paste to work)
        let editMenuItem = NSMenuItem()
        let editMenu = NSMenu(title: "Edit")
        
        editMenu.addItem(NSMenuItem(title: "Undo", action: Selector(("undo:")), keyEquivalent: "z"))
        editMenu.addItem(NSMenuItem(title: "Redo", action: Selector(("redo:")), keyEquivalent: "Z"))
        editMenu.addItem(NSMenuItem.separator())
        editMenu.addItem(NSMenuItem(title: "Cut", action: #selector(NSText.cut(_:)), keyEquivalent: "x"))
        editMenu.addItem(NSMenuItem(title: "Copy", action: #selector(NSText.copy(_:)), keyEquivalent: "c"))
        editMenu.addItem(NSMenuItem(title: "Paste", action: #selector(NSText.paste(_:)), keyEquivalent: "v"))
        editMenu.addItem(NSMenuItem(title: "Select All", action: #selector(NSText.selectAll(_:)), keyEquivalent: "a"))
        
        editMenuItem.submenu = editMenu
        mainMenu.addItem(editMenuItem)
        
        NSApplication.shared.mainMenu = mainMenu
    }
    
    @objc func togglePanel() {
        if panel.isVisible {
            hidePanel()
        } else {
            showPanel()
        }
    }
    
    private func showPanel() {
        // Use the current mouse location to determine which screen we're on
        // This is more reliable than the status item's window when switching monitors
        let mouseLocation = NSEvent.mouseLocation
        
        // Find the screen where the mouse click happened
        guard let screen = NSScreen.screens.first(where: { $0.frame.contains(mouseLocation) }) ?? NSScreen.main else {
            return
        }
        
        // Get the menu bar height for this screen
        let menuBarHeight = screen.frame.maxY - screen.visibleFrame.maxY
        
        // Position panel below the menu bar, centered on the mouse X position
        let panelWidth = panel.frame.width
        let panelHeight = panel.frame.height
        
        // Center horizontally on mouse position, but keep within screen bounds
        var x = mouseLocation.x - panelWidth / 2
        x = max(screen.frame.minX + 10, min(x, screen.frame.maxX - panelWidth - 10))
        
        // Position just below the menu bar
        let y = screen.frame.maxY - menuBarHeight - panelHeight - 5
        
        panel.setFrameOrigin(NSPoint(x: x, y: y))
        panel.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    private func hidePanel() {
        panel.orderOut(nil)
    }
}

extension AppDelegate: NSWindowDelegate {
    func windowWillClose(_ notification: Notification) {
        // Just hide, don't quit
        hidePanel()
    }
}
