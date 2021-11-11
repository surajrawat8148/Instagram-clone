//
//  SettingsViewController.swift
//  Instagram clone
//
//  Created by Suraj Rawat on 24/10/21.
//
import SafariServices
import UIKit

struct SettingCellModel {
    let title: String
    let handler: (() -> Void)
}

//ViewController to show Settings
final class SettingsViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero,
                                    style: .grouped)
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private var data = [[SettingCellModel]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureModels()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self

    }
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func configureModels() {
        data.append([
            SettingCellModel(title: "Edit Profile"){ [weak self] in
                self?.didtapEditProfile()
            },
            
            SettingCellModel(title: "Invite Friends"){ [weak self] in
                self?.didtapInviteFriends()
            },
            
            SettingCellModel(title: "Save Original Friends"){ [weak self] in
                self?.didtapSaveOriginalPost()
            }
            
        ])
        
        data.append([
            SettingCellModel(title: "Edit Profile"){ [weak self] in
                
            }
        ])
        
        data.append([
            SettingCellModel(title: "Terms of Service"){ [weak self] in
                self?.openURL(type: .terms)
            },
        
            SettingCellModel(title: "Privacy Policy"){ [weak self] in
                self?.openURL(type: .privacy)
            },
            
            SettingCellModel(title: "Help / Feedback"){ [weak self] in
                self?.openURL(type: .help)
            }
            
        ])
        
        data.append([
            SettingCellModel(title: "Log out"){ [weak self] in
                self?.didtapLogOut()
            }
        ])
        
    }
    
    enum SettingsURLType{
        case terms, privacy, help
    }
    
    private func openURL(type: SettingsURLType) {
        let urlString: String
        switch type{
        case .terms: urlString = "https://help.instagram.com/581066165581870"
        case .privacy: urlString = "https://help.instagram.com/519522125107875"
        case . help: urlString = "https://help.instagram.com"
        }
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
        
    }
    
    private func didtapSaveOriginalPost() {
        
    }
    
    private func didtapInviteFriends() {
//        show share sheets to invite friends
        
    }
    
    
    private func didtapEditProfile() {
        let vc = EditProfileViewController()
        vc.title = "Edit Profile"
        let navVc = UINavigationController(rootViewController: vc)
        navVc.modalPresentationStyle = .fullScreen
        present(navVc, animated: true)
    }
    
    
    
    private func didtapLogOut() {
        
        let actionSheet = UIAlertController(title: "Log out",
                                            message: "Are you sure you want to Log out?",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Log out", style: .destructive, handler: { _ in
            AuthManager.shared.logOut(completion: { success in
                DispatchQueue.main.async {
                    if success{
                        //                present login
                        let loginVC = LoginViewController()
                        loginVC.modalPresentationStyle = .fullScreen
                        self.present(loginVC, animated: true) {
                            self.navigationController?.popToRootViewController(animated: false)
                            self.tabBarController?.selectedIndex = 0
                        }
        //                present login
                    }else{
                        fatalError("Could not log out user")
        //                error occured
                    }
                }
                    
            })
        }))
        
        actionSheet.popoverPresentationController?.sourceView = tableView
        actionSheet.popoverPresentationController?.sourceRect = tableView.bounds
        present(actionSheet, animated: true)
            
    }
    
}


extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"cell",for:indexPath)
        cell.textLabel?.text = data[indexPath.section][indexPath.row].title
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        This model is in line 45 (weak is model)
        let model = data[indexPath.section][indexPath.row]
        model.handler()
    }
}
