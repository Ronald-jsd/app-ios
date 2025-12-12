//
//  UsersViewController.swift
//  ClaseRepasoT2
//
//  Created by Brayan Munoz Campos on 11/12/25.
//

import UIKit

class UsersViewController: UIViewController {
    @IBOutlet weak var userTableView: UITableView!
    
    private var users: [UserModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        initTableView()
    }
    
    private func setupUI() {
        title = "Lista de Usuarios"
        
        // Agregar botón de registro en la barra de navegación
        let registerButton = UIBarButtonItem(
            title: "Registrar",
            style: .plain,
            target: self,
            action: #selector(navigateToRegisterView)
        )
        navigationItem.rightBarButtonItem = registerButton
    }
    
    @objc private func navigateToRegisterView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let registerViewController = storyboard.instantiateViewController(withIdentifier: "RegisterViewController") as? RegisterViewController else {
            return
        }
        navigationController?.pushViewController(registerViewController, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUsers()
    }
    
    private func initTableView() {
        userTableView.dataSource = self
        let nib = UINib(nibName: UserViewCell.nibName, bundle: nil)
        userTableView.register(nib, forCellReuseIdentifier: UserViewCell.identifier)
    }
    
    private func fetchUsers() {
        do {
            users = try CoreDataManager.shared.fetchUsers()
            
            if users.isEmpty {
                debugPrint("✅ LEER: No hay usuarios en la base de datos (está vacía)")
            } else {
                debugPrint("✅ LEER: Se encontraron \(users.count) usuario(s)")
            }
            
            userTableView.reloadData()
            
            // Mostrar mensaje si no hay usuarios
            if users.isEmpty {
                showEmptyStateMessage()
            } else {
                hideEmptyStateMessage()
            }
        } catch {
            debugPrint("❌ LEER: Error al obtener usuarios - \(error.localizedDescription)")
        }
    }
    
    private func showEmptyStateMessage() {
        let messageLabel = UILabel()
        messageLabel.text = "No hay usuarios registrados"
        messageLabel.textAlignment = .center
        messageLabel.textColor = .gray
        messageLabel.font = UIFont.systemFont(ofSize: 16)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(messageLabel)
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        messageLabel.tag = 999 // Tag para identificarlo después
    }
    
    private func hideEmptyStateMessage() {
        if let messageLabel = view.viewWithTag(999) {
            messageLabel.removeFromSuperview()
        }
    }
    
    private func deleteUser(by id: Int32) {
        do {
            try CoreDataManager.shared.deleteUserEntity(id: id)
            debugPrint("✅ ELIMINAR: Usuario eliminado exitosamente")
            fetchUsers()
            
            // Mostrar alerta de confirmación
            showAlert(title: "Éxito", message: "Usuario eliminado exitosamente")
        } catch {
            debugPrint("❌ ELIMINAR: Error al eliminar usuario - \(error.localizedDescription)")
            showAlert(title: "Error", message: "Error al eliminar el usuario")
        }
    }
    
    private func showAlert(title: String = "Confirmar", message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let alertAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(alertAction)
        present(alert, animated: true)
    }
    
    private func showDeleteConfirmation(for user: UserModel) {
        let alert = UIAlertController(
            title: "Confirmar eliminación",
            message: "¿Está seguro de que desea eliminar a \(user.fullName)?",
            preferredStyle: .alert
        )
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)
        let deleteAction = UIAlertAction(title: "Eliminar", style: .destructive) { [weak self] _ in
            self?.deleteUser(by: user.id)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        present(alert, animated: true)
    }
    
    private func deleteAllUsers() {
        do {
            try CoreDataManager.shared.deleteAllUsers()
            users.removeAll()
            userTableView.reloadData()
            debugPrint("✅ ELIMINAR TODO: Todos los usuarios fueron eliminados exitosamente")
        } catch {
            debugPrint("❌ ELIMINAR TODO: Error al eliminar todos los usuarios - \(error.localizedDescription)")
        }
    }
    
    private func navigateToUserDetailView(with user: UserModel) {
        let storyboard = UIStoryboard(name: "UserDetailViewController", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "UserDetailViewController") as? UserDetailViewController else { return }
        viewController.user = user
        navigationController?.pushViewController(
            viewController,
            animated: true
        )
    }
    
    @IBAction func deleteAllButtonTapped(_ sender: Any) {
        deleteAllUsers()
    }
}

extension UsersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: UserViewCell = tableView.dequeueReusableCell(
            withIdentifier: UserViewCell.identifier,
            for: indexPath
        ) as? UserViewCell else {
            return UITableViewCell()
        }
        
        let user = users[indexPath.row]
        cell.delegate = self
        cell.buildCell(user: user)
        return cell
    }
}

extension UsersViewController: UserViewCellDelegate {
    
    func didTapSeeDetail(user: UserModel) {
        navigateToUserDetailView(with: user)
    }
    
    func didTapDelete(user: UserModel) {
        showDeleteConfirmation(for: user)
    }
}
