//
//  ContentView.swift
//  iExpense
//
//  Created by Varun Kumar Raghav on 08/09/21.
//

import SwiftUI

class Expenses: ObservableObject {
    @Published var items = [ExpenseItem](){
        didSet{
            let encoder  = JSONEncoder()
            if let encoded = try? encoder.encode(items){
                UserDefaults.standard.setValue(encoded, forKey: "Items")
            }
        }
    }
    init() {
        if let items = UserDefaults.standard.data(forKey: "Items"){
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([ExpenseItem].self, from: items){
                self.items = decoded
                return
            }
        }
        self.items = []
    }
}

struct ExpenseItem: Identifiable, Codable {
    let id = UUID()
    let name: String
    let type: String
    let amount: Int
}


struct ContentView: View {
    @ObservedObject var expenses = Expenses()
    @State private var showingAddExpenseView = false
    @State private var indexSet = IndexSet()
    var body: some View {
        NavigationView {
            List {
                ForEach(expenses.items) { item in
                    HStack{
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            Text(item.type)
                        }
                        Spacer()
                        Text("Rs.\(item.amount)")
                            .amountStyle(item.amount)

                    }
                    
                }.onDelete(perform: removeItems)
                
            }
            .toolbar{// this works best in toolBar
                    EditButton() // not works well as navigationbarItems
            }
            .navigationBarTitle("iExpense")
            .navigationBarItems(leading:
                                    //EditButton() //not works well as navigationbarItems
                                    Button(action: {
                                        showingAddExpenseView = true
                                    }, label: {
                                        Image(systemName: "plus")
                                    }))
            
            
            
        }.sheet(isPresented: $showingAddExpenseView, content: {
            AddExpenseView(expense: expenses)
        })
    }
    func removeItems(offSet: IndexSet){
        expenses.items.remove(atOffsets: offSet)
    }
}

// ViewStyles
struct AmountStyle: ViewModifier {
    let amount: Int
    func body(content: Content) -> some View {
        var font = Font.system(size: 22, weight: .light, design: .default)
        var forgroundColor = Color.black
        if amount < 100 {
            font = Font.system(size: 25, weight: .light, design: .default)
            forgroundColor = Color.green
        }
        else if amount < 500 {
            font = Font.system(size: 30, weight: .light, design: .default)
            forgroundColor = Color.yellow
        }
        else {
            font = Font.system(size: 35, weight: .bold, design: .default)
            forgroundColor = Color.red
        }
        return content.font(font).foregroundColor(forgroundColor)
    }
    
}
extension View {
    func amountStyle(_ amount : Int) ->  some View {
        self.modifier(AmountStyle(amount: amount))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
       }
}
