# Swifont 

[![Licence: MIT](https://img.shields.io/badge/Licence-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform: macOS](https://img.shields.io/badge/Platform-macOS-blue.svg)]()
[![Swift: 6.0](https://img.shields.io/badge/Swift-6.0-orange.svg)]()

**"A sophisticated macOS utility that elegantly transforms icon fonts into type-safe Swift code, streamlining your development workflow with effortless precision."**

---

## Overview

**Swifont** is a refined productivity tool tailored for Swift developers who value meticulousness. It seeks to eliminate the rather tedious chore of manually mapping font glyphs to Unicode values. By simply dragging your font files, you can obtain production-ready Swift code within seconds.

> Spare yourself the bother of manual typing. Modernise your workflow with Swifont.

---

## Key Features

* **Instant Drag & Drop**: Simply drop your `.ttf` or `.otf` files to **analyse** them immediately.
* **Type-Safe Code Generation**: Automatically **organises** your icons into clean Swift Enums or Constants.
* **Optimised for Swift**: Perfectly suited for contemporary SwiftUI and UIKit development.
* **Privacy-First Design**: All processing is performed locally on your Mac. No data ever leaves your device.
* **Bespoke Interface**: A beautiful macOS experience that supports both Light and Dark modes.

---

## Screenshots

| User Interface | Code Output |
| :---: | :---: |
| ![Interface](https://github.com/user-attachments/assets/057464b3-352c-4274-b47d-84f191eccec6) | ![Output](https://github.com/user-attachments/assets/9213f2f5-a981-4643-835b-66c2c111d58e) |

*(Note: Please replace these placeholders with your actual application screenshots to showcase the elegance of Swifont.)*

---

## Usage Instructions

1.  **Initialise** Swifont on your macOS device.
2.  **Drag and drop** your chosen icon font file (e.g., `FontAwesome.ttf`) into the drop zone.
3.  **Review** the identified glyphs and their corresponding names within the application.
4.  **Copy** the generated Swift code and paste it directly into your Xcode project.

### Example Output
```swift
enum MyIconFont: String {
    case home = "\u{e900}"
    case settings = "\u{e901}"
    case user = "\u{e902}"
}
```

## Requirements
macOS 14.0 (Sonoma) or later

Xcode 15.0+ (should you wish to build from source)

## Licence
This project is licensed under the MIT Licence. Please refer to the LICENSE file for further details.

## Author
JK always try to be a good person and good developer.

## Download

[![App Store](https://img.shields.io/badge/App_Store-Coming_Soon-black?style=for-the-badge&logo=apple)](https://apps.apple.com/app/id6757840827)
