/*
 *  Copyright 2022 Tomasz Brek
 *
 *  Licensed under the Apache License, Version 2.0 (the "License"); you may
 *  not use these files except in compliance with the License. You may obtain
 *  a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 *  WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 *  License for the specific language governing permissions and limitations
 *  under the License.
 */

import ScreenSaver
import AppKit
var tempHour =  Int()
var text = String()
var textColor = NSColor()

let clockDial: Array = ["ITLISASAMPM",
                        "ACQUARTERDC",
                        "TWENTYFIVEX",
                        "HALFSTENFTO",
                        "PASTERUNINE",
                        "ONESIXTHREE",
                        "FOURFIVETWO",
                        "EIGHTELEVEN",
                        "SEVENTWELVE",
                        "TENSEOCLOCK",
                        "  . . . .  "]
var clockCover: Array = ["11011000000",
                         "00000000000",
                         "00000000000",
                         "00000000000",
                         "00000000000",
                         "00000000000",
                         "00000000000",
                         "00000000000",
                         "00000000000",
                         "00000000000",
                         "00000000000",
                         "00000000000"]

let screenSize: CGRect = NSScreen.main!.frame
let height = screenSize.height
let width =  screenSize.width
var font = NSFont()
let textRectHeight = height/11
let textRectWidth = textRectHeight*0.8
var textRect: NSRect = NSMakeRect(width/2, height/2, 125, 60)

public class QLockView : ScreenSaverView {
    
    var defaultsManager: DefaultsManager = DefaultsManager()
    lazy var sheetController: ConfigureSheetController = ConfigureSheetController()
    
    var canvasColor: NSColor?
    var textColor: NSColor?
    var fadedTextColor: NSColor?
    var tempTextColor: NSColor?
    var fontName: String?
    
    override init?(frame: NSRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview)
        animationTimeInterval = 1.0 / 60.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public var hasConfigureSheet: Bool {
        return true
    }
    
    override public var configureSheet: NSWindow? {
        return sheetController.window
    }

    override public func startAnimation() {
        super.startAnimation()
        cacheColors()
        needsDisplay = true
    }
    
    override public func stopAnimation() {
        super.stopAnimation()
    }
    
    override public func draw(_ rect: NSRect) {
        super.draw(rect)
        cacheColors()
        drawBackground()
        drawText()
     }
    
    override public func animateOneFrame() {
        needsDisplay = true
    }
    
    func cacheColors() {
        canvasColor = defaultsManager.canvasColor
        textColor = defaultsManager.textColor
        fadedTextColor = defaultsManager.fadedTextColor
        fontName = defaultsManager.fontName
    }
    
    func drawBackground() {
        let bPath:NSBezierPath = NSBezierPath(rect: bounds)
        canvasColor!.set()
        bPath.fill()
    }

    private func drawText() {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        
        for i in 1...10 {
            clockCover[i] = "00000000000"
        }
        
        switch minutes {
        case 0..<5:
            clockCover[9] = "00000111111"
            tempHour = hour
        case 5..<10:
            clockCover[2] = "00000011110"
            clockCover[4] = "11110000000"
            tempHour = hour
        case 10..<15:
            clockCover[3] = "00000111000"
            clockCover[4] = "11110000000"
            tempHour = hour
        case 15..<20:
            clockCover[1] = "00111111100"
            clockCover[4] = "11110000000"
            tempHour = hour
        case 20..<25:
            clockCover[2] = "11111100000"
            clockCover[4] = "11110000000"
            tempHour = hour
        case 25..<30:
            clockCover[2] = "11111111110"
            clockCover[4] = "11110000000"
            tempHour = hour
        case 30..<35:
            clockCover[3] = "11110000000"
            clockCover[4] = "11110000000"
            tempHour = hour
        case 35..<40:
            clockCover[2] = "11111111110"
            clockCover[3] = "00000000011"
            tempHour = hour + 1
        case 40..<45:
            clockCover[2] = "11111100000"
            clockCover[3] = "00000000011"
            tempHour = hour + 1
        case 45..<50:
            clockCover[1] = "00111111100"
            clockCover[3] = "00000000011"
            tempHour = hour + 1
        case 50..<55:
            clockCover[3] = "00000111011"
            tempHour = hour + 1
        case 55..<60:
            clockCover[2] = "00000011110"
            clockCover[3] = "00000000011"
            tempHour = hour + 1
        default:
            clockCover[0] = "11011000000"
        }
        
        clockCover[10] = clockCover10(minutes: minutes)
        
        switch tempHour {
        case 1,13:
            clockCover[5] = "11100000000"
        case 2,14:
            clockCover[6] = "00000000111"
        case 3,15:
            clockCover[5] = "00000011111"
        case 4,16:
            clockCover[6] = "11110000000"
        case 5,17:
            clockCover[6] = "00001111000"
        case 6,18:
            clockCover[5] = "00011100000"
        case 7,19:
            clockCover[8] = "11111000000"
        case 8,20:
            clockCover[7] = "11111000000"
        case 9,21:
            if case 1 ... 34 = minutes {
                clockCover[4] = "11110001111"
            } else {
                clockCover[4] = "00000001111"
            }
        case 10,22:
            clockCover[9] = "11100000000"
        case 11,23:
            clockCover[7] = "00000111111"
        case 12,0:
            clockCover[8] = "00000111111"
        default:
            clockCover[0] = "11011000000"
        }
        
        for row in 0...10 {
            drawRow(row: row, string: clockDial[row])
        }
    }
    
    func clockCover10(minutes: Int) -> String {
        switch minutes % 5 {
        case 1:
            return "00100000000"
        case 2:
            return "00101000000"
        case 3:
            return "00101010000"
        case 4:
            return "00101010100"
        default:
            return "00000000000"
        }
    }
    
    private func drawRow(row: Int, string: String) {
        for column in 0...10 {
            textRect = NSMakeRect(CGFloat(column+1)*textRectWidth+((width-height)/2)+textRectWidth/2, height-(CGFloat(row+1)*textRectHeight), textRectWidth, textRectHeight)
            
         
            font = row < 10 ? NSFont(name: fontName!, size: height/12)! : NSFont(name: "Monaco", size: height/22)!
            
            let index = string.index(string.startIndex, offsetBy: column)
            
            if String(clockCover[row][index]) == "0" {
                tempTextColor = fadedTextColor?.withAlphaComponent(1)
            } else {
                tempTextColor = textColor?.withAlphaComponent(1)
            }
            
            let textStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
            textStyle.alignment = NSTextAlignment.center
            let textFontAttributes = [
                 NSAttributedString.Key.font: font,
                 NSAttributedString.Key.backgroundColor: canvasColor,
                 NSAttributedString.Key.foregroundColor: tempTextColor,
                 NSAttributedString.Key.paragraphStyle: textStyle]
            
            text = String(string[index])
            text.draw(in: NSOffsetRect(textRect, 0, 0), withAttributes: textFontAttributes as [NSAttributedString.Key : Any])
        }
    }
    
}
    
