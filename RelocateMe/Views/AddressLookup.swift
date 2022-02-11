//
//  AddressLookup.swift
//  RelocateMe
//
//  Created by MidnightChips on 1/12/22.
//

import MapKit
import SwiftUI

struct AddressLookup: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var locationSearchService = LocationSearchService()
    @Binding var selectedAddress: MKPlacemark?
    var isSelected = false
    var needCancel = false
    var cancelCallback: (() -> ())?
    var selectedCallback: (() -> ())?
    
    var body: some View {
        VStack {
            HStack {
                SearchBar(text: $locationSearchService.searchQuery, isSelected: isSelected, placeholder: "Enter an Address")
                if (needCancel) {
                    Button(action: {
                        print("Testing")
                        guard let cmd = cancelCallback else {return}
                        cmd()
                    }, label: {
                        Text("Cancel")
                    })
                }
            }.padding()
            
           
            List(locationSearchService.completions) { completion in
                Button(action: {
                    let request = MKLocalSearch.Request(completion: completion)
                    let search = MKLocalSearch(request: request)
                    
                    search.start(completionHandler: { (response, error) in
                        if let error = error {
                            print("Failed to locate \(error.localizedDescription)")
                        }
                        else if let mapItems = response?.mapItems {
                            selectedAddress = mapItems[0].placemark
                            //placeManager.addPlacemark(placeMark: mapItems[0].placemark)
                        }
                    })
                    presentationMode.wrappedValue.dismiss()
                            
                    guard let cmd = selectedCallback else { return }
                    cmd()
                            
                }) {
                    VStack(alignment: .leading) {
                        Text(completion.title)
                        Text(completion.subtitle)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
        }
        .onAppear(perform: {
            UITableView.appearance().backgroundColor = UIColor.clear
        })
        .onDisappear(perform: {
            UITableView.appearance().backgroundColor = UIColor.systemBackground
        })
    }
}

struct SearchBar: UIViewRepresentable {
    @Binding var text: String
    var isSelected: Bool = false
    var startEditing: (() -> ())?
    var placeholder: String
    
    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var text: String
        var startEditing: (() -> ())?
        
        init(text: Binding<String>, startEditing: (() -> ())?) {
            _text = text
            self.startEditing = startEditing
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
        
        func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            guard let cmd = startEditing else { return }
            cmd()
        }
    }
    
    func makeCoordinator() -> SearchBar.Coordinator {
        return Coordinator(text: $text, startEditing: startEditing)
    }
    
    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.placeholder = placeholder
        searchBar.searchBarStyle = .minimal
        searchBar.autocapitalizationType = .none
        if (isSelected) {
            searchBar.becomeFirstResponder()
        }
        return searchBar
    }
    
    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
    }
}
