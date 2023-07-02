//
//  MainVC.swift
//  ContackApp
//
//  Created by Abdusamad Mamasoliyev on 12/05/23.
//

import UIKit

class MainVC: UIViewController {
    
    @IBOutlet weak var addContactBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var obyekt: [Obyekt] = [Obyekt(boshName: "A",
                                   name: "Adam",
                                   surname: "John",
                                   category: "Classmate"),
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNav()
        setupTableView()
        addContactBtn.layer.cornerRadius = 50
        
        obyekt = getData(nom: "obyekt")
        
    }
    @IBAction func addBtn(_ sender: UIButton) {
        
        let vc = AddContactVC(nibName: "AddContactVC", bundle: nil)
        vc.closure = { task in
            self.obyekt.append(task)
            self.saveData(array: self.obyekt, nom: "obyekt")
            self.tableView.reloadData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func saveData(array: [Obyekt], nom: String) {
       
        
        let encoder = JSONEncoder()
       
        if let encodedData = try? encoder.encode(array) {
            
            UserDefaults.standard.set(encodedData, forKey: nom)
            
        }
        
    }
    func getData( nom: String ) ->  [Obyekt] {
        
        let decoder = JSONDecoder()
        
        if let userData = UserDefaults.standard.data(forKey: nom) {
            
            if let decodedData = try? decoder.decode([Obyekt].self, from: userData) {
              return decodedData
            }
        }
        return []
    }
    
    func setupNav() {
        
        navigationItem.title = "Contact App"
        
        let navigationBarAppearance = UINavigationBarAppearance()
        
        navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                       NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold) ]
        navigationBarAppearance.configureWithDefaultBackground()
        navigationBarAppearance.backgroundColor = .systemCyan
        navigationItem.standardAppearance = navigationBarAppearance
        navigationItem.compactAppearance = navigationBarAppearance
        navigationItem.scrollEdgeAppearance = navigationBarAppearance
        
        
    }
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "cell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    
}
extension MainVC: UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return obyekt.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! cell
        
        cell.updateCell(contact: obyekt[indexPath.row])
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
        
    }
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        UIContextMenuConfiguration(identifier: nil,
                                   previewProvider: nil) { _ in
            
            
            let delete = UIAction(title: "O'chirish",image: UIImage(systemName: "trash")?.withTintColor(.red , renderingMode: .alwaysOriginal)) { _ in
                print("delete")
                
                self.obyekt.remove(at: indexPath.row)
                self.saveData(array: self.obyekt, nom: "obyekt")
                self.tableView.reloadData()
            }
            return UIMenu(children: [delete])
        }
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        
        let deleteAction = UIContextualAction(style: .normal, title: "O'chirish") { _,_,_ in
            
            self.obyekt.remove(at: indexPath.row)
            self.saveData(array: self.obyekt, nom: "obyekt") 
            self.tableView.reloadData()
        }
        
        deleteAction.backgroundColor = UIColor.red
        
        let swipe = UISwipeActionsConfiguration(actions: [deleteAction])
        
        return swipe
        
    }
    
    // MARK: Hexcolor
    
    func hexStringFromColor(color: UIColor) -> String {
        let components = color.cgColor.components
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b: CGFloat = components?[2] ?? 0.0
        
        let hexString = String.init(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
        print(hexString)
        return hexString
    }
    
    func colorWithHexString(hexString: String) -> UIColor {
        var colorString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        colorString = colorString.replacingOccurrences(of: "#", with: "").uppercased()
        
        print(colorString)
        let alpha: CGFloat = 1.0
        let red: CGFloat = self.colorComponentFrom(colorString: colorString, start: 0, length: 2)
        let green: CGFloat = self.colorComponentFrom(colorString: colorString, start: 2, length: 2)
        let blue: CGFloat = self.colorComponentFrom(colorString: colorString, start: 4, length: 2)
        
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }
    
    func colorComponentFrom(colorString: String, start: Int, length: Int) -> CGFloat {
        
        let startIndex = colorString.index(colorString.startIndex, offsetBy: start)
        let endIndex = colorString.index(startIndex, offsetBy: length)
        let subString = colorString[startIndex..<endIndex]
        let fullHexString = length == 2 ? subString : "\(subString)\(subString)"
        var hexComponent: UInt32 = 0
        
        guard Scanner(string: String(fullHexString)).scanHexInt32(&hexComponent) else {
            return 0
        }
        let hexFloat: CGFloat = CGFloat(hexComponent)
        let floatValue: CGFloat = CGFloat(hexFloat / 255.0)
        print(floatValue)
        return floatValue
    }
}
