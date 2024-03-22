//
//  Extension + UIViewController.swift
//  PetDiary
//
//  Created by 민지은 on 2024/03/10.
//

import UIKit

extension UIViewController {
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

