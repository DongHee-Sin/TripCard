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
        navigationItem.title = "백업 / 복원"
        
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
        showAlert(title: "현재 저장된 데이터를 기준으로 백업 파일을 생성하시겠어요?", buttonTitle: "생성하기", cancelTitle: "취소") { [weak self] _ in
            guard let self = self else { return }
            do {
                try self.repository.saveEncodedTripToDocument()
                
                let backupFilePath = try self.repository.documentManager.createBackupFile()
                
                self.showActivityViewController(filePath: backupFilePath)
                
                self.fetchZipFiles()
            }
            catch {
                self.showErrorAlert(error: error)
            }
        }
    }
    
    
    @objc private func fetchBackupButtonTapped() {
        // 문서파일 여는거 그거 해야함!
    }
    
    
    private func fetchZipFiles() {
        do {
            zipFiles = try repository.documentManager.fetchDocumentZipFile()
        }
        catch {
            showErrorAlert(error: error)
        }
    }
    
    
    func showActivityViewController(filePath: URL) {
        let vc = UIActivityViewController(activityItems: [filePath], applicationActivities: [])
        transition(vc, transitionStyle: .present)
    }
}




// MARK: - TableView Protocol
extension BackupRestoreViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        showAlert(title: "\(zipFiles[indexPath.row].lastPathComponent) 파일로 데이터를 복구합니다.", buttonTitle: "복구하기", cancelTitle: "취소") { [weak self] _ in
            guard let self = self else { return }
            let lastPath = self.zipFiles[indexPath.row].lastPathComponent
            
            do {
                try self.repository.documentManager.restoreData(zipLastPath: lastPath)
                
                try self.repository.removeAll()
                
                try self.repository.overwriteRealmWithJSON()
                
                self.changeRootViewController()
            }
            catch {
                self.showErrorAlert(error: error)
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            showAlert(title: "백업 파일을 삭제하시겠어요?", buttonTitle: "삭제하기", cancelTitle: "취소") { [weak self] _ in
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
