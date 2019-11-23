//
//  ContentView.swift
//  mapui
//
//  Created by Harry Patsis on 21/11/19.
//  Copyright © 2019 Harry Patsis. All rights reserved.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
  func makeUIView(context: Context) -> MKMapView {
    MKMapView(frame: .zero)
  }
  //48.212423, 16.374150

  func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<MapView>) {
    let coordinate = CLLocationCoordinate2D(latitude: 48.2082, longitude: 16.3738)
    let span = MKCoordinateSpan(latitudeDelta: 8.0, longitudeDelta: 8.0)
    let region = MKCoordinateRegion(center: coordinate, span: span)
    uiView.setRegion(region, animated: true)
  }
}

extension UIApplication {
    func endEditing(_ force: Bool) {
        self.windows
            .filter{$0.isKeyWindow}
            .first?
            .endEditing(force)
    }
}

struct ContentView: View {
  @State var name: String = ""
  @State var showCancelButton: Bool = false
  var body: some View {
    ZStack {
      MapView()
      VStack {
        HStack {
          HStack {
            if showCancelButton {
            Button(action: {
              print("button pressed")
              UIApplication.shared.endEditing(true) // this must be placed before the other commands here
              self.name = ""
              self.showCancelButton = false
            }) {
              Image(systemName: "chevron.left")
                .renderingMode(.original)
              }
            } else {
              Image(systemName: "magnifyingglass")
            }
            
            TextField("search...", text: $name, onEditingChanged: { isEditing in
              print(isEditing)
              if isEditing {
                self.showCancelButton = true
              } else {
                self.showCancelButton = false
              }
            }, onCommit: {
              print("onCommit")
            }).textFieldStyle(PlainTextFieldStyle())
            
            Button(action: {
              self.name = ""
            })
            {
              Image(systemName: "xmark").opacity(name == "" ? 0 : 1)
            }
            
            //            if showCancelButton  {
            //              Button("Cancel") {
            //                //              UIApplication.shared.endEditing(true) // this must be placed before the other commands here
            //                self.name = ""
            //                self.showCancelButton = false
            //              }
            //              .foregroundColor(Color(.systemBlue))
            //            }
            
          }
          .padding(EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12))
          .background(Color.white)
          .cornerRadius(50)
          .padding()
          
          
        }
        Spacer()
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
