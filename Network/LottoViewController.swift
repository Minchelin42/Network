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
    
    let manager = LottoAPIManager()
    
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
    
    @IBAction func viewTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
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
        
        manager.loadData(round: numberList[row]) { value in
            self.lottoNumber[0].text = "\(value.drwtNo1)"
            self.lottoNumber[1].text = "\(value.drwtNo2)"
            self.lottoNumber[2].text = "\(value.drwtNo3)"
            self.lottoNumber[3].text = "\(value.drwtNo4)"
            self.lottoNumber[4].text = "\(value.drwtNo5)"
            self.lottoNumber[5].text = "\(value.drwtNo6)"
            self.lottoNumber[6].text = "+ \(value.bnusNo)"
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(numberList[row])회차"
    }
}
