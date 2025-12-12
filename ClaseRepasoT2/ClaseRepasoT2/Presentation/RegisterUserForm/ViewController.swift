//
//  ViewController.swift
//  ClaseRepasoT2
//
//  Created by Brayan Munoz Campos on 11/12/25.
//

import UIKit

class RegisterViewController: UIViewController {
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var cellphoneTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        title = "Registro de Usuario"
        
        // Configurar placeholders
        fullNameTextField.placeholder = "Nombre completo"
        emailTextField.placeholder = "Correo electrónico"
        cellphoneTextField.placeholder = "Número de celular"
        
        // Configurar teclado para celular (solo números)
        cellphoneTextField.keyboardType = .numberPad
        
        // Configurar botón
        registerButton.setTitle("Registrar Usuario", for: .normal)
    }

    private func showAlert(title: String = "Error", message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let alertAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(alertAction)
        present(alert, animated: true)
    }
    
    private func showSuccessAlert(message: String) {
        let alert = UIAlertController(
            title: "Éxito",
            message: message,
            preferredStyle: .alert
        )
        let alertAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.clearForm()
        }
        alert.addAction(alertAction)
        present(alert, animated: true)
    }
    
    private func clearForm() {
        fullNameTextField.text = ""
        emailTextField.text = ""
        cellphoneTextField.text = ""
    }
    
    private func validateForm() -> Bool {
        // Validar nombre completo
        let fullNameText = fullNameTextField.text ?? ""
        if !ValidationHelper.isNotEmpty(fullNameText) {
            showAlert(message: "El nombre completo no debe estar vacío")
            return false
        }
        
        if !ValidationHelper.isValidFullName(fullNameText) {
            showAlert(message: "El nombre completo solo debe contener letras (incluyendo ñ, tildes y espacios)")
            return false
        }
        
        // Validar correo electrónico
        let emailText = emailTextField.text ?? ""
        if !ValidationHelper.isNotEmpty(emailText) {
            showAlert(message: "El correo electrónico no debe estar vacío")
            return false
        }
        
        if !ValidationHelper.isValidEmail(emailText) {
            showAlert(message: "Debe ingresar un formato de correo electrónico válido (ej. usuario@dominio.com)")
            return false
        }
        
        // Validar número de celular
        let cellphoneText = cellphoneTextField.text ?? ""
        if !ValidationHelper.isNotEmpty(cellphoneText) {
            showAlert(message: "El número de celular no debe estar vacío")
            return false
        }
        
        if !ValidationHelper.isOnlyDigits(cellphoneText) {
            showAlert(message: "El número de celular solo debe contener números")
            return false
        }
        
        if !ValidationHelper.isValidCellphone(cellphoneText) {
            showAlert(message: "El número de celular debe tener exactamente 9 dígitos y debe iniciar con 9")
            return false
        }
        
        return true
    }
    
    private func saveUser(_ user: UserModel) {
        do {
            try CoreDataManager.shared.saveUserEntity(with: user)
            debugPrint("✅ GUARDAR: Usuario guardado exitosamente")
            showSuccessAlert(message: "Usuario guardado exitosamente")
        } catch {
            debugPrint("❌ GUARDAR: Error al guardar usuario - \(error.localizedDescription)")
            showAlert(message: "Error al guardar el usuario")
        }
    }
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        // Cerrar teclado
        view.endEditing(true)
        
        if !validateForm() {
            return
        }
        
        // Generar ID automáticamente
        let newId = CoreDataManager.shared.generateNewUserId()
        
        let user = UserModel(
            id: newId,
            name: fullNameTextField.text ?? "",
            cellphoneNumber: cellphoneTextField.text ?? "",
            email: emailTextField.text ?? ""
        )
        
        saveUser(user)
    }
}
