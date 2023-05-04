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
    /*
    @State var monthEarns: [Transaction] = [
        .init(date: Date.from(day: 12, month: 4, year: 2022), income: 5900.2, tenant: .init(name: "Aldo")),
        .init(date: Date.from(day: 23, month: 4, year: 2022), income: 7100.3, tenant: .init(name: "Guero")),
        .init(date: Date.from(day: 4, month: 5, year: 2022), income: 4800.4, tenant: .init(name: "Luis")),
        .init(date: Date.from(day: 16, month: 5, year: 2022), income: 6200.5, tenant: .init(name: "Pato")),
        .init(date: Date.from(day: 27, month: 5, year: 2022), income: 7400.6, tenant: .init(name: "Miguel")),
        .init(date: Date.from(day: 8, month: 6, year: 2022), income: 5700.7, tenant: .init(name: "Sara")),
        .init(date: Date.from(day: 19, month: 6, year: 2022), income: 6900.8, tenant: .init(name: "David")),
        .init(date: Date.from(day: 29, month: 6, year: 2022), income: 8200.9, tenant: .init(name: "Prototype Name")),
        .init(date: Date.from(day: 7, month: 7, year: 2022), income: 5100.0, tenant: .init(name: "Jesus")),
        .init(date: Date.from(day: 18, month: 9, year: 2022), income: 6500.1, tenant: .init(name: "Ricardo")),
        .init(date: Date.from(day: 5, month: 1, year: 2023), income: 3000.4, tenant: .init(name: "Ernesto")),
        .init(date: Date.from(day: 15, month: 1, year: 2023), income: 4500.2, tenant: .init(name: "Prototype Name")),
        .init(date: Date.from(day: 21, month: 1, year: 2023), income: 6000.0, tenant: .init(name: "Daniel")),
        .init(date: Date.from(day: 7, month: 2, year: 2023), income: 5500.1, tenant: .init(name: "Alejandro")),
        .init(date: Date.from(day: 17, month: 2, year: 2023), income: 6700.3, tenant: .init(name: "Prototype Name")),
        .init(date: Date.from(day: 25, month: 2, year: 2023), income: 7200.4, tenant: .init(name: "Prototype Name")),
        .init(date: Date.from(day: 3, month: 3, year: 2023), income: 5100.5, tenant: .init(name: "Prototype Name")),
        .init(date: Date.from(day: 10, month: 3, year: 2023), income: 6500.6, tenant: .init(name: "Prototype Name")),
        .init(date: Date.from(day: 20, month: 3, year: 2023), income: 7800.8, tenant: .init(name: "Prototype Name")),
        .init(date: Date.from(day: 5, month: 4, year: 2023), income: 4300.0, tenant: .init(name: "Prototype Name")),
    ]
     */
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
            .toolbar{
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
                if transactions.isEmpty {
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
            print(transactionsFilteredArr.debugDescription)
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
            print(transactions)
        })
    }
}

struct NewTransactionView: View {
    
    @EnvironmentObject private var authModel: AuthViewModel
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var transactions: [Transaction]

    @State private var transactionTenantName: String = ""
    @State private var transactionAmount: Double = 0.0
    @State private var transactionDate: Date = Date.now
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Nombre", text: $transactionTenantName)
                TextField("Cantidad", value: $transactionAmount, format: .number)
                    .keyboardType(.decimalPad)
                DatePicker("Fecha", selection: $transactionDate, displayedComponents: .date)
                    .datePickerStyle(.compact)
            }
                .navigationTitle("Nueva transacción")
                .toolbar{
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Agregar") {
                            // Nueva transaccion
                            Task {
                                await uploadTransaction()
                            }
                        }
                    }
                }
                
        }
    }
    private func uploadTransaction() async {
        let newTransaction:Transaction = Transaction(date: transactionDate, income: transactionAmount, tenantId: "")
//        monthEarns.append(newTransaction)
        await authModel.uploadTransaction(transaction: newTransaction)
        presentationMode.wrappedValue.dismiss()
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
