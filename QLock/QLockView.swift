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
    
    // MARK: - Initialization
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
    
    // MARK: - Lifecycle
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
        case 0,1,2,3,4:
            clockCover[9] = "00000111111"
            tempHour = hour
        case 5,6,7,8,9:
            clockCover[2] = "00000011110"
            clockCover[4] = "11110000000"
            tempHour = hour
        case 10,11,12,13,14:
            clockCover[3] = "00000111000"
            clockCover[4] = "11110000000"
            tempHour = hour
        case 15,16,17,18,19:
            clockCover[1] = "00111111100"
            clockCover[4] = "11110000000"
            tempHour = hour
        case 20,21,22,23,24:
            clockCover[2] = "11111100000"
            clockCover[4] = "11110000000"
            tempHour = hour
        case 25,26,27,28,29:
            clockCover[2] = "11111111110"
            clockCover[4] = "11110000000"
            tempHour = hour
        case 30,31,32,33,34:
            clockCover[3] = "11110000000"
            clockCover[4] = "11110000000"
            tempHour = hour
        case 35,36,37,38,39:
            clockCover[2] = "11111111110"
            clockCover[3] = "00000000011"
            tempHour = hour + 1
        case 40,41,42,43,44:
            clockCover[2] = "11111100000"
            clockCover[3] = "00000000011"
            tempHour = hour + 1
        case 45,46,47,48,49:
            clockCover[1] = "00111111100"
            clockCover[3] = "00000000011"
            tempHour = hour + 1
        case 50,51,52,53,54:
            clockCover[3] = "00000111011"
            tempHour = hour + 1
        case 55,56,57,58,59:
            clockCover[2] = "00000011110"
            clockCover[3] = "00000000011"
            tempHour = hour + 1
        default:
            clockCover[0] = "11011000000"
        }
        
        switch minutes {
        case 1,6,11,16,21,26,31,36,41,46,51,56:
            clockCover[10] = "00100000000"
        case 2,7,12,17,22,27,32,37,42,47,52,57:
            clockCover[10] = "00101000000"
        case 3,8,13,18,23,28,33,38,43,48,53,58:
            clockCover[10] = "00101010000"
        case 4,9,14,19,24,29,34,39,44,49,54,59:
            clockCover[10] = "00101010100"
        default:
            clockCover[10] = "00000000000"
        }
        
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
        case 11:
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
    

