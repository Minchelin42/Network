//
//  APIManager.swift
//  Network
//
//  Created by 민지은 on 2024/01/16.
//

import Foundation
import Alamofire

struct LottoAPIManager {
    func loadData(round: Int, completionHandler: @escaping (Lotto) -> Void) {
        
        let url = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(round)"
        
        AF.request(url).responseDecodable(of: Lotto.self) { response in
            switch response.result {
            case .success(let success):
                
                completionHandler(success)
                
            case .failure(let failure):
                print("오류 발생")
            }
            
        }
    }
}

struct BeerAPIManager {
    func loadData(completionHandler: @escaping (([Beer]) -> Void)) {
        
//        let url = "https://api.punkapi.com/v2/beers/random"
        
        let url = "https://api.punkapi.com/v2/beers"
        
        AF.request(url).responseDecodable(of: [Beer].self) { response in
            switch response.result {
            case .success(let success):
//                self.beerList = success
                
                completionHandler(success)

//                self.beerCollectionView.reloadData()
                
            case .failure(let failure):
                print("오류 발생")
            }
            
        }
    }
}
