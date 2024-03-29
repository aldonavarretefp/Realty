//
//  ReportGenerationView.swift
//  RealEstate
//
//  Created by Aldo Yael Navarrete Zamora on 14/11/23.
//

import SwiftUI

class ReportGenerationViewModel: ObservableObject {
    enum FileType: String, Equatable, CaseIterable {
        case pdf  = "PDF"
        case excel = "Excel"
    }
    
    @Published var fileTypeSelection: FileType = .pdf
    @Published var startDate: Date = .now
    @Published var endDate: Date = .now
    @Published var isActive: Bool = false
    @Published var data: Data? = nil
    @Published var isLoading: Bool = false
    @EnvironmentObject var router: Router
    
    init() {}
    
    func loadPDF() async -> Data? {
        isLoading = true
        let cacheKey = "\(startDate)_\(endDate)_\(fileTypeSelection.rawValue)"
        if let cachedData = UserDefaults.standard.data(forKey: cacheKey) {
            print(cachedData)
            self.data = cachedData
            isLoading = false
            return nil
        }
        
        do {
            let transaction: [String: Any] = [
                "date": "2023-01-01",
                "description": "January Rent",
                "category": "Rental Income",
                "income": 1200.00,
                "expense": 0.00,
                "balance": 1200.00
            ]
            let requestBody: [String: Any] = [
                "landlordName": "Miami",
                "landlordSurname": "Cirillo",
                "landlordAddress": [
                    "addrStreet": "Leannon Divide",
                    "addrCity": "Kansasdfasdfsaas",
                    "addrState": "Port Russ",
                    "addrPostalCode": "01adsfas184"
                ],
                "landlordTransactions": [
                    transaction
                ]
            ]
            let pdfData = try await PDFManager.shared.fetchPDF(from: "https://restful-pdf-api-generator.onrender.com/api/v1/generate", with: requestBody)
            await MainActor.run {
                UserDefaults.standard.set(pdfData, forKey: cacheKey)
                self.data = pdfData
                self.isLoading = false
            }
            return pdfData
        } catch {
            // Handle the error appropriately
            await MainActor.run {
                self.isLoading = false
            }
            return nil
        }
        
    }
}

struct ReportGenerationView: View {
    @StateObject var vm: ReportGenerationViewModel = ReportGenerationViewModel()
    @EnvironmentObject var router: Router
    @Namespace var selectedItemBackground
    
    @ViewBuilder
    func CustomPicker(selection: Binding<ReportGenerationViewModel.FileType>, options: [ReportGenerationViewModel.FileType]) -> some View {
        VStack {
            HStack {
                ForEach(options, id: \.rawValue) { option in
                    Text(option.rawValue)
                        .font(.footnote)
                        .frame(maxWidth: .infinity)
                        .padding(8)
                        .bold()
                        .clipShape(Capsule())
                        .foregroundColor(selection.wrappedValue == option ? .white : .primary)
                        .background(selection.wrappedValue == option ?
                                    Capsule().fill(.secondary.opacity(0.4))
                            .matchedGeometryEffect(id: "selectedItemBackground", in: selectedItemBackground) :
                                        nil
                        )
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                selection.wrappedValue = option
                            }
                        }
                        .accessibilityLabel(Text("Select \(option.rawValue)"))
                        .accessibilityHint(Text("Taps to select \(option.rawValue) file type"))
                    
                }
            }
            .frame(maxWidth: .infinity)
            .background(.secondary.opacity(0.2))
            .clipShape(Capsule())
        }
        .padding(.vertical, 10)
    }
    var body: some View {
        VStack {
            CustomPicker(selection: $vm.fileTypeSelection, options: ReportGenerationViewModel.FileType.allCases)
                .accessibilityLabel(Text("File type picker"))
            HStack {
                Group {
                    VStack(alignment: .center) {
                        Text("Starting on")
                            .foregroundStyle(.secondary.opacity(0.6))
                        
                        DatePicker("", selection: $vm.startDate, displayedComponents: .date)
                            .frame(width: 120, height: 100)
                    }
                    VStack(alignment: .center) {
                        Text("Ending on")
                            .foregroundStyle(.secondary.opacity(0.6))
                        DatePicker("", selection: $vm.endDate, displayedComponents: .date)
                            .frame(width: 120, height: 100)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(height: 100)
            .padding(.vertical, 30)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.secondary.opacity(0.15).shadow(.drop(radius: 5)))
            )
            Spacer()
            if !vm.isLoading {
                Button(action: {
                    Task {
                        if let pdfData = await vm.loadPDF() {
                            router.navigate(to: .pdfReportView(data: pdfData))
                        }
                    }
                }, label: {
                    Text("Generate")
                        .bold()
                        .frame(maxWidth: .infinity)
                })
                .padding()
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .background(.blue)
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .bold()
            } else {
                ZStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .frame(width: 20, height: 20)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(.blue)
                .clipShape(RoundedRectangle(cornerRadius: 25))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding()
        .navigationTitle("Statement")
        
    }
}

#Preview {
    Group {
        ReportGenerationView()
            .preferredColorScheme(.dark)
        ReportGenerationView()
            .preferredColorScheme(.light)
    }
    .previewLayout(.sizeThatFits)
    
}
