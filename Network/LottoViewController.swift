//
//  LottoViewController.swift
//  Network
//
//  Created by 민지은 on 2024/01/16.
//

import UIKit
import Alamofire

struct Lotto: Codable{
    let drwtNo1: Int
    let drwtNo2: Int
    let drwtNo3: Int
    let drwtNo4: Int
    let drwtNo5: Int
    let drwtNo6: Int
    let bnusNo: Int
}

class LottoViewController: UIViewController {

    @IBOutlet var selectRoundTextField: UITextField!
    @IBOutlet var lottoNumber: [UILabel]!
    
    var lottoPickerView = UIPickerView()
    
    let numberList: [Int] = Array(1...1025).reversed()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectRoundTextField.tintColor = .clear
        selectRoundTextField.inputView = lottoPickerView
        
        lottoPickerView.delegate = self
        lottoPickerView.dataSource = self
        
        for index in 0...6 {
            lottoNumber[index].font = .systemFont(ofSize: 17, weight: .semibold)
            lottoNumber[index].textAlignment = .center
        }

    }
    
    func loadData(round: Int) {
        
        let url = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(round)"
        
        AF.request(url).responseDecodable(of: Lotto.self) { response in
            switch response.result {
            case .success(let success):
                self.lottoNumber[0].text = "\(success.drwtNo1)"
                self.lottoNumber[1].text = "\(success.drwtNo2)"
                self.lottoNumber[2].text = "\(success.drwtNo3)"
                self.lottoNumber[3].text = "\(success.drwtNo4)"
                self.lottoNumber[4].text = "\(success.drwtNo5)"
                self.lottoNumber[5].text = "\(success.drwtNo6)"
                self.lottoNumber[6].text = "+ \(success.bnusNo)"
                
            case .failure(let failure):
                print("오류 발생")
            }
            
        }
    }
    
}


extension LottoViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numberList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectRoundTextField.text = "\(numberList[row])회차"
        selectRoundTextField.font = .systemFont(ofSize: 17, weight: .semibold)
        selectRoundTextField.textAlignment = .center
        
        loadData(round: numberList[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(numberList[row])회차"
    }
}
