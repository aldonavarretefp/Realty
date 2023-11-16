//
//  TenantHomeView.swift
//  RealEstate
//
//  Created by Aldo Yael Navarrete Zamora on 17/11/23.
//

import SwiftUI

struct TenantHomeView: View {
    @EnvironmentObject var authvm: AuthViewModel
    var body: some View {
        NavigationStack {
            VStack {
                Button("Salir") {
                    authvm.logOut()
                }
            }
            .navigationTitle("Bienvenido, Aldo")
        }
    }
}

#Preview {
    TenantHomeView()
}
