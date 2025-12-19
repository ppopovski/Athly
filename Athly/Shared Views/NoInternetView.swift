//
//  NoInternetView.swift
//  Athly
//
//  Created by Petar Popovski on 22.7.25.
//

import SwiftUI

struct NoInternetView: View {
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "wifi.exclamationmark")
                .font(.customFont(.semiBold, 80))
                .foregroundStyle(.white)

            Text("No Internet Connectivity")
                .font(.customFont(.semiBold, 18))
                .foregroundStyle(.white)

            Text("Please check your internet connection\nto continue using the app.")
                .font(.customFont(.regular, 16))
                .multilineTextAlignment(.center)
                .foregroundStyle(.gray)
                .lineLimit(2)

            HStack {
                Text("Waiting for internet connection...")
                    .font(.customFont(.medium, 16))
                    .background(CustomColor.bgBlack)
                ProgressView()
                    .tint(.white)
            }
            .padding(.top, 10)
            .padding(.vertical, 12)
            .foregroundStyle(.white)

        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(CustomColor.bgBlack)
        .clipShape(.rect(cornerRadius: 24))
    }
}

#Preview {
    NoInternetView()
}

