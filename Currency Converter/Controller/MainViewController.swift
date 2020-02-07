//
//  MainViewController.swift
//  Currency Converter
//
//  Created by Indra Permana on 06/02/20.
//  Copyright © 2020 Yusuf Indra. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
    var backgroundView: UIView!
    var currencyConverterLogoImageView: UIImageView!
    var currencySourceButton: UITextField!
    var currencyDestinationButton: UITextField!
    var currencySourceTextField: UITextField!
    var currencyDestinationTextField: UITextField!
    var currencySourcePickerView: UIPickerView!
    var currencyDestinationPickerView: UIPickerView!
    var creditLabel: UILabel!
    
    var currencyDict: [Currency] = []
    var selectedSource = ""
    var selectedDestination = ""
    var api = API()
    var rates: Rates?
    let numberFormatter = NumberFormatter()
    
    override func viewWillAppear(_ animated: Bool) {
        fetchLocalCurrency()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Get screen size for widh and height
        screenSize = self.view.frame
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        let margins = view.layoutMarginsGuide
        
        // Set the background black view
//        backgroundView = UIView(frame: CGRect(x: 0, y: -20, width: screenWidth, height: screenHeight/1.2))
        backgroundView = UIView()
        backgroundView.backgroundColor = #colorLiteral(red: 0.189347595, green: 0.6552100182, blue: 0.8581241369, alpha: 1)
        backgroundView.layer.cornerRadius = 20
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(backgroundView)
//        backgroundView.widthAnchor.constraint(equalTo: margins.widthAnchor, constant: 0).isActive = true
//        backgroundView.heightAnchor.constraint(equalTo: margins.heightAnchor, constant: 40).isActive = true
        backgroundView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: -20).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 20).isActive = true
        backgroundView.topAnchor.constraint(equalTo: margins.topAnchor, constant: -30).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -40).isActive = true
        
        // Set the Logo
        currencyConverterLogoImageView = UIImageView(image: UIImage.init(named: "icons8-currency_exchange"))
        currencyConverterLogoImageView.frame = CGRect(x: 0, y: 50, width: 144, height: 144)
        currencyConverterLogoImageView.center.x = self.view.center.x
        currencyConverterLogoImageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(currencyConverterLogoImageView)
        currencyConverterLogoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        currencyConverterLogoImageView.topAnchor.constraint(equalTo: margins.topAnchor, constant: 44).isActive = true
        
        // Set The PickerViews
        currencySourcePickerView = UIPickerView()
        currencySourcePickerView.delegate = self
        currencySourcePickerView.dataSource = self
        currencySourcePickerView.tag = CurrencyPickerViewTag.CurrencySource.rawValue
        
        currencyDestinationPickerView = UIPickerView()
        currencyDestinationPickerView.delegate = self
        currencyDestinationPickerView.dataSource = self
        currencyDestinationPickerView.tag = CurrencyPickerViewTag.CurrencyDestination.rawValue
        
        // Set the Currency Source Button
//        currencySourceButton = UITextField(frame: CGRect(x: 20, y: screenHeight/3, width: 180, height: 44))
        currencySourceButton = UITextField()
        currencySourceButton.text = "Currency From ⌵"
        currencySourceButton.borderStyle = .none
        currencySourceButton.tintColor = .clear
        currencySourceButton.inputView = currencySourcePickerView
        currencySourceButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(currencySourceButton)
        currencySourceButton.topAnchor.constraint(equalTo: currencyConverterLogoImageView.bottomAnchor, constant: 20).isActive = true
        currencySourceButton.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 10).isActive = true
        currencySourceButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 20).isActive = true
        
//        currencySourceTextField = UITextField(frame: CGRect(x: 20, y: screenHeight/3 + 48, width: screenWidth - 40, height: 50))
        currencySourceTextField = UITextField()
        currencySourceTextField.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        currencySourceTextField.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        currencySourceTextField.keyboardType = .numberPad
        currencySourceTextField.layer.masksToBounds = true
        currencySourceTextField.layer.cornerRadius = 10
        currencySourceTextField.translatesAutoresizingMaskIntoConstraints = false
        currencySourceTextField.addDoneButtonToKeyboard(myAction: #selector(self.currencySourceTextField.resignFirstResponder))
        currencySourceTextField.delegate = self
        self.view.addSubview(currencySourceTextField)
        currencySourceTextField.topAnchor.constraint(equalTo: currencySourceButton.bottomAnchor, constant: 8).isActive = true
        currencySourceTextField.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 10).isActive = true
        currencySourceTextField.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -10).isActive = true
        currencySourceTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // Set the Currency Destination Button
//        currencyDestinationButton = UITextField(frame: CGRect(x: 20, y: screenHeight/3 + 150, width: 180, height: 44))
        currencyDestinationButton = UITextField()
        currencyDestinationButton.text = "Currency To ⌵"
        currencyDestinationButton.borderStyle = .none
        currencyDestinationButton.tintColor = .clear
        currencyDestinationButton.inputView = currencyDestinationPickerView
        currencyDestinationButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(currencyDestinationButton)
        currencyDestinationButton.topAnchor.constraint(equalTo: currencySourceTextField.bottomAnchor, constant: 16).isActive = true
        currencyDestinationButton.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 10).isActive = true
        currencyDestinationButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 20).isActive = true
        
//        currencyDestinationTextField = UITextField(frame: CGRect(x: 20, y: screenHeight/3 + 198, width: screenWidth - 40, height: 50))
        currencyDestinationTextField = UITextField()
        currencyDestinationTextField.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        currencyDestinationTextField.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        currencyDestinationTextField.layer.masksToBounds = true
        currencyDestinationTextField.layer.cornerRadius = 10
        currencyDestinationTextField.isUserInteractionEnabled = false
        currencyDestinationTextField.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(currencyDestinationTextField)
        currencyDestinationTextField.topAnchor.constraint(equalTo: currencyDestinationButton.bottomAnchor, constant: 8).isActive = true
        currencyDestinationTextField.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 10).isActive = true
        currencyDestinationTextField.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -10).isActive = true
        currencyDestinationTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        creditLabel = UILabel()
        creditLabel.text = "Credit to exchangerate-api\n©2020 M. Yusuf Indra"
        creditLabel.numberOfLines = 0
        creditLabel.textAlignment = .center
        creditLabel.font = .systemFont(ofSize: CGFloat(10))
        self.view.addSubview(creditLabel)
        creditLabel.translatesAutoresizingMaskIntoConstraints = false
        creditLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        creditLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: 0).isActive = true
//        creditLabel.autoresizingMask = [UIView.AutoresizingMask.flexibleLeftMargin, UIView.AutoresizingMask.flexibleRightMargin, UIView.AutoresizingMask.flexibleTopMargin, UIView.AutoresizingMask.flexibleBottomMargin]
//        let horizontalConstraint = creditLabel.centerXAnchor.constraint(equalTo: )
        
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // MARK: Fetch Rates and Calculate if user has click 'done' button on the currencySourceTextField
        fetchAPIRates()
    }
    
    
    func fetchLocalCurrency() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Currency> = Currency.fetchRequest()
        
        do {
            self.currencyDict = try managedContext.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchAPIRates() {
        guard !selectedSource.isEmpty && !selectedDestination.isEmpty && !currencySourceTextField.text!.isEmpty else {return}
        guard let currencySource = currencySourceTextField.text else {return}
        
        api.fetchRates(source: selectedSource) { (rates: Rates?) in
            self.rates = rates
            DispatchQueue.main.async {
                let currencyCode = CurrencyCode(rawValue: self.selectedDestination)

                var destinationCurrency: Double = 0.0
                
                switch currencyCode {
                case .IDR:
                    destinationCurrency = Double(currencySource)! *  rates!.IDR
                case .USD:
                    destinationCurrency = Double(currencySource)! *  rates!.USD
                case .THB:
                    destinationCurrency = Double(currencySource)! *  rates!.THB
                case .SGD:
                    destinationCurrency = Double(currencySource)! *  rates!.SGD
                default:
                    destinationCurrency = 0.0
                }
                
                
                self.currencyDestinationTextField.text = self.numberFormatter.string(from: NSNumber(value: destinationCurrency))
            }
            
        }
    }
    
    // MARK: PickerView Delegates
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyDict.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyDict[row].code
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch CurrencyPickerViewTag(rawValue: pickerView.tag) {
        case .CurrencySource:
            let code = currencyDict[row].code!
            self.selectedSource = code
            let currency = CurrencyCode(rawValue: code)
            switch currency {
            case .IDR:
                self.currencySourceButton.text = "🇮🇩 \(code) ⌵"
            case .USD:
                self.currencySourceButton.text = "🇺🇸 \(code) ⌵"
            case .THB:
                self.currencySourceButton.text = "🇹🇭 \(code) ⌵"
            case .SGD:
                self.currencySourceButton.text = "🇸🇬 \(code) ⌵"
            default:
                self.currencySourceButton.text = "Currency From"
            }
            // MARK: Fetch Rates and Calculate if user has select the Currency Source and Currency Destination after input the currencySourceTextField
            fetchAPIRates()
            
        case .CurrencyDestination:
            let code = currencyDict[row].code!
            self.selectedDestination = code
            let currency = CurrencyCode(rawValue: code)
            switch currency {
            case .IDR:
                self.currencyDestinationButton.text = "🇮🇩 \(code) ⌵"
            case .USD:
                self.currencyDestinationButton.text = "🇺🇸 \(code) ⌵"
            case .THB:
                self.currencyDestinationButton.text = "🇹🇭 \(code) ⌵"
            case .SGD:
                self.currencyDestinationButton.text = "🇸🇬 \(code) ⌵"
            default:
                self.currencyDestinationButton.text = "Currency To"
            }
            // MARK: Fetch Rates and Calculate if user has select the Currency Destination after input the currencySourceTextField
            fetchAPIRates()
        default:
            print("No Element")
        }
        
    }

}

extension UITextField{

 func addDoneButtonToKeyboard(myAction:Selector?){
    let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
    doneToolbar.barStyle = UIBarStyle.default

    let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
    let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: myAction)

    var items = [UIBarButtonItem]()
    items.append(flexSpace)
    items.append(done)

    doneToolbar.items = items
    doneToolbar.sizeToFit()

    self.inputAccessoryView = doneToolbar
 }
}
