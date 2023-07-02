//
//  AddContactVC.swift
//  ContackApp
//
//  Created by Abdusamad Mamasoliyev on 12/05/23.
//

import UIKit

class AddContactVC: UIViewController {

    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var surnameTF: UITextField!
    @IBOutlet weak var categoryTF: UITextField!
    @IBOutlet weak var imagePerson: UIImageView!
    @IBOutlet weak var addBtn: UIButton!
    
    var category = ["Relative", "Classmate", "Groupmate", "Office", "Personal"]
    var closure:((Obyekt) -> Void)?
    let pickerView = UIPickerView()
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        edit()
        setupNav()
        setupPicker()
    }
    
    func edit() {
        imagePerson.layer.cornerRadius = 75
        addBtn.layer.cornerRadius = 15
        
       
      
    }
    func setupNav() {
        navigationItem.title = "Add Contact"
        
        let navigationBarAppearance = UINavigationBarAppearance()
        
        navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                       NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold) ]
        navigationBarAppearance.configureWithDefaultBackground()
        navigationBarAppearance.backgroundColor = .systemCyan
        navigationItem.standardAppearance = navigationBarAppearance
        navigationItem.compactAppearance = navigationBarAppearance
        navigationItem.scrollEdgeAppearance = navigationBarAppearance
        
       

        
        let back = UIBarButtonItem(image: UIImage(systemName: "arrowshape.backward"), style: .done, target: self, action: #selector(backBtn))
        
        navigationItem.leftBarButtonItem = back
        back.tintColor = UIColor.white
        navigationItem.hidesBackButton = true
        
    }
    
    @objc func backBtn() {
        navigationController?.popViewController(animated: true)
    }
  
  
    @IBAction func addContactBtn(_ sender: UIButton) {
        
        let data = selectedImage?.pngData()
        
        let task = Obyekt(boshName: nameTF.text ?? "No Name" ,
                          name: nameTF.text ?? "No Name",
                          surname: surnameTF.text ?? " No Surname",
                          category: categoryTF.text ?? "No Category",
                          img: data)
        
        if let closure {
            closure(task)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func uploadImage(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Choose image source", message: nil, preferredStyle: .actionSheet)
        
        let camera = UIAlertAction(title: "Camera", style: .default ) { _ in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                
                let imagePicker = UIImagePickerController()
                
                imagePicker.sourceType = .camera
                imagePicker.allowsEditing = true
                
                self.present(imagePicker, animated: true)
            }else{
                let alert = UIAlertController(title: "Camera is not available on this device", message: nil, preferredStyle: .alert)
                
                let ok = UIAlertAction(title: "Ok", style: .default)
                
                alert.addAction(ok)
                
                self.present(alert, animated: true)
            }
        }
        
        let gallery = UIAlertAction(title: "Gallery", style: .default) { _ in
            
            let imagePicker = UIImagePickerController()
            
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            
            self.present(imagePicker, animated: true)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(camera)
        alert.addAction(gallery)
        alert.addAction(cancel)
        self.present( alert, animated: true)
    }
    func setupPicker() {
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        let toolBar = UIToolbar()
        let done = UIBarButtonItem(title: "done", style: .done, target: self, action: #selector(donePres))
        toolBar.items = [done]
        toolBar.sizeToFit()
        
        categoryTF.inputView = pickerView
        categoryTF.inputAccessoryView = toolBar
    }
    @objc func donePres() {
        let row = pickerView.selectedRow(inComponent: 0)
        
        categoryTF.text = category[row]
        categoryTF.resignFirstResponder()  // orqaga qaytish
    }
}
extension AddContactVC : UIPickerViewDelegate, UIPickerViewDataSource {
   
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return category.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return category[row]
    }
    
}
extension AddContactVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       
        let image = info[.editedImage] as! UIImage
        
        selectedImage = image
        imagePerson.image = image
        
        dismiss(animated: true)
    }
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
