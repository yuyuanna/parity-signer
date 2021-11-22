//
//  FooterBlock.swift
//  NativeSigner
//
//  Created by Alexander Slesarev on 21.10.2021.
//

import SwiftUI

struct FooterBlock: View {
    @EnvironmentObject var data: SignerDataModel
    var body: some View {
        if data.signerScreen == .keys && data.keyManagerModal == .none {
            if data.getMultiSelectionMode() {
                MultiselectBottomControl()
            } else {
                VStack {
                    SearchKeys().padding(.bottom, 8)
                    Footer()
                }
            }
        } else {
            Footer()
        }
    }
}

/*
 struct FooterBlock_Previews: PreviewProvider {
 static var previews: some View {
 FooterBlock()
 }
 }
 */
