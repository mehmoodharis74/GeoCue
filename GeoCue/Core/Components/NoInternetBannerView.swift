//
//  NoInternetBannerView.swift
//  GeoCue
//
//  Created by Haris  on 16/02/2025.
//

import SwiftUI
import SwiftUI

struct NoInternetBannerView: View {
    @ObservedObject var connectivityManager: ConnectivityManager = ConnectivityManager.shared
    var retryAction: () -> Void

    var body: some View {
        HStack {
            Image(systemName: "wifi.exclamationmark")
                .foregroundColor(.white)
            
            Text("No Internet Connection")
                .foregroundColor(.white)
                .font(.subheadline)
            
            Spacer()
            
            if connectivityManager.isRetrying {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
            } else {
                Button(action: retryAction) {
                    Text("Retry")
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.black.opacity(0.3))
                        .cornerRadius(4)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.red)
        .cornerRadius(8)
        .padding([.horizontal, .bottom])
    }
}
