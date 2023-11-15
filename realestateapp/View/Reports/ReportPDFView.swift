//
//  ReportPDFView.swift
//  RealEstate
//
//  Created by Aldo Yael Navarrete Zamora on 14/11/23.
//

import SwiftUI

struct ReportPDFView: View {
    @EnvironmentObject var router: Router
    @StateObject var vm: ReportGenerationViewModel = ReportGenerationViewModel()
    
    var body: some View {
        
        if !vm.isLoading {
            if let d = vm.data {
                PDFView(data: d)
                    .onAppear(perform: {
                        vm.loadPDF()
                    })
                    .navigationTitle("Your statement")
                    .navigationBarBackButtonHidden()
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button {
                                router.navigateBack()
                            } label: {
                                Image(systemName: "chevron.backward")
                            }
                        }
                        if let url = savePDFToFile(data: d) {
                            ToolbarItem(placement: .confirmationAction) {
                                ShareLink(item: url)
                            }
                        }
                    }
            }
        } else {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .primary))
                .onAppear(perform: {
                    vm.loadPDF()
                })
        }
        
        
    }
    
    func savePDFToFile(data: Data) -> URL? {
        let temporaryDirectoryURL = FileManager.default.temporaryDirectory
        let pdfFileName = temporaryDirectoryURL.appendingPathComponent("report.pdf")
        do {
            try data.write(to: pdfFileName)
            return pdfFileName
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}

#Preview {
    ReportPDFView()
        .environmentObject(Router())
}
