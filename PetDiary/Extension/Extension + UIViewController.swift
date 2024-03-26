//
//  Extension + UIViewController.swift
//  PetDiary
//
//  Created by 민지은 on 2024/03/10.
//

import UIKit
import Toast

extension UIViewController {

    func makeAlert(alertTitle: String, alertMessage: String, actionMessage: String, clickAction: @escaping () -> ()) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)

        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let action = UIAlertAction(title: actionMessage, style: .default) { _ in
            clickAction()
        }

        alert.addAction(cancel)
        alert.addAction(action)
        
        self.present(alert, animated: true)
    }
    
    func makeToast(_ message: String) {
        var style = ToastStyle()
        style.backgroundColor = Color.lightGreen!
        style.messageColor = .white
        style.messageFont = .systemFont(ofSize: 14, weight: .semibold)
        self.view.makeToast(message, duration: 2.0, position: .bottom, style: style)
    }
    
    func loadImageToDocument(filename: String) -> UIImage? {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let fileURL = documentDirectory.appendingPathComponent("\(filename).jpg")
        
        if FileManager.default.fileExists(atPath: fileURL.path()) {
            print("이미지 로드 완료")
            return UIImage(contentsOfFile: fileURL.path())
        } else {
            print("이미지 로드 실패")
            return nil
        }
    }
    
    func saveImageToDocument(image: UIImage, filename: String) {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let fileURL = documentDirectory.appendingPathComponent("\(filename).jpg")
        
        guard let data = image.jpegData(compressionQuality: 0.5) else { return }
        
        do {
            print("이미지 저장 완료")
            try data.write(to: fileURL)
        } catch {
            print("file save error", error)
        }
    }
    
    func removeImageToDocument(filename: String) {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileURL = documentDirectory.appendingPathComponent("\(filename).jpg")
        
        if FileManager.default.fileExists(atPath: fileURL.path()) {
            do {
                print("이미지 제거 완료")
                try FileManager.default.removeItem(atPath: fileURL.path())
            } catch {
                print("file remove error", error)
            }
        } else {
            print("file no exist")
        }
    }
}

