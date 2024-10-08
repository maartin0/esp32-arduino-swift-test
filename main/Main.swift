//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift open source project
//
// Copyright (c) 2024 Apple Inc. and the Swift project authors.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
//
//===----------------------------------------------------------------------===//

//The code will blink an LED on GPIO8. To change the pin, modify Led(gpioPin: 8)
@_cdecl("app_main")
func app_main() {
    print("Hello from Swift on ESP32-C6!")

    let numSsid = WiFi.scanNetworks()
    print("Number of networks discovered: ")
    print(numSsid)
}
