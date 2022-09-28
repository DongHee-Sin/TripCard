//
//  BackupRestoreViewController.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/21.
//

import UIKit

final class BackupRestoreViewController: BaseViewController {

    // MARK: - Propertys
    let repository = TripDataRepository.shared
    
    var zipFiles: [URL] = [] {
        didSet {
            backupRestoreView.backupFileTableView.reloadData()
        }
    }
    
    let fileByteCountFormatter: ByteCountFormatter = {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useKB, .useMB]
        formatter.countStyle = .file
        return formatter
    }()
    
    lazy var dismissButton = UIAlertAction(title: "cancel".localized, style: .cancel) { [weak self] _ in
        guard let self = self else { return }
        self.dismiss(animated: true)
    }
    
    
    
    
    // MARK: - Life Cycle
    let backupRestoreView = BackupRestoreView()
    override func loadView() {
        self.view = backupRestoreView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    
    // MARK: - Methods
    override func configure() {
        navigationItem.title = "backup_and_restore".localized
        
        fetchZipFiles()
        
        setTableView()
        setAddTarget()
    }
    
    
    private func setTableView() {
        backupRestoreView.backupFileTableView.delegate = self
        backupRestoreView.backupFileTableView.dataSource = self
        backupRestoreView.backupFileTableView.register(BackupFileTableViewCell.self, forCellReuseIdentifier: BackupFileTableViewCell.identifier)
    }
    
    
    private func setAddTarget() {
        backupRestoreView.createBackupFileButton.addTarget(self, action: #selector(createBackupButtonTapped), for: .touchUpInside)
        
        backupRestoreView.fetchBackupFileButton.addTarget(self, action: #selector(fetchBackupButtonTapped), for: .touchUpInside)
    }
    
    
    @objc private func createBackupButtonTapped() {
        showAlert(title: "create_backup_alert_title".localized, buttonTitle: "create".localized, cancelTitle: "cancel".localized) { [weak self] _ in
            guard let self = self else { return }
            do {
                self.showIndicator()
                
                try self.repository.saveEncodedDataToDocument()
                
                let backupFilePath = try self.repository.documentManager.createBackupFile()
                
                self.showActivityViewController(filePath: backupFilePath)
                
                self.fetchZipFiles()
            }
            catch {
                self.dismissIndicator()
                self.showErrorAlert(error: error)
            }
        }
    }
    
    
    @objc private func fetchBackupButtonTapped() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.zip], asCopy: true)
        
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        
        present(documentPicker, animated: true)
    }
    
    
    private func fetchZipFiles() {
        do {
            zipFiles = try repository.documentManager.fetchDocumentZipFile()
        }
        catch {
            showErrorAlert(error: error)
        }
    }
    
    
    private func showActivityViewController(filePath: URL) {
        let vc = UIActivityViewController(activityItems: [filePath], applicationActivities: [])
        transition(vc, transitionStyle: .present)
        dismissIndicator()
    }
    
    
    private func restoreData(lastPath: String) {
        showIndicator()
        
        do {
            showIndicator()
            
            try repository.documentManager.restoreData(zipLastPath: lastPath)
            try repository.overwriteRealmWithJSON()
            
            dismissIndicator()
            
            changeRootViewController()
        }
        catch {
            dismissIndicator()
            
            showErrorAlert(error: error)
        }
    }
}




// MARK: - TableView Protocol
extension BackupRestoreViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .zero
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return zipFiles.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BackupFileTableViewCell.identifier, for: indexPath) as? BackupFileTableViewCell else {
            return UITableViewCell()
        }
        
        let fileURL = zipFiles[indexPath.row]
        let fileSize = fileByteCountFormatter.string(fromByteCount: FileManager.default.sizeOfFile(atPath: fileURL.path) ?? 0)
        cell.updateCell(fileName: fileURL.lastPathComponent, fileSize: fileSize)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let restoreButton = UIAlertAction(title: "restore_button_title".localized, style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.showAlert(title: "restore_alert_title".localized(with: self.zipFiles[indexPath.row].lastPathComponent), buttonTitle: "restore_button_title".localized, cancelTitle: "cancel".localized) { _ in
                let lastPath = self.zipFiles[indexPath.row].lastPathComponent
                
                self.restoreData(lastPath: lastPath)
            }
        }
        
        let exportButton = UIAlertAction(title: "export_button_title".localized, style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.showIndicator()
            self.showActivityViewController(filePath: self.zipFiles[indexPath.row])
        }
        
        actionSheet.addAction(restoreButton)
        actionSheet.addAction(exportButton)
        actionSheet.addAction(dismissButton)
        
        transition(actionSheet, transitionStyle: .present)
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            showAlert(title: "delete_alert_title".localized, buttonTitle: "delete".localized, cancelTitle: "cancel".localized) { [weak self] _ in
                guard let self = self else { return }
                do {
                    try self.repository.documentManager.removeFileFromDocument(url: self.zipFiles[indexPath.row])
                    self.fetchZipFiles()
                }
                catch {
                    self.showErrorAlert(error: error)
                }
            }
        }
    }
}




// MARK: - DocumentPicker Protocol
extension BackupRestoreViewController: UIDocumentPickerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        guard let selectedFileURL = urls.first else {
            showAlert(title: "fail_fetch_file_path_alert_title".localized)
            return
        }
        
        do {
            try repository.documentManager.fetchZipFileFromDocumentPicker(selectedFileURL: selectedFileURL)
            
            fetchZipFiles()
        }
        catch {
            showErrorAlert(error: error)
        }
    }
    
}
