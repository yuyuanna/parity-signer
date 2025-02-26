//
//  OnboardingScreenshotsView.swift
//  PolkadotVault
//
//  Created by Krzysztof Rodak on 14/02/2023.
//

import SwiftUI

struct OnboardingScreenshotsView: View {
    @StateObject var viewModel: ViewModel

    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    VStack(alignment: .center, spacing: 0) {
                        Localizable.Onboarding.Screenshots.Label.title.text
                            .font(PrimaryFont.titleL.font)
                            .foregroundColor(Asset.textAndIconsPrimary.swiftUIColor)
                            .fixedSize(horizontal: false, vertical: true)
                            .multilineTextAlignment(.center)
                            .padding(.top, Spacing.extraExtraLarge)
                            .padding(.horizontal, Spacing.large)
                        Localizable.Onboarding.Screenshots.Label.content.text
                            .font(PrimaryFont.bodyM.font)
                            .foregroundColor(Asset.textAndIconsTertiary.swiftUIColor)
                            .fixedSize(horizontal: false, vertical: true)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, Spacing.extraSmall)
                            .padding(.vertical, Spacing.medium)
                        Spacer()
                            .frame(minHeight: Spacing.flexibleSmallComponentSpacer)
                        if viewModel.isCheckboxSelected {
                            Asset.screenshotConfirmed.swiftUIImage
                        } else {
                            Asset.screenshotUnconfirmed
                                .swiftUIImage
                                .padding(.bottom, Spacing.screenshotIconCompensation)
                        }
                        Spacer()
                            .frame(minHeight: Spacing.flexibleSmallComponentSpacer)
                        HStack {
                            Spacer()
                        }
                    }
                    HStack(spacing: Spacing.medium) {
                        if viewModel.isCheckboxSelected {
                            Asset.checkboxChecked.swiftUIImage
                                .foregroundColor(Asset.accentPink300.swiftUIColor)
                        } else {
                            Asset.checkboxEmpty.swiftUIImage
                                .foregroundColor(Asset.textAndIconsTertiary.swiftUIColor)
                        }
                        Localizable.Onboarding.Screenshots.Label.confirmation.text
                            .foregroundColor(Asset.textAndIconsPrimary.swiftUIColor)
                            .font(PrimaryFont.bodyL.font)
                            .multilineTextAlignment(.leading)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        viewModel.toggleCheckbox()
                    }
                    .padding(.horizontal, Spacing.extraLarge)
                    .padding(.bottom, Spacing.extraSmall)
                    PrimaryButton(
                        action: viewModel.onDoneTap,
                        text: Localizable.Onboarding.Screenshots.Action.next.key,
                        style: .primary(isDisabled: $viewModel.isActionDisabled)
                    )
                    .padding(Spacing.large)
                }
                .frame(
                    minWidth: geo.size.width,
                    minHeight: geo.size.height
                )
            }
            .background(Asset.backgroundSystem.swiftUIColor)
        }
    }
}

extension OnboardingScreenshotsView {
    final class ViewModel: ObservableObject {
        @Published var isCheckboxSelected: Bool = false
        @Published var isActionDisabled: Bool = true

        private let onNextTap: () -> Void

        init(
            onNextTap: @escaping () -> Void
        ) {
            self.onNextTap = onNextTap
        }

        func onDoneTap() {
            onNextTap()
        }

        func toggleCheckbox() {
            isCheckboxSelected.toggle()
            isActionDisabled = !isCheckboxSelected
        }
    }
}

#if DEBUG
    struct OnboardingScreenshotsView_Previews: PreviewProvider {
        static var previews: some View {
            OnboardingScreenshotsView(
                viewModel: .init(onNextTap: {})
            )
        }
    }
#endif
