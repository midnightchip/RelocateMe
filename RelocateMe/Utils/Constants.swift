//
//  Contants.swift
//  RelocateMe
//
//  Created by MidnightChips on 1/11/22.
//

import Foundation

enum SelectedSheet: Identifiable {
    case About, Emulate
    
    var id: Int {
        hashValue
    }
}

let CLLOCATION_BASE = """
<?xml version=\"1.0\" encoding=\"UTF-8\"?>\
<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">\
<plist version=\"1.0\">\
<dict>\
    <key>$archiver</key>\
    <string>NSKeyedArchiver</string>\
    <key>$objects</key>\
    <array>\
        <string>$null</string>\
        <dict>\
            <key>$class</key>\
            <dict>\
                <key>CF$UID</key>\
                <integer>2</integer>\
            </dict>\
            <key>kCLLocationCodingKeyAltitude</key>\
            <real>ALTPLACE</real>\
            <key>kCLLocationCodingKeyCoordinateLatitude</key>\
            <real>LATPLACE</real>\
            <key>kCLLocationCodingKeyCoordinateLongitude</key>\
            <real>LONGPLACE</real>\
            <key>kCLLocationCodingKeyCourse</key>\
            <real>COURSEPLACE</real>\
            <key>kCLLocationCodingKeyHorizontalAccuracy</key>\
            <real>HORZACPLACE</real>\
            <key>kCLLocationCodingKeyLifespan</key>\
            <real>LIFESPAPLACE</real>\
            <key>kCLLocationCodingKeySpeed</key>\
            <real>SPEEDPLACE</real>\
            <key>kCLLocationCodingKeyTimestamp</key>\
            <real>TIMESTAMPPLACE</real>\
            <key>kCLLocationCodingKeyType</key>\
            <integer>TYPEPLACE</integer>\
            <key>kCLLocationCodingKeyVerticalAccuracy</key>\
            <real>VERTACPLACE</real>\
        </dict>\
        <dict>\
            <key>$classes</key>\
            <array>\
                <string>CLLocation</string>\
                <string>NSObject</string>\
            </array>\
            <key>$classname</key>\
            <string>CLLocation</string>\
        </dict>\
    </array>\
    <key>$top</key>\
    <dict>\
        <key>root</key>\
        <dict>\
            <key>CF$UID</key>\
            <integer>1</integer>\
        </dict>\
    </dict>\
    <key>$version</key>\
    <integer>100000</integer>\
</dict>\
</plist>\

"""
