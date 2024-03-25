//
//  VersionCheck.swift
//  PetDiary
//
//  Created by 민지은 on 2024/03/26.
//

import UIKit

class VersionCheck {
    
    //현재 버전을 알아올 수 있음
    static let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    
    //개발자가 내부적으로 확인하기위한 용도
    static let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    static let appStoreOpenUrlString = "itms-apps://itunes.apple.com/app/apple-store/itms-apps://itunes.apple.com/app/apple-store/47HVCF82JP.com.mje0211.PetDiary"
    
    //현재 앱스토어의 최신 버전 확인
    func latestVersion() -> String? {
        let appleID = "47HVCF82JP.com.mje0211.PetDiary"
        var result: String?
        
        DispatchQueue.global().async {
            guard let url = URL(string: "https://itunes.apple/com/lookup?id=\(appleID)&country=kr"),
                  let data = try? Data(contentsOf: url),
                  let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
                  let results = json["results"] as? [[String: Any]],
                  let appStoreVersion = results[0]["version"] as? String else {
                result = nil
                return
            }
            result = appStoreVersion
        }
        
        return result
    }
    
    //앱스토어로 이동하는 함수
    func openAppStore() {
        guard let url = URL(string: VersionCheck.appStoreOpenUrlString) else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
}
