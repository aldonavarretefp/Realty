//
//  FinanzasView.swift
//  RealEstate
//
//  Created by Aldo Navarrete on 21/12/22.
//

import SwiftUI
import Charts

struct FinanzasView: View {
    
    @EnvironmentObject private var authModel: AuthViewModel
    
    @ObservedObject var router: Router = Router()
    
    @State private var isSheetShowing: Bool = false
    
    @State private var transactions: [Transaction] = []
    @State private var transactionsFilteredArr: [Transaction] = [
    ]
    @State private var selectedTime: Time = .day
    @State private var chartUnitXAxis: Calendar.Component = .month
    @State private var fromDate: Date = Calendar.current.date(byAdding: .year, value: -1, to: Date()) ?? Date() {
        willSet {
            if newValue > untilDate {
                untilDate = fromDate
            }
        }
    }
    @State private var untilDate = Date() {
        willSet {
            if newValue < fromDate {
                fromDate = untilDate
            }
        }
    }
    
    private var totalValue: Double {
        transactionsFilteredArr.reduce(0.0) { partialResult, item in
            item.income + partialResult
        }
    }
    enum Time: String, CaseIterable, Identifiable {
        var id: Self { self }
        case day = "Diario", month = "Mensual", week = "Semanal", year = "Anual", custom = "Personalizado"
    }
    
    private let columns: [GridItem] = [
        GridItem(.adaptive(minimum: 140)),
        GridItem(.adaptive(minimum: 140)),
    ]
    
    var body: some View {
        NavigationStack(path: $router.navPath) {
            ScrollView(showsIndicators: false) {
                timeLapsePicker
                if selectedTime == .custom {
                    gridDatePicker
                }
                ChartViewAPI()
                TransactionView(transactionsFilteredArr)
            }
            .padding()
            .onChange(of: selectedTime, perform: loadData)
            .onChange(of: fromDate, perform: filterDataFrom)
            .onChange(of: untilDate, perform: filterDataUntil)
            .task {
                loadTransactions()
            }
            .onAppear(perform: loadTransactions)
            .navigationBarTitle("Tus finanzas")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: {
                            isSheetShowing.toggle()
                        }, label: {
                            Label("Agregar", systemImage: "plus")
                        })
                        Button(action: {
                            router.navigate(to: .generateReportsView)
                        }, label: {
                            Label("Tu balance", systemImage: "doc.fill")
                        })
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20)
                            .padding(1)
                            .background(.green.opacity(0.1))
                            .clipShape(Circle())
                            .foregroundStyle(.green)
                        
                    }
                    .navigationDestination(for: Router.Destination.self) { destination in
                        switch destination {
                        case .generateReportsView:
                            ReportGenerationView()
                        case .pdfReportView(let data):
                            ReportPDFView(data: data)
                        }
                    }
                }
                
            }
            .sheet(isPresented: $isSheetShowing) {
                NewTransactionView(transactions: $transactions)
            }
        }
        .environmentObject(router)
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func loadData(_ newValue: Time) -> Void {
        let today = Date(), todayCalendar = Calendar.current
        switch selectedTime {
        case .day:
            guard let aDayAgo = todayCalendar.date(byAdding: .day, value: -1, to: Date()) else { return }
            fromDate = aDayAgo
            untilDate = today
            chartUnitXAxis = .day
        case .month:
            guard let aMonthAgo = todayCalendar.date(byAdding: .month, value: -1, to: Date()) else { return }
            fromDate = aMonthAgo
            untilDate = today
            chartUnitXAxis = .weekOfMonth
        case .week:
            guard let aWeekAgo = todayCalendar.date(byAdding: .day, value: -7, to: Date()) else { return }
            fromDate = aWeekAgo
            untilDate = today
            chartUnitXAxis = .weekday
        case .year:
            guard let aYearAgo = todayCalendar.date(byAdding: .year, value: -1, to: Date()) else { return }
            fromDate = aYearAgo
            untilDate = today
            chartUnitXAxis = .year
        case .custom:
            chartUnitXAxis = .year
        }
    }
    
    func filterDataFrom(_ newValue: Date) -> Void {
        fromDate = newValue
        transactionsFilteredArr = transactions.filter({
            let dateRange = (fromDate ... untilDate)
            return dateRange.contains($0.date)
        })
    }
    
    func filterDataUntil(_ newValue: Date) -> Void {
        untilDate = newValue
        transactionsFilteredArr = transactions.filter({
            let dateRange = (fromDate...untilDate)
            return dateRange.contains($0.date)
        })
    }
    
    func loadTransactions() -> Void {
        filterDataUntil(Date.now)
        authModel.fetchTransactions({ transactions in
            self.transactions = transactions
        })
    }
}

extension FinanzasView {
    
    var timeLapsePicker: some View {
        Picker("Timelapse", selection: $selectedTime) {
            ForEach(Time.allCases) { time in
                Text(time.rawValue.capitalized)
            }
        }
        .pickerStyle(.segmented)
        .padding()
    }
    
    var gridDatePicker: some View {
        LazyVGrid(columns: columns) {
            VStack(spacing: 5) {
                Text("De")
                DatePicker("", selection: $fromDate, in: ...Date.now, displayedComponents: [.date])
                    .fixedSize()
                    .environment(\.colorScheme, .dark)
                    .colorMultiply(.green)
            }
            VStack(spacing: 5) {
                Text("Hasta")
                DatePicker("", selection: $untilDate, in: ...Date.now, displayedComponents: [.date])
                    .fixedSize()
                    .environment(\.colorScheme, .dark)
                    .colorMultiply(.green)
            }
        }
        
    }
    
    var earningChartTitle: some View {
        Text("Ganancias totales")
            .font(.title)
            .fontWeight(.bold)
            .frame(
                minWidth: 0,
                maxWidth: .infinity,
                alignment: .leading
            )
            .padding(.leading, 20)
    }
    
    var earningChartNumber: some View {
        Text(totalValue.stringFormat)
            .font(.largeTitle)
            .bold()
            .font(.title)
            .frame(
                minWidth: 0,
                maxWidth: .infinity,
                alignment: .leading
            )
            .foregroundColor(.green)
            .padding(.leading, 20)
    }
}

struct ChartView: View {
    
    var data: [Transaction]
    
    @Binding var chartUnitXAxis: Calendar.Component
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {}, label: {
                    Text("Button")
                })
            }
            
            Chart {
                ForEach(data) {
                    BarMark (
                        x: .value("Mes", $0.date, unit: chartUnitXAxis),
                        y: .value("Ingresos", $0.income)
                    )

                }
            }
            .foregroundStyle(.linearGradient(colors: [.blue, .purple], startPoint: .top, endPoint: .bottom))
            
        }
        .frame(height: 300)
    
        
    }
}


struct Previews_FinanzasView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            FinanzasView()
                .environmentObject(AuthViewModel())
                .preferredColorScheme(.light)
            FinanzasView()
                .environmentObject(AuthViewModel())
                .preferredColorScheme(.dark)
        }
        
    }
}
