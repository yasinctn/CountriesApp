//
//  ProvinceListViewController.swift
//  CountriesApp
//
//  Created by Yasin Cetin on 10.05.2025.
//

import UIKit

class ProvinceListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    private var provinces: [Province] = []
    private var filteredProvinces: [Province] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Şehir Seçin"
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self

        fetchProvinces()
    }

    private func fetchProvinces() {
        ApiService.shared.fetchProvinces { result in
            switch result {
            case .success(let provinces):
                self.provinces = provinces
                self.filteredProvinces = provinces
                self.tableView.reloadData()
            case .failure(let error):
                print("Hata: \(error)")
            }
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredProvinces = provinces
        } else {
            let lowercasedText = searchText.lowercased()

            filteredProvinces = provinces.filter { province in
                // Adla eşleşme
                let matchesName = province.name.lowercased().contains(lowercasedText)

                // Plakayla eşleşme
                let matchesPlate: Bool
                if let searchInt = Int(lowercasedText) {
                    matchesPlate = province.id == searchInt
                } else {
                    matchesPlate = false
                }

                return matchesName || matchesPlate
            }
        }

        tableView.reloadData()
    }


    // MARK: - TableView Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredProvinces.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let province = filteredProvinces[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "provinceCell")

        // Arka plan rengi
        cell.backgroundColor = UIColor.systemGray6

        // Başlık (şehir adı)
        cell.textLabel?.text = "\(province.id) \(province.name)"
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        cell.textLabel?.textColor = UIColor.systemBlue

        // Alt başlık (nüfus ve yüzölçümü)
        cell.detailTextLabel?.text = "Nüfus: \(province.population) - Yüzölçümü: \(province.area) km²"
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 13)
        cell.detailTextLabel?.textColor = UIColor.darkGray

        // Hücre kenar yuvarlama için görünüm ayarı
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.masksToBounds = true
        cell.contentView.backgroundColor = UIColor.white
        cell.selectionStyle = .none // Seçili olduğunda griye boyamasın

        // Gölgelendirme (isteğe bağlı)
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 1)
        cell.layer.shadowOpacity = 0.1
        cell.layer.shadowRadius = 3
        cell.layer.masksToBounds = false

        return cell
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedProvince = filteredProvinces[indexPath.row]
        performSegue(withIdentifier: "toDistrictsVC", sender: selectedProvince)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDistrictsVC",
           let destination = segue.destination as? DistrictListViewController,
           let selectedProvince = sender as? Province {
            destination.province = selectedProvince
        }
    }

}
