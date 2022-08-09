//
//  ContentView.swift
//  MyToDoList
//
//  Created by marco rodriguez on 02/08/22.
//

import SwiftUI
import CoreData
import UIKit

struct ContentView: View {
    // MARK: - Property
    @State  var task: String = ""
    
    
    
    //computed property
    //sera false si el textfield esta vacio
    private var isButtonDisabled: Bool {
        task.isEmpty
    }
    
    // MARK: - Fetching data
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    VStack (alignment: .center, spacing: 16) {
                    
                        TextField("Nueva Tarea", text: $task)
                            .padding()
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(12)
                        
                        Button {
                            addItem()
                            
                        } label: {
                            Spacer()
                            Text("GUARDAR")
                            Spacer()
                        }
                        .disabled(isButtonDisabled)
                        .padding()
                        .font(.headline)
                        .foregroundColor(.white)
                        .background(isButtonDisabled ? Color.gray : Color.blue)
                        .cornerRadius(12)

                    }//Vstack
                    .padding()
                    
                    List {
                        ForEach(items) { item in
                            
                            VStack (alignment: .leading) {
                                Text(item.task ?? "")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                
                                Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }//list item
                            
                        }
                        .onDelete(perform: deleteItems)
                    }
                    .listStyle(InsetGroupedListStyle())
                    .shadow(radius: 15)
                    .padding(.vertical, 5)
                    .frame(maxWidth: 640)
                }//Vstack
                .navigationBarTitle("Lista de Pendientes", displayMode: .large)
                
            }//Zstack
            .onAppear() {
                UITableView.appearance().backgroundColor = UIColor.clear
            }
            // boton de agregar y editar
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }//toolbar
            .background(
            BackgroundImageView()
            )
        }//Navigation
        
    }

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
            
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
           
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
