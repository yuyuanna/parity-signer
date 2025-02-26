//
//  NetworkSelectionSettings.swift
//  Polkadot Vault
//
//  Created by Krzysztof Rodak on 20/12/2022.
//

import SwiftUI

struct NetworkSelectionSettings: View {
    @StateObject var viewModel: ViewModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: 0) {
            NavigationBarView(
                viewModel: NavigationBarViewModel(
                    title: .title(Localizable.Settings.Networks.Label.title.string),
                    leftButtons: [.init(
                        type: .arrow,
                        action: { presentationMode.wrappedValue.dismiss() }
                    )],
                    rightButtons: [.init(type: .empty)],
                    backgroundColor: Asset.backgroundPrimary.swiftUIColor
                )
            )
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(viewModel.networks, id: \.key) {
                        item(for: $0)
                    }
                    HStack(alignment: .center, spacing: 0) {
                        Asset.add.swiftUIImage
                            .foregroundColor(Asset.textAndIconsTertiary.swiftUIColor)
                            .frame(width: Heights.networkLogoInCell, height: Heights.networkLogoInCell)
                            .background(Circle().foregroundColor(Asset.fill12.swiftUIColor))
                            .padding(.trailing, Spacing.small)
                        Text(Localizable.Settings.Networks.Action.add.string)
                            .foregroundColor(Asset.textAndIconsPrimary.swiftUIColor)
                            .font(PrimaryFont.labelL.font)
                        Spacer()
                    }
                    .contentShape(Rectangle())
                    .padding(.horizontal, Spacing.medium)
                    .frame(height: Heights.networkSelectionSettings)
                    .onTapGesture {
                        viewModel.onAddTap()
                    }
                }
            }
            NavigationLink(
                destination: NetworkSettingsDetails(
                    viewModel: .init(
                        networkKey: viewModel.selectedDetailsKey,
                        networkDetails: viewModel.selectedDetails,
                        onCompletion: viewModel.onNetworkDetailsCompletion(_:)
                    )
                )
                .navigationBarHidden(true),
                isActive: $viewModel.isPresentingDetails
            ) { EmptyView() }
        }
        .background(Asset.backgroundPrimary.swiftUIColor)
        .fullScreenModal(
            isPresented: $viewModel.isShowingQRScanner,
            onDismiss: viewModel.onQRScannerDismiss
        ) {
            CameraView(
                viewModel: .init(
                    isPresented: $viewModel.isShowingQRScanner
                )
            )
        }
        .bottomSnackbar(
            viewModel.snackbarViewModel,
            isPresented: $viewModel.isSnackbarPresented
        )
    }

    @ViewBuilder
    func item(for network: MmNetwork) -> some View {
        HStack(alignment: .center, spacing: 0) {
            NetworkLogoIcon(networkName: network.logo)
                .padding(.trailing, Spacing.small)
            Text(network.title.capitalized)
                .foregroundColor(Asset.textAndIconsPrimary.swiftUIColor)
                .font(PrimaryFont.labelL.font)
            Spacer()
            Asset.chevronRight.swiftUIImage
                .frame(width: Sizes.rightChevronContainerSize, height: Sizes.rightChevronContainerSize)
                .foregroundColor(Asset.textAndIconsTertiary.swiftUIColor)
        }
        .contentShape(Rectangle())
        .padding(.horizontal, Spacing.medium)
        .frame(height: Heights.networkSelectionSettings)
        .onTapGesture {
            viewModel.onTap(network)
        }
    }
}

extension NetworkSelectionSettings {
    final class ViewModel: ObservableObject {
        private let cancelBag = CancelBag()
        private let service: ManageNetworksService
        private let networkDetailsService: ManageNetworkDetailsService
        @Published var networks: [MmNetwork] = []
        @Published var selectedDetailsKey: String!
        @Published var selectedDetails: MNetworkDetails!
        @Published var isPresentingDetails = false
        @Published var isShowingQRScanner: Bool = false
        var snackbarViewModel: SnackbarViewModel = .init(title: "")
        @Published var isSnackbarPresented: Bool = false

        init(
            service: ManageNetworksService = ManageNetworksService(),
            networkDetailsService: ManageNetworkDetailsService = ManageNetworkDetailsService()
        ) {
            self.service = service
            self.networkDetailsService = networkDetailsService
            updateNetworks()
            onDetailsDismiss()
        }

        func onTap(_ network: MmNetwork) {
            selectedDetailsKey = network.key
            selectedDetails = networkDetailsService.refreshCurrentNavigationState(network.key)
            isPresentingDetails = true
        }

        func onAddTap() {
            isShowingQRScanner = true
        }

        func onQRScannerDismiss() {
            updateNetworks()
        }

        func onNetworkDetailsCompletion(_ completionAction: NetworkSettingsDetails.OnCompletionAction) {
            switch completionAction {
            case let .networkDeleted(networkTitle):
                snackbarViewModel = .init(
                    title: Localizable.Settings.NetworkDetails.DeleteNetwork.Label
                        .confirmation(networkTitle),
                    style: .warning
                )
                isSnackbarPresented = true
            }
        }
    }
}

private extension NetworkSelectionSettings.ViewModel {
    func onDetailsDismiss() {
        $isPresentingDetails.sink { [weak self] isPresented in
            guard let self = self, !isPresented else { return }
            self.updateNetworks()
        }.store(in: cancelBag)
    }

    func updateNetworks() {
        networks = service.manageNetworks()
    }
}

#if DEBUG
    struct NetworkSelectionSettings_Previews: PreviewProvider {
        static var previews: some View {
            NetworkSelectionSettings(
                viewModel: .init()
            )
        }
    }
#endif
