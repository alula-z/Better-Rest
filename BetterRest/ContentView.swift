//
//  ContentView.swift
//  BetterRest
//
//  Created by Alula Zeruesenay on 8/27/25.
//
import CoreML
import SwiftUI

struct ContentView: View {
    @State private var sleepAmount = 8.0
    @State private var wakeup = defaultWakeTime
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? .now
    }
    @State private var coffeeAmount = 1
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    private var  bedTime: String {
        do{
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour,.minute], from: wakeup)
            let hour = (components.hour ?? 0) * 60 * 60
            let minutes = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minutes), estimatedSleep: sleepAmount,coffee: Double(coffeeAmount))
            
            let sleepTime = wakeup - prediction.actualSleep
            return sleepTime.formatted(date: .omitted, time: .shortened)
            
            
        }catch{
            return Date.now.formatted(date:.omitted, time: .shortened)
        }
       
    }
    var body: some View {
        NavigationView{
            Form {
                Section("When do you want to wake up?"){
                    DatePicker("Please enter a time", selection: $wakeup,displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                Section("Desired amount of sleep"){

                    Stepper("\(sleepAmount.formatted())", value: $sleepAmount, in: 4...12,step: 0.25)
                }
                Section("Daily coffee intake"){
                    Stepper("^[\(coffeeAmount) cup](inflect: true)",value: $coffeeAmount,in: 1...20)
                }
                Section("Calculatd bedtime"){
                    Text("\(bedTime)")
                        .font(.headline)
                }
            }
            .navigationTitle("BetterRest")
            
           
            
        }
    }
}

#Preview {
    ContentView()
}
