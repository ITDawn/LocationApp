//
//  PinsViewController.swift
//  Location
//
//  Created by Dany on 31.10.2021.
//

import UIKit

class PinsViewController: UIViewController {

    let id = "cellId"
    
    private let tableView:UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.backgroundColor = .systemGray5
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
   @objc func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
    let buttonReset: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 25
        button.setImage(UIImage(systemName: "trash.circle.fill"), for: .normal)
        button.imageView?.tintColor = .red
        button.imageView?.contentMode = .scaleAspectFill
        button.imageEdgeInsets = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
        button.addTarget(self, action: #selector(resetDefaults), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        view.addSubview(tableView)
        tableView.addSubview(buttonReset)
        self.view.backgroundColor = .systemGray5
        self.title = "My pins"
        super.viewDidLoad()
      let constraints = [
        buttonReset.bottomAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 700),
        buttonReset.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
        
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      ]
        NSLayoutConstraint.activate(constraints)
        setupTableView()
    }
    
    
    func setupTableView() {
        tableView.register(PinViewCell.self, forCellReuseIdentifier: id)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        
    }
    

}

extension PinsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  Pin.loadPins()?.count ?? 0
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! PinViewCell
        cell.pinSet = Pin.loadPins()?[indexPath.row]
        
        return cell
        
    }
    


}
