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
    @State private var showNewTaskITem: Bool = false
    
        
    // MARK: - Fetching data
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
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

    // MARK: - Body
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                // MARK: - HEader
                Spacer(minLength: 80)
                    
                    Button {
                        showNewTaskITem = true
                    } label: {
                        Image(systemName: "plus.circle")
                            .font(.system(size: 30, weight: .semibold, design: .rounded))
                        Text("Nueva Tarea")
                            .font(.system(size: 25, weight: .semibold, design: .rounded))
                    }.foregroundColor(.black)
                        .padding()
                        .background(
                            LinearGradient(gradient: Gradient(colors: [Color.white, Color.blue]), startPoint: .trailing, endPoint: .leading)
                                .clipShape(Capsule())
                        )
                        .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 8, x: 0.0, y: 4.0)

                    
                    List {
                        ForEach(items) { item in
                            
                            VStack (alignment: .leading) {
                                Text(item.task ?? "")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                
                                Text("Creado el \(item.timestamp!, formatter: itemFormatter)")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }//Vstack
                            
                        }
                        .onDelete(perform: deleteItems)
                    }//List
                    .listStyle(InsetGroupedListStyle())
                    .shadow(radius: 15)
                    .padding(.vertical, 5)
                    .frame(maxWidth: 640)
                }//Vstack
                .navigationBarTitle("Lista de Pendientes", displayMode: .large)
                
                if showNewTaskITem {
                    BlankView()
                        .onTapGesture {
                            withAnimation {
                                showNewTaskITem = false
                            }
                        }
                    NewTaskITemView(isShowing: $showNewTaskITem)
                }
                
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
    }///Body
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
