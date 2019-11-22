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

struct ContentView: View {
  @State var name: String = ""
  var body: some View {
    ZStack {
      MapView()
      VStack {
        TextField("Search...", text: $name)
          .textFieldStyle(PlainTextFieldStyle())
          .padding(8)
          .background(Color.white)
          .cornerRadius(50)
          .padding()
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
