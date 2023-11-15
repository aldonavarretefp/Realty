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
        
        var localizedName: LocalizedStringKey { LocalizedStringKey(rawValue) }
    }
    
    @Published var fileTypeSelection: FileType = .pdf
    @Published var startDate: Date = .now
    @Published var endDate: Date = .now
    @Published var isActive: Bool = false
    @Published var data: Data? = nil
    @Published var isLoading: Bool = false
    
    init() {}
    
    func loadPDF() {
        if data != nil {
            self.data = data
            return
        }
        Task {
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
                    "landlordName": "Luigi",
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
                DispatchQueue.main.async {
                    self.data = pdfData
                    self.isLoading = false
                }
            } catch {
                // Handle the error appropriately
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
        }
    }
}

struct ReportGenerationView: View {
    @StateObject var vm: ReportGenerationViewModel = ReportGenerationViewModel()
    
    var body: some View {
        VStack {
            Picker("File Selection", selection: $vm.fileTypeSelection) {
                ForEach(ReportGenerationViewModel.FileType.allCases, id: \.rawValue) { item in
                    Text(item.rawValue).tag(item)
                }
            }
            .pickerStyle(.segmented)
            .padding(.bottom, 20)
            HStack {
                VStack(alignment: .center) {
                    Text("Starting on")
                        .padding(.bottom, 30)
                        .foregroundStyle(.opacity(0.7))
                    DatePicker("", selection: $vm.startDate, displayedComponents: .date)
                        .frame(width: 120, height: 100)
                }
                .frame(width: 190, height: 250)
                
                VStack(alignment: .center) {
                    Text("Ending on")
                        .padding(.bottom, 30)
                        .foregroundStyle(.opacity(0.7))
                    DatePicker("", selection: $vm.endDate, displayedComponents: .date)
                        .frame(width: 120, height: 100)
                }
                .frame(width: 190, height: 250)
            }
            .frame(height: 250)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.secondary.opacity(0.1).shadow(.drop(radius: 1)))
            )
            Spacer()
            if !vm.isLoading {
                Button(action: {
                    vm.isLoading = true
                    Task {
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
                                "landlordName": "Luigi",
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
                            
                            print("Succesfully fetched PDF.")
                            vm.data = pdfData
                            
                            // Handle the received PDF data, such as saving to a file or displaying
                        } catch let error {
                            print(error.localizedDescription)
                        }
                        vm.isActive = true
                        vm.isLoading = false
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
                .navigationDestination(isPresented: $vm.isActive) {
                    if let data = vm.data, let url = savePDFToFile(data: data) {
                        PDFView(data: vm.data!)
                            .environmentObject(vm)
                            .navigationTitle("Your statement")
                            .navigationBarBackButtonHidden(true)
                            .navigationBarTitleDisplayMode(.inline)
                            .toolbar {
                                ToolbarItem(placement: .navigationBarLeading) {
                                    Button {
                                        
                                    } label: {
                                        Image(systemName: "chevron.backward")
                                    }
                                }
                                
                                ToolbarItem(placement: .confirmationAction) {
                                    
                                    ShareLink(item: url)
                                    
                                    
                                }
                            }
                            .onAppear(perform: {
                                vm.loadPDF()
                            })
                    }
                }
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
    Group {
        ReportGenerationView()
            .preferredColorScheme(.dark)
        ReportGenerationView()
            .preferredColorScheme(.light)
    }
    
}