//
//  AddExpenseView.swift
//  iExpense
//
//  Created by Varun Kumar Raghav on 15/09/21.
//

import SwiftUI

// Views starts here
struct AddExpenseView: View {
    @Environment (\.presentationMode) var presentationMode
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = ""
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    @ObservedObject var expense: Expenses
    
    static let types = ["Personal","Business"]
    var body: some View {
        NavigationView{
            Form{
                TextField("Name", text: $name)
                Picker("Type", selection: $type){
                    ForEach(Self.types, id: \.self){
                        Text($0)
                    }
                }
                TextField("Amount", text: $amount).keyboardType(.numberPad)
            }.navigationBarTitle("Add Expense")
            .navigationBarItems(trailing: Button("Save"){
                if let actualAmount = Int(self.amount){
                    let item = ExpenseItem(name:self.name, type: self.type, amount: actualAmount)
                    expense.items.append(item)
                    self.presentationMode.wrappedValue.dismiss()
                }
                else{
                    alertTitle = "Wrong Amount"
                    alertMessage = "For Amount you must enter Number for example: (1, 2, 3) not a LETTER "
                    showingAlert = true
                }
                
            })
            .alert(isPresented: $showingAlert){
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        }
    }
}

struct AddExpenseView_Previews: PreviewProvider {
    static var previews: some View {
        AddExpenseView( expense: Expenses())
    }
}
