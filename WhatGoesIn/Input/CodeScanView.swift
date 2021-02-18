//
//  CodeScanner.swift
//  whatGoesIn
//
//  Created by Daniel Levi-Minzi on 2/5/21.
//

import CodeScanner
import SwiftUI

struct CodeScanView: View {
    public var handleScan: (Result<String, CodeScannerView.ScanError>) -> Void

    var body: some View {
        ZStack { 
            // this is a scanner view built @twostraws (hacking w/ swift) https://github.com/twostraws/CodeScanner
            CodeScannerView(codeTypes: [.code128, .ean13, .ean8], simulatedData: "5449000000996", completion: handleScan)
            
            // code below generates a box for the user to help target the barcode... works well enough for this stage
            GeometryReader { geometry in
               VStack(alignment: .center) {
                   Text("Position the barcode within the frame! \n(or swipe down to dismiss this scanner)")
                    .foregroundColor(Color(UIColor.red).opacity(0.7))
                   Rectangle().fill(Color.clear).frame(width: geometry.size.width * 0.5, height: geometry.size.width * 0.30).overlay(
                                           RoundedRectangle(cornerRadius: 10)
                                               .stroke(
                                                   style: StrokeStyle(
                                                       lineWidth: 1,
                                                       dash: [5]
                                                   )
                                               ).foregroundColor(Color(UIColor.red).opacity(0.7))
                                       )
               }.frame(width: geometry.size.width * 1.0, height: geometry.size.height * 1.0)
            }
        }
    }
}
