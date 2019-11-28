//
//  ContentView.swift
//  mapui
//
//  Created by Harry Patsis on 21/11/19.
//  Copyright © 2019 Harry Patsis. All rights reserved.
//

import SwiftUI
import MapKit


//class MapPin {
//  let coordinate: CLLocationCoordinate2D
//  let title: String?
//  let subtitle: String?
//  init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D) {
//    self.title = title
//    self.subtitle = subtitle
//    self.coordinate = coordinate
//  }
//}

struct MapView: UIViewRepresentable {
//  @State var pin: MapPin? = nil
  @Binding var pin: MKPlacemark?
  func makeUIView(context: Context) -> MKMapView {
    MKMapView(frame: .zero)
  }
  
  func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<MapView>) {
    guard let pin = pin else {
//    if pins.count == 0 {
      let coordinate = CLLocationCoordinate2D(latitude: 48.2082, longitude: 16.3738)
      let span = MKCoordinateSpan(latitudeDelta: 8.0, longitudeDelta: 8.0)
      let region = MKCoordinateRegion(center: coordinate, span: span)
      uiView.setRegion(region, animated: true)
      return
    }
    // 4.
    let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    let region = MKCoordinateRegion(center: pin.coordinate, span: span)
    uiView.setRegion(region, animated: true)
    
    // 5.
//    let annotation = MKPointAnnotation()
//    annotation.coordinate = pin.coordinate
//    annotation.title = pin.title
//    annotation.subtitle = pin.subtitle
    uiView.addAnnotation(pin)
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
  @State var mapItems: [MKMapItem] = []
  @State var pin: MKPlacemark? = nil
  
  func searchPlaces(name: String) {
    let searchRequest = MKLocalSearch.Request()
    searchRequest.naturalLanguageQuery = name
    let search = MKLocalSearch(request: searchRequest)
    search.start {response, error in
      guard let response = response else {
        self.mapItems = []
        return
      }
      self.mapItems = response.mapItems
    }
  }
  
  func setLocation(place: MKPlacemark) {
    self.mapItems = []
    pin = place
  }
  
  var body: some View {
    ZStack {
      MapView(pin: $pin)
      VStack {
        HStack {
          HStack {
            if showCancelButton {
              Button(action: {
                print("button pressed")
                UIApplication.shared.endEditing(true) // this must be placed before the other commands here
                self.name = ""
                self.showCancelButton = false
                self.mapItems = []
              }) {
                Image(systemName: "chevron.left")
                  .renderingMode(.original)
              }
            } else {
              Image(systemName: "magnifyingglass")
            }
            
            TextField("search...", text: $name, onEditingChanged: { isEditing in
              if isEditing {
                self.showCancelButton = true
              } else {
                self.showCancelButton = false
              }
            }, onCommit: {
              self.searchPlaces(name: self.name)
            }).textFieldStyle(PlainTextFieldStyle())
            
            Button(action: {
              self.name = ""
            })
            {
              Image(systemName: "xmark").opacity(name == "" ? 0 : 1)
            }
          }
          .padding(EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12))
          .background(Color.white)
          .cornerRadius(50)
          .padding()
        }


        
        if (mapItems.count > 0) {
          List(mapItems, id: \.self) { item in
            if item.placemark.name != nil {
              Text(item.placemark.name!)
                .frame(height: 20)
                .background(Color.white)
                .gesture(TapGesture()
                  .onEnded {
                    self.setLocation(place: item.placemark)
                  }
              )
            }
          }
          .cornerRadius(8)
          .padding()
          .frame(height: 165)

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
