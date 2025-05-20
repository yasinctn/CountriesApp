//
//  MapViewController.swift
//  CountriesApp
//
//  Created by Yasin Cetin on 16.05.2025.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    var locationName: String? // Örn: "Bahçelievler, İstanbul"
    private var destinationCoordinate: CLLocationCoordinate2D?

    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = locationName ?? "Harita"
        view.backgroundColor = .white

        if let locationName = locationName {
            geocodeAndShowLocation(named: locationName)
        }

        setupDirectionsButton()
    }

    private func geocodeAndShowLocation(named address: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { [weak self] placemarks, error in
            guard let self = self else { return }

            if let error = error {
                print("Konum alınamadı: \(error.localizedDescription)")
                return
            }

            guard let placemark = placemarks?.first,
                  let location = placemark.location else {
                print("Konum bulunamadı.")
                return
            }

            let coordinate = location.coordinate
            self.destinationCoordinate = coordinate

            let region = MKCoordinateRegion(center: coordinate,
                                            latitudinalMeters: 10000,
                                            longitudinalMeters: 10000)
            self.mapView.setRegion(region, animated: true)

            // Pin ekle
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = self.locationName
            self.mapView.addAnnotation(annotation)
        }
    }

    private func setupDirectionsButton() {
        let directionsButton = UIButton(type: .system)
        directionsButton.setTitle("Yol Tarifi Al", for: .normal)
        directionsButton.backgroundColor = UIColor.systemBlue
        directionsButton.setTitleColor(.white, for: .normal)
        directionsButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        directionsButton.layer.cornerRadius = 10
        directionsButton.translatesAutoresizingMaskIntoConstraints = false
        directionsButton.addTarget(self, action: #selector(openInMaps), for: .touchUpInside)

        view.addSubview(directionsButton)

        NSLayoutConstraint.activate([
            directionsButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            directionsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            directionsButton.widthAnchor.constraint(equalToConstant: 200),
            directionsButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    @objc private func openInMaps() {
        guard let coordinate = destinationCoordinate else { return }

        let placemark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = locationName

        let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        mapItem.openInMaps(launchOptions: options)
    }
}
