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

import Cocoa

class ConfigureSheetController : NSObject {
    
    var defaultsManager = DefaultsManager()

    @IBOutlet var window: NSWindow?
    @IBOutlet var textColorWell: NSColorWell?
    @IBOutlet var canvasColorWell: NSColorWell?
    @IBOutlet var fadedTextColorWell: NSColorWell?
    @IBOutlet weak var fontDropdown: NSPopUpButton!
    
    override init() {
        super.init()
        let myBundle = Bundle(for: ConfigureSheetController.self)
        myBundle.loadNibNamed("ConfigureSheet", owner: self, topLevelObjects: nil)
        canvasColorWell!.color = defaultsManager.canvasColor
        textColorWell!.color = defaultsManager.textColor
        fadedTextColorWell!.color = defaultsManager.fadedTextColor
        fontDropdown.selectItem(withTitle: defaultsManager.fontName)
    }

    @IBAction func updateDefaults(_ sender: AnyObject) {
        defaultsManager.canvasColor = canvasColorWell!.color
        defaultsManager.textColor = textColorWell!.color
        defaultsManager.fadedTextColor = fadedTextColorWell!.color
        defaultsManager.fontName = fontDropdown.selectedItem!.title
    }
   
    @IBAction func closeConfigureSheet(_ sender: AnyObject) {
        window!.close()
    }

}
