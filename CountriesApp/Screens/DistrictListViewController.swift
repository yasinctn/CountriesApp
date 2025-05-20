//
//  DistrictListViewController.swift
//  CountriesApp
//
//  Created by Yasin Cetin on 14.05.2025.
//
import UIKit

class DistrictListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var province: Province?
    private var districts: [District] = []

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = province?.name ?? "İlçeler"
        view.backgroundColor = .white

        tableView.delegate = self
        tableView.dataSource = self

        if let province = province {
            self.districts = province.districts
            print("İl: \(province.name), İlçe Sayısı: \(province.districts.count)")
        } else {
            print("province nil")
        }
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return districts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let district = districts[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "DistrictCell")

        // Arka plan ve yazılar
        cell.backgroundColor = UIColor.systemGray6

        cell.textLabel?.text = district.name
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        cell.textLabel?.textColor = UIColor.systemTeal

        cell.detailTextLabel?.text = "Nüfus: \(district.population) - Yüzölçümü: \(district.area) km²"
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 13)
        cell.detailTextLabel?.textColor = UIColor.darkGray

        // Hücre içi görünüm
        cell.contentView.layer.cornerRadius = 12
        cell.contentView.layer.masksToBounds = true
        cell.contentView.backgroundColor = UIColor.white
        cell.selectionStyle = .none

        // Hafif gölge efekti
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2)
        cell.layer.shadowOpacity = 0.08
        cell.layer.shadowRadius = 3
        cell.layer.masksToBounds = false

        return cell
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedDistrict = districts[indexPath.row]
        let locationString = "\(selectedDistrict.name), \(province?.name ?? "") Türkiye"

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let mapVC = storyboard.instantiateViewController(withIdentifier: "MapViewController") as? MapViewController {
            mapVC.locationName = locationString
            navigationController?.pushViewController(mapVC, animated: true)
        }
    }
}
