//
//  FinanzasView.swift
//  RealEstate
//
//  Created by Aldo Navarrete on 21/12/22.
//

import SwiftUI
import Charts

enum Time: String, CaseIterable, Identifiable {
    var id: Self { self }
    case day = "Diario", month = "Mensual", week = "Semanal", year = "Anual", custom = "Personalizado"
}

struct FinanzasView: View {
    
    @EnvironmentObject private var authModel: AuthViewModel
    
    @State private var isSheetShowing: Bool = false
    
    @State private var transactions: [Transaction] = []
    @State private var transactionsFilteredArr: [Transaction] = []
    @State private var selectedTime: Time = .custom
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
    
    private let columns: [GridItem] = [
        GridItem(.adaptive(minimum: 140)),
        GridItem(.adaptive(minimum: 140)),
    ]
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                timeLapsePicker
                if selectedTime == .custom {
                    gridDatePicker
                }
                if !transactionsFilteredArr.isEmpty {
                    earningChartTitle
                    earningChartNumber
                    earningChart
                }
                TransactionView(transactionsFilteredArr)
            }
            .onChange(of: selectedTime, perform: loadData)
            .onChange(of: fromDate, perform: filterDataFrom)
            .onChange(of: untilDate, perform: filterDataUntil)
            .onAppear(perform: loadTransactions)
            .navigationBarTitle("Tus finanzas")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isSheetShowing.toggle()
                    }, label: {
                        Image(systemName: "plus")
                    })
                }
            }
            .sheet(isPresented: $isSheetShowing) {
                NewTransactionView(transactions: $transactions)
            }
            .overlay {
                if transactionsFilteredArr.isEmpty {
                    Text("Ups, parece que no has tenido ninguna transacción.")
                }
            }
        }
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
            chartUnitXAxis = .month
        case .custom:
            chartUnitXAxis = .month
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
    
    var earningChart: some View {
        Chart {
            ForEach(transactionsFilteredArr) {
                BarMark (
                    x: .value("Mes", $0.date, unit: chartUnitXAxis),
                    y: .value("Ingresos", $0.income)
                )
                .foregroundStyle(Color.green.gradient)
                .lineStyle(.init(lineWidth: 4))
                .interpolationMethod(.cardinal)
            }
        }
        .frame(width: 350, height: 210)
        .chartYAxisLabel {
            Label("Ingresos", systemImage: "dollarsign")
        }
    }
    
}

struct Previews_FinanzasView_Previews: PreviewProvider {
    static var previews: some View {
        FinanzasView()
            .environmentObject(AuthViewModel())
    }
}
