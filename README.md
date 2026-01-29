# StickyNote

A minimal macOS menu bar app for keeping important strings handy. Built because I was tired of having to copy and paste fields into job applications that should've been parsed from my resume.

![macOS](https://img.shields.io/badge/macOS-14.0+-blue)
![Swift](https://img.shields.io/badge/Swift-6.1-orange)

## Features

- Lives in the menu bar (not the dock)
- Single sticky note for your important text
- 6 color themes (yellow, pink, mint, lavender, peach, sky)
- Resizable window
- Persists across app restarts
- Full copy/paste support (⌘C, ⌘V, ⌘X, ⌘A)

## Installation

### Option 1: Build from source

```bash
git clone https://github.com/YOUR_USERNAME/StickyNote.git
cd StickyNote
./build.sh
cp -r StickyNote.app /Applications/
```

### Option 2: Run directly (for development)

```bash
swift run
```

## Usage

1. Click the 📝 icon in your menu bar to open
2. Type or paste your text
3. Click the color dots to change the note color
4. Click outside or press the menu bar icon again to close
5. Your note is automatically saved

## Start at Login

1. Open **System Settings** → **General** → **Login Items**
2. Click **+** and select **StickyNote** from Applications

## Requirements

- macOS 14.0 (Sonoma) or later

## License

MIT
