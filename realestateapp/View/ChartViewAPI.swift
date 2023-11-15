//
//  ChartViewAPI.swift
//  RealEstate
//
//  Created by Aldo Yael Navarrete Zamora on 07/11/23.
//

import SwiftUI
import Charts

var sample_data = {
    let calendar = Calendar.current
    let currentYear = calendar.component(.year, from: Date())
    var transactions: [Transaction] = []
    for month in 1...12 {
        if let date = calendar.date(from: DateComponents(year: currentYear, month: month, day: 1)) {
            let transaction = Transaction(
                id: UUID().uuidString,
                date: date,
                income: Double.random(in: 1000...5000),
                tenantId: UUID().uuidString
            )
            transactions.append(transaction)
        }
    }
    
    return transactions
}()

struct ChartViewAPI: View {
    
    @State var sampleData: [Transaction] = sample_data
    
    @State var currentTab: String = "7 Days"
    
    @State var currentActiveItem: Transaction?
    
    @State private var isLineGraph: Bool = false
    
    @State private var plotWidth: CGFloat = 0.0
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Button(action: {
                        self.isLineGraph.toggle()
                    }, label: {
                        Image(systemName: isLineGraph ? "chart.bar.fill" : "chart.line.uptrend.xyaxis")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 12 )
                            .padding(14)
                            .background(.green.opacity(0.1))
                            .clipShape(Circle())
                            .foregroundStyle(.green)
                    })
                    Picker("", selection: $currentTab) {
                        Text("7 Days")
                            .tag("7 Days")
                        Text("Week")
                            .tag("Week")
                        Text("Month")
                            .tag("Month")
                    }
                    .padding(.leading, 80)
                    .pickerStyle(.segmented)
                }
                let totalValue = sampleData.reduce(0.0) { partialResult, item in
                    item.income + partialResult
                }
                Text(totalValue.stringFormat)
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                AnimatedChart()
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.secondary.opacity(0.1).shadow(.drop(radius: 50)))
            )
        }
        .padding()
        
        
    }
    @ViewBuilder
    func AnimatedChart() -> some View {
        let max = sampleData.max(by: { $0.income < $1.income })?.income ?? 0
        Chart {
            ForEach(sampleData) { item in
                if isLineGraph {
                    LineMark(
                        x: .value("Mes del año", item.date, unit: .month),
                        y: .value("Earnings", item.animate ? item.income : 0)
                    )
                    .foregroundStyle(.green.gradient)
                    .interpolationMethod(.catmullRom)
                    AreaMark(
                        x: .value("Mes del año", item.date, unit: .month),
                        y: .value("Earnings", item.animate ? item.income : 0)
                    )
                    .foregroundStyle(.green.gradient.opacity(0.2))
                    .interpolationMethod(.catmullRom)
                } else {
                    BarMark(
                        x: .value("Mes del año", item.date, unit: .month),
                        y: .value("Earnings", item.animate ? item.income : 0)
                    )
                    .foregroundStyle(.green.gradient)
                    
                    if let currentActiveItem, currentActiveItem.id == item.id {
                        RuleMark(x: .value("Month", currentActiveItem.date))
                            .lineStyle(.init(lineWidth: 2, miterLimit: 2, dash: [2], dashPhase: 5))
                            .offset(x: (plotWidth / CGFloat(sampleData.count)) / 2)
                            .annotation(position: .top) {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("Income")
                                        .font(.caption)
                                        .foregroundStyle(.gray)
                                    
                                    Text(currentActiveItem.income.stringFormat)
                                        .font(.title3.bold())
                                }
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(
                                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                                        .fill(
                                            .secondary.opacity(0.1).shadow(.drop(radius: 10))
                                        )
                                )
                            }
                    }
                }
            }
        }
        .chartYScale(domain: 0...(max + 5_000))
        .chartOverlay { proxy in
            GeometryReader { innerProxy in
                Rectangle()
                    .fill(.clear).contentShape(Rectangle())
                    .gesture(
                        DragGesture()
                            .onChanged({ value in
                                let location = value.location
                                if let date: Date = proxy.value(atX: location.x) {
                                    let calendar = Calendar.current
                                    let month = calendar.component(.month, from: date)
                                    if let currentItem = sampleData.first(where: { item in
                                        calendar.component(.month, from: item.date) == month
                                    }) {
                                        self.currentActiveItem = currentItem
                                        self.plotWidth = proxy.plotAreaSize.width
                                    }
                                }
                            })
                            .onEnded({ value in
                                self.currentActiveItem = nil
                            })
                    )
                
            }
        }
        .frame(height: 250)
        .onAppear {
            for (index, _) in sampleData.enumerated() {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.05) {
                    withAnimation(.interactiveSpring(response: 0.8, dampingFraction: 0.8, blendDuration: 0.8)) {
                        sampleData[index].animate = true
                    }
                }
            }
        }
        
    }
}

#Preview {
    var modelData = ModelData()
    return Group {
        ChartViewAPI(sampleData: modelData.sampleData)
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
        ChartViewAPI(sampleData: modelData.sampleData)
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
    }
    
    // Sample data for previews
    class ModelData: ObservableObject {
        @Published var sampleData: [Transaction] = {
            let calendar = Calendar.current
            let currentYear = calendar.component(.year, from: Date())
            var transactions: [Transaction] = []
            
            for month in 1...12 {
                if let date = calendar.date(from: DateComponents(year: currentYear, month: month, day: 1)) {
                    let transaction = Transaction(
                        id: UUID().uuidString,
                        date: date,
                        income: Double.random(in: 1000...5000),
                        tenantId: UUID().uuidString
                    )
                    transactions.append(transaction)
                }
            }
            return transactions
        }()
    }
}
