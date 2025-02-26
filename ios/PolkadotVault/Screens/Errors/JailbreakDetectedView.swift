//
//  JailbreakDetectedView.swift
//  Polkadot Vault
//
//  Created by Krzysztof Rodak on 26/01/2023.
//

import SwiftUI

struct JailbreakDetectedView: View {
    var body: some View {
        VStack(spacing: Spacing.small) {
            Spacer()
            Asset.jailbreak.swiftUIImage
                .padding(.bottom, Spacing.small)
            Localizable.Error.Jailbreak.Label.title.text
                .font(PrimaryFont.titleL.font)
                .foregroundColor(Asset.textAndIconsPrimary.swiftUIColor)
                .padding(.horizontal, Spacing.x3Large)
            Localizable.Error.Jailbreak.Label.subtitle.text
                .font(PrimaryFont.bodyL.font)
                .foregroundColor(Asset.textAndIconsTertiary.swiftUIColor)
                .padding(.horizontal, Spacing.extraExtraLarge)
            Spacer()
        }
        .multilineTextAlignment(.center)
        .background(Asset.backgroundPrimary.swiftUIColor)
    }
}

#if DEBUG
    struct JailbreakDetectedView_Previews: PreviewProvider {
        static var previews: some View {
            JailbreakDetectedView()
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
        }
    }
#endif
