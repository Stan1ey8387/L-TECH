//
//  LoginViewController.swift
//  L-TECH
//
//  Created by Захар Бабкин on 22/05/2018.
//  Copyright © 2018 Захар Бабкин. All rights reserved.
//


import UIKit
import InputMask

final class LoginViewController: UIViewController {
    
    
    //MARK: Variabels
    
    private var phoneMask: String?
    private var phoneIsComplete = false
    private var maskedDelegate: MaskedTextFieldDelegate?
    
    
    //MARK: Outlets
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak private var phoneTextField: UITextField!
    @IBOutlet weak private var passwordTextField: UITextField!
    @IBOutlet weak private var signinButton: UIButton!
    
    
    //MARK: View Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readKeachain()
        addTap()
        getPhoneMask()
    }
    
    
    //MARK: IBAction
    
    @IBAction func singinButtonAction() {
        if isValidate() {
            auth()
        }
    }
    
    
    
    //MARK: Methods
    
    private func getPhoneMask() {
        activityIndicator.startAnimating()
        
        AuthNetworkManager.shared.getPhoneMask { [weak self] (response, error) in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
            }
            
            if let error = error {
                self?.showAlert("Ошибка", message: error, titleAction: "Повторить", cancelAction: false, handler: { [weak self] (_) in
                    self?.getPhoneMask()
                })
            } else if let phoneMask = response?.phoneMask {
                self?.phoneMask = phoneMask.convertInputMask()
                DispatchQueue.main.async {
                    self?.setPhoneMask()
                }
                print("I get phoneMask: \(phoneMask)")
            }
        }
    }
    
    private func auth() {
        guard let phone = phoneTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        let clearPhone = phone.cleanPhone()
        
        activityIndicator.startAnimating()
        
        AuthNetworkManager.shared.auth(phone: clearPhone, password: password) { [weak self] (response, error) in
            if let error = error {
                self?.showAlert("Ошибка", message: error, titleAction: "OK", cancelAction: false)
            } else {
                self?.saveKeychain(phone: "\(clearPhone)", password: password)
                self?.performSegue(withIdentifier: "FeedSeque", sender: nil)
            }
            
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
            }
            
        }
    }
    
    private func saveKeychain(phone: String, password: String) {
        Keychain.shared.save(.phone, info: phone)
        Keychain.shared.save(.password, info: password)
    }
    
    private func readKeachain() {
        if let phone = Keychain.shared.load(.phone), let password = Keychain.shared.load(.password) {
            self.phoneTextField.text = phone
            self.passwordTextField.text = password
            
            phoneIsComplete = true
        }
    }
    
    private func isValidate() -> Bool {
        if !phoneIsComplete {
            showAlert("Ошибка", message: "Телефон введен некорректно", titleAction: "OK", cancelAction: false)
            return false
        } else if passwordTextField.text == "" {
            showAlert("Ошибка", message: "Пароль введен некорректно", titleAction: "OK", cancelAction: false)
            return false
        }
        
        return true
    }
    
    private func addTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
}


//MARK: UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.hideKeyboard()
        self.auth()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty && textField == phoneTextField && phoneIsComplete {
            textField.text = ""
        }
        
        return true
    }
}


//MARK: MaskedTextFieldDelegateListener

extension LoginViewController: MaskedTextFieldDelegateListener {
    func setPhoneMask() {
        guard let phoneMask = phoneMask else { return }
        maskedDelegate = MaskedTextFieldDelegate(format: phoneMask)
        maskedDelegate?.listener = self
        phoneTextField.delegate = maskedDelegate
    }
    
    func textField(_ textField: UITextField,didFillMandatoryCharacters complete: Bool,didExtractValue value: String) {
        phoneIsComplete = complete
    }
}












