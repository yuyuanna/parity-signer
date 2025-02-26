//
//  OnboardingAirgapView.swift
//  NativeSigner
//
//  Created by Krzysztof Rodak on 15/02/2023.
//

import SwiftUI

struct OnboardingAirgapView: View {
    @StateObject var viewModel: ViewModel

    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack(alignment: .center, spacing: 0) {
                    // Header text
                    Localizable.Onboarding.Airgap.Label.title.text
                        .font(PrimaryFont.titleL.font)
                        .foregroundColor(Asset.textAndIconsPrimary.swiftUIColor)
                        .multilineTextAlignment(.center)
                        .padding(.top, Spacing.extraLarge)
                        .padding(.horizontal, Spacing.large)
                    Localizable.Onboarding.Airgap.Label.content.text
                        .font(PrimaryFont.bodyM.font)
                        .foregroundColor(Asset.textAndIconsTertiary.swiftUIColor)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, Spacing.medium)
                        .padding(.vertical, Spacing.medium)
                    // Airgap connectivity
                    VStack(spacing: 0) {
                        VStack(alignment: .leading, spacing: 0) {
                            cell(.aiplaneMode, isChecked: viewModel.isAirplaneModeChecked)
                                .padding(.bottom, Spacing.small)
                            Divider()
                            cell(.wifi, isChecked: viewModel.isWifiChecked)
                                .padding(.top, Spacing.small)
                        }
                        .padding(Spacing.medium)
                    }
                    .strokeContainerBackground()
                    .padding(.horizontal, Spacing.medium)
                    .padding(.vertical, Spacing.extraSmall)
                    // Cables connectivity
                    VStack(spacing: 0) {
                        VStack(alignment: .leading, spacing: 0) {
                            HStack(alignment: .center, spacing: Spacing.large) {
                                Asset.airgapCables.swiftUIImage
                                    .padding(.leading, Spacing.extraSmall)
                                    .foregroundColor(Asset.textAndIconsTertiary.swiftUIColor)
                                Localizable.Onboarding.Airgap.Label.cables.text
                                    .foregroundColor(Asset.textAndIconsTertiary.swiftUIColor)
                                    .font(PrimaryFont.bodyL.font)
                            }
                            .padding(.bottom, Spacing.medium)
                            Divider()
                            HStack(alignment: .center, spacing: Spacing.large) {
                                Group {
                                    if viewModel.isCableCheckBoxSelected {
                                        Asset.checkboxChecked.swiftUIImage
                                            .foregroundColor(Asset.accentPink300.swiftUIColor)
                                    } else {
                                        Asset.checkboxEmpty.swiftUIImage
                                            .foregroundColor(Asset.textAndIconsPrimary.swiftUIColor)
                                    }
                                }
                                .padding(.leading, Spacing.extraSmall)
                                Localizable.Onboarding.Airgap.Label.Cables.confirmation.text
                                    .multilineTextAlignment(.leading)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .foregroundColor(Asset.textAndIconsPrimary.swiftUIColor)
                                    .font(PrimaryFont.bodyL.font)
                            }
                            .padding(.top, Spacing.medium)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                viewModel.toggleCheckbox()
                            }
                        }
                        .padding(Spacing.medium)
                    }
                    .strokeContainerBackground()
                    .padding(.horizontal, Spacing.medium)
                    .padding(.vertical, Spacing.extraSmall)
                    Spacer()
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

    @ViewBuilder
    func cell(_ component: AirgapComponent, isChecked: Bool) -> some View {
        HStack(alignment: .center, spacing: Spacing.medium) {
            Group {
                isChecked ? component.checkedIcon : component.uncheckedIcon
            }
            Text(component.title)
                .foregroundColor(isChecked ? component.checkedForegroundColor : component.uncheckedForegroundColor)
                .font(PrimaryFont.bodyL.font)
        }
    }
}

extension OnboardingAirgapView {
    struct AirgapComponentStatus: Equatable, Hashable {
        let component: AirgapComponent
        let isChecked: Bool
    }

    final class ViewModel: ObservableObject {
        @Published var isCableCheckBoxSelected: Bool = false
        @Published var isActionDisabled: Bool = true
        @Published var isAirplaneModeChecked: Bool = false
        @Published var isWifiChecked: Bool = false
        private let airgapMediator: AirgapMediating
        private let onNextTap: () -> Void

        init(
            airgapMediator: AirgapMediating = AirgapMediatorAssembler().assemble(),
            onNextTap: @escaping () -> Void
        ) {
            self.airgapMediator = airgapMediator
            self.onNextTap = onNextTap
            subscribeToUpdates()
        }

        func subscribeToUpdates() {
            airgapMediator.startMonitoringAirgap { [weak self] isAirplaneModeOn, isWifiOn in
                self?.isAirplaneModeChecked = isAirplaneModeOn
                self?.isWifiChecked = !isWifiOn
                self?.updateActionState()
            }
        }

        func onDoneTap() {
            onNextTap()
        }

        func toggleCheckbox() {
            isCableCheckBoxSelected.toggle()
            updateActionState()
        }

        private func updateActionState() {
            isActionDisabled = !isCableCheckBoxSelected || !isWifiChecked || !isAirplaneModeChecked
        }
    }
}

#if DEBUG
    struct OnboardingAirgapView_Previews: PreviewProvider {
        static var previews: some View {
            OnboardingAirgapView(
                viewModel: .init(onNextTap: {})
            )
            .preferredColorScheme(.dark)
        }
    }
#endif
