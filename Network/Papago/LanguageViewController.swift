//
//  LanguageViewController.swift
//  SeSACNetwork
//
//  Created by 민지은 on 2024/01/17.
//

import UIKit

struct Language {
    static let languageDataList: [String:String] = ["ko":"한국어",
                                                   "en":"영어",
                                                   "ja":"일본어",
                                                   "zh-CN":"중국어 간체",
                                                   "zh-TW":"중국어 번체",
                                                   "vi":"베트남어",
                                                   "id":"인도네시아어",
                                                   "th":"태국어",
                                                   "de":"독일어",
                                                   "ru":"러시아어",
                                                   "es":"스페인어",
                                                   "it":"이탈리아어",
                                                   "fr":"프랑스어"]
    
    
    static let setLanguageList: [String?] = [
                           languageDataList["ko"],
                           languageDataList["en"],
                           languageDataList["ja"],
                           languageDataList["zh-CN"],
                           languageDataList["zh-TW"],
                           languageDataList["vi"],
                           languageDataList["id"],
                           languageDataList["th"],
                           languageDataList["de"],
                           languageDataList["ru"],
                           languageDataList["es"],
                           languageDataList["it"],
                           languageDataList["fr"]
    ]
    
}

class LanguageViewController: UIViewController {
    
    @IBOutlet var titleView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var languageTableView: UITableView!

    var nowLanguage = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "이 언어로 입력"
        
        let image = UIImage(systemName: "chevron.left")
        let button = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(detailLeftBarButtonItemClicked))
        button.tintColor = .black
        navigationItem.leftBarButtonItem = button

        configureView()
        configureTableView()
        
    }
    
    @objc func detailLeftBarButtonItemClicked() {
        print(#function)

        navigationController?.popViewController(animated: true)
    }
    
}

extension LanguageViewController: ViewProtocol {
    func configureView() {
        titleLabel.text = "모든 언어"
        titleLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        titleLabel.backgroundColor = .clear
        
        titleView.backgroundColor = .white
        titleView.clipsToBounds = true
        titleView.layer.cornerRadius = 20
        titleView.layer.borderWidth = 1
        titleView.layer.borderColor = UIColor.black.cgColor
    }
}

extension LanguageViewController {
    func configureTableView() {
        languageTableView.delegate = self
        languageTableView.dataSource = self
        
        let xib = UINib(nibName: LanguageTableViewCell.identifier, bundle: nil)
        languageTableView.register(xib, forCellReuseIdentifier: LanguageTableViewCell.identifier)
    }
}

extension LanguageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Language.languageDataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = languageTableView.dequeueReusableCell(withIdentifier: LanguageTableViewCell.identifier, for: indexPath) as! LanguageTableViewCell
    
        let setLanguage = Language.setLanguageList[indexPath.row]
        
        cell.languageLabel.text = setLanguage
        
        if setLanguage == nowLanguage {
            cell.languageLabel.textColor = .red
        }
 
        
        return cell
    }
    
}
