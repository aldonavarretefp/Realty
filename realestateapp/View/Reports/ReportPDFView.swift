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
    @State var data: Data
    
    init(data: Data) {
        self.data = data
    }
    
    var body: some View {
        if !vm.isLoading {
            PDFView(data: data)
                .onAppear(perform: {
                    Task {
                        if let pdfData = await vm.loadPDF() {
                            data = pdfData
                        }
                    }
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
                    if let url = savePDFToFile(data: data) {
                        ToolbarItem(placement: .confirmationAction) {
                            ShareLink(item: url)
                        }
                    }
                }
            
        } else {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .primary))
                .onAppear(perform: {
                    Task {
                        if let pdfData = await vm.loadPDF() {
                            data = pdfData
                        }
                    }
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
    ReportPDFView(data: Data())
        .environmentObject(Router())
}
