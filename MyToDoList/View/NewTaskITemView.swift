//
//  NewTaskITemView.swift
//  MyToDoList
//
//  Created by marco rodriguez on 08/08/22.
//

import SwiftUI

struct NewTaskITemView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var task: String = ""
    @Binding var isShowing: Bool
    
    
    //computed property
    //sera false si el textfield esta vacio
    private var isButtonDisabled: Bool {
        task.isEmpty
    }
    
    // MARK: -  Function
    
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            newItem.task = task
            newItem.completion = false
            newItem.id = UUID()
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            
            task = ""
            //Dismiss Keyboard
        isShowing = false
        }
    }
    
    
    var body: some View {
        VStack (alignment: .center, spacing: 16) {
            Spacer()
            
            VStack (alignment: .center, spacing: 16) {
            
                TextField("Nueva Tarea", text: $task)
                    .foregroundColor(.pink)
                    .font(.system(size: 25, weight: .bold, design: .rounded))
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(12)
                
                Button {
                    addItem()
                    
                } label: {
                    Spacer()
                    Text("GUARDAR")
                        .font(.system(size: 25, weight: .bold, design: .rounded))
                    Spacer()
                }
                .disabled(isButtonDisabled)
                .padding()
                .font(.headline)
                .foregroundColor(.white)
                .background(isButtonDisabled ? Color.blue : Color.pink)
                .cornerRadius(12)

            }//Vstack
            .padding()
            .background(
                Color.white
            ).cornerRadius(16)
                .shadow(color: Color(red: 0, green: 0, blue: 0), radius: 24)
                .frame(maxWidth: 640)
        }//Vstack
        .padding()
    }
}

struct NewTaskITemView_Previews: PreviewProvider {
    static var previews: some View {
        NewTaskITemView(isShowing: .constant(true))
            .previewDevice("iPhone 12 Pro")
            .background(Color.gray.edgesIgnoringSafeArea(.all))
    }
}
