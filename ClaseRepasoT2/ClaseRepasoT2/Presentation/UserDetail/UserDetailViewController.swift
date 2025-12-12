//
//  UserDetailViewController.swift
//  ClaseRepasoT2
//
//  Created by Brayan Munoz Campos on 11/12/25.
//

import UIKit

class UserDetailViewController: UIViewController {
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var cellphoneTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    var user: UserModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        displayUserInformation()
    }
    
    private func setupUI() {
        title = "Detalle de Usuario"
        
        // Configurar placeholders
        firstNameTextField.placeholder = "Nombres"
        lastNameTextField.placeholder = "Apellidos"
        emailTextField.placeholder = "Correo electrónico"
        cellphoneTextField.placeholder = "Número de celular"
        
        // Configurar teclado para celular (solo números)
        cellphoneTextField.keyboardType = .numberPad
        
        // Configurar botón
        saveButton.setTitle("Guardar Cambios", for: .normal)
    }
    
    private func displayUserInformation() {
        guard let user = user else { return }
        
        // Si tiene nombres y apellidos separados, usarlos; si no, dividir el nombre completo
        if let firstName = user.firstName, let lastName = user.lastName, !firstName.isEmpty, !lastName.isEmpty {
            firstNameTextField.text = firstName
            lastNameTextField.text = lastName
        } else {
            // Dividir el nombre completo en nombres y apellidos
            let nameParts = user.name.split(separator: " ", maxSplits: 1)
            if nameParts.count == 2 {
                firstNameTextField.text = String(nameParts[0])
                lastNameTextField.text = String(nameParts[1])
            } else {
                firstNameTextField.text = user.name
                lastNameTextField.text = ""
            }
        }
        
        emailTextField.text = user.email
        cellphoneTextField.text = user.cellphoneNumber
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
            self?.navigationController?.popViewController(animated: true)
        }
        alert.addAction(alertAction)
        present(alert, animated: true)
    }
    
    private func validateForm() -> Bool {
        // Validar nombres
        let firstNameText = firstNameTextField.text ?? ""
        if !ValidationHelper.isNotEmpty(firstNameText) {
            showAlert(message: "Los nombres no deben estar vacíos")
            return false
        }
        
        if !ValidationHelper.isValidFullName(firstNameText) {
            showAlert(message: "Los nombres solo deben contener letras (incluyendo ñ, tildes y espacios)")
            return false
        }
        
        // Validar apellidos
        let lastNameText = lastNameTextField.text ?? ""
        if !ValidationHelper.isNotEmpty(lastNameText) {
            showAlert(message: "Los apellidos no deben estar vacíos")
            return false
        }
        
        if !ValidationHelper.isValidFullName(lastNameText) {
            showAlert(message: "Los apellidos solo deben contener letras (incluyendo ñ, tildes y espacios)")
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
    
    private func updateUser(by id: Int32) {
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let fullName = "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces)
        
        let updatedUser = UserModel(
            id: id,
            name: fullName,
            firstName: firstName,
            lastName: lastName,
            cellphoneNumber: cellphoneTextField.text ?? "",
            email: emailTextField.text ?? ""
        )
        
        do {
            try CoreDataManager.shared.updateUserEntity(id: id, with: updatedUser)
            debugPrint("✅ ACTUALIZAR: Usuario actualizado correctamente")
            showSuccessAlert(message: "Usuario actualizado exitosamente")
        } catch {
            debugPrint("❌ ACTUALIZAR: Error al actualizar usuario - \(error.localizedDescription)")
            showAlert(message: "Error al actualizar el usuario")
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        // Cerrar teclado
        view.endEditing(true)
        
        if !validateForm() {
            return
        }
        
        guard let user = user else { return }
        updateUser(by: user.id)
    }
}
