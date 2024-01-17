//
//  ViewController.swift
//  SeSACNetwork
//
//  Created by 민지은 on 2024/01/16.
//

import UIKit
import Alamofire

/*{
 "message": {
 "@type": "response",
 "@service": "naverservice.nmt.proxy",
 "@version": "1.0.0",
 "result": {
 "srcLangType": "ko",
 "tarLangType": "en",
 "translatedText": "Hello",
 "engineType": "PRETRANS"
 }
 }
 }*/

struct Papago: Codable {
    let message: PapagoResult
}

struct PapagoResult: Codable {
    let result: PapagoFinal
}

struct PapagoFinal: Codable {
    let srcLangType: String
    let tarLangType: String
    let translatedText: String
}

class ViewController: UIViewController {
    
    @IBOutlet var translateButton: UIButton!
    @IBOutlet var srcLangButton: UIButton!
    @IBOutlet var tarLangButton: UIButton!
    @IBOutlet var changeButton: UIButton!
    @IBOutlet var clearButton: UIButton!
    
    
    @IBOutlet var inputTextView: UITextView!
    @IBOutlet var resultLabel: UILabel!
    
    @IBOutlet var placeHolderLabel: UILabel!
    var nowSrc = "ko"
    var nowTar = "en"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inputTextView.delegate = self
        inputTextView.font = .systemFont(ofSize: 20)
        inputTextView.textAlignment = .center
        inputTextView.backgroundColor = .clear

        setPlaceHolder()
        
        resultLabel.textAlignment = .center
        
        translateButton.addTarget(self, action: #selector (translateButtonClicked), for: .touchUpInside)
        
        clearButton.addTarget(self, action: #selector (clearButtonClicked), for: .touchUpInside)
        
        changeButton.addTarget(self, action: #selector (changeButtonClicked), for: .touchUpInside)
        
        srcLangButton.addTarget(self, action: #selector (srcLangButtonClicked), for: .touchUpInside)
        
        tarLangButton.addTarget(self, action: #selector (tarLangButtonClicked), for: .touchUpInside)
        
        srcLangButton.topButtonDesign(setImage: "", setTitle: nowSrc)
        tarLangButton.topButtonDesign(setImage: "", setTitle: nowTar)
        changeButton.topButtonDesign(setImage: "arrow.left.arrow.right", setTitle: "")
        
        translateButton.backgroundColor = .blue
        translateButton.layer.cornerRadius = 10
        translateButton.setTitle("번역하기", for: .normal)
        translateButton.setTitleColor(.white, for: .normal)
        translateButton.titleLabel?.font = .boldSystemFont(ofSize: 17)
        
        navigationItem.title = "papago"
        
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 10, weight: .regular)
        let image = UIImage(systemName: "xmark", withConfiguration: imageConfig)
        
        clearButton.setImage(image, for: .normal)
        clearButton.layer.cornerRadius = clearButton.frame.width / 2
        clearButton.backgroundColor = .gray
        clearButton.tintColor = .white
        
        
        
        
    }
    
    /*
     1. 네트워크 통신 단절 상태 (와이파이 끊긴 상태)
     2. API 콜수 (10000자)
     3. 사용자가 번역을 받은 후 번역을 계속 클릭할 경우 불필요한 호출이 이루어짐 -> 버튼에 제약 사항을 걸어줌
     4. 텍스트비교(번역이 잘 처리되었을 때)
     5. LoadingView
     6. 특정 글자 수 이상일 때만 API 호출
     */
    
    @objc func changeButtonClicked() {
        print(#function)
        let swap = srcLangButton.currentTitle!
        let swapKey = nowSrc
        srcLangButton.setTitle(tarLangButton.currentTitle!, for: .normal)
        nowSrc = nowTar
        tarLangButton.setTitle(swap, for: .normal)
        nowTar = swapKey
    }
    
    @objc func clearButtonClicked() {
        inputTextView.text = ""
        resultLabel.text = ""
    }
    
    @objc func translateButtonClicked() {
        
        let url = "https://openapi.naver.com/v1/papago/n2mt"
        
        let headers: HTTPHeaders = [
            "X-Naver-Client-Id": APIKey.clientID,
            "X-Naver-Client-Secret": APIKey.clientSecret
        ]

        let parameters: Parameters = [
            "text": inputTextView.text!,
            "source":"\(nowSrc)",
            "target":"\(nowTar)"
        ]
        
        AF.request(url, method: .post, parameters: parameters, headers: headers).responseDecodable(of: Papago.self) { response in
            switch response.result {
            case .success(let success):
                dump(success)
                
                self.resultLabel.text = success.message.result.translatedText
            case .failure(let failure):
                print(failure)
            }
        }
        
        view.endEditing(true)
        
        
    }
    
    @objc func tarLangButtonClicked() {
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = sb.instantiateViewController(withIdentifier: LanguageViewController.identifier) as! LanguageViewController
        
        vc.nowLanguage = Language.languageDataList[nowTar]!
        
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func srcLangButtonClicked() {
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = sb.instantiateViewController(withIdentifier: LanguageViewController.identifier) as! LanguageViewController
        
        vc.nowLanguage = Language.languageDataList[nowSrc]!
        
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func setPlaceHolder() {
        if inputTextView.text.isEmpty {
            self.placeHolderLabel.text = "내용을 입력해주세요"
            self.placeHolderLabel.textColor = .lightGray
            self.placeHolderLabel.textAlignment = .center
        }
    }
}

extension UIButton {
    func topButtonDesign(setImage: String, setTitle: String) {
        
        if !setTitle.isEmpty {
            self.setTitle(Language.languageDataList[setTitle], for: .normal)
            self.setTitleColor(.black, for: .normal)
            
            self.layer.cornerRadius = 25
            self.layer.borderColor = UIColor.black.cgColor
            self.layer.borderWidth = 1
        }
        
        if !setImage.isEmpty {
            
            let imageConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .semibold)
            let image = UIImage(systemName: setImage, withConfiguration: imageConfig)
            
            self.setImage(image, for: .normal)
            self.tintColor = .black
        }
    }
}

extension ViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if !textView.text.isEmpty {
            placeHolderLabel.text = ""
        }
    }
    
    // 텍스트 커서가 없어지는 순간 -> 편집이 끝났을 때
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        print("Start")
        
//        if textView.textColor == .lightGray {
//            textView.text = nil
//            textView.textColor = .black
//        }
        
        if textView.text.isEmpty {
            placeHolderLabel.text = ""
        }
    }
    
    // 텍스트 커서가 시작하는 순간 -> 편집이 시작될 때
    func textViewDidEndEditing(_ textView: UITextView) {
        print("End")
        
        if textView.text.isEmpty {
            setPlaceHolder()
        }
    }
    
}
