//
//  BookViewController.swift
//  Network
//
//  Created by 민지은 on 2024/01/17.
//

import UIKit
import Alamofire
import Kingfisher

struct Book : Codable {
    let documents: [Document]
    let meta: Meta
}

struct Document: Codable {
    let authors: [String]
    let contents, datetime, isbn: String
    let price: Int
    let publisher: String
    let salePrice: Int
    let status: String
    let thumbnail: String
    let title: String
    let url: String

    enum CodingKeys: String, CodingKey {
        case authors, contents, datetime, isbn, price, publisher
        case salePrice = "sale_price"
        case status, thumbnail, title, url
    }
}

struct Meta: Codable {
    let isEnd: Bool
    let pageableCount, totalCount: Int

    enum CodingKeys: String, CodingKey {
        case isEnd = "is_end"
        case pageableCount = "pageable_count"
        case totalCount = "total_count"
    }
}


class BookViewController: UIViewController {

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var bookCollectionView: UICollectionView!
    
    var bookList: [Document] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureCollectionView()
        setLayout()

    }
    
    func callRequest(text: String) {
        
        //만약 한글 검색이 안된다면 인코딩 처리
        let query = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let url = "https://dapi.kakao.com/v3/search/book?query=\(query)&size=50"

        let headers: HTTPHeaders = [
            "Authorization": APIKey.kakaoKey
        ]

        AF.request(url, method: .post, headers: headers).responseDecodable(of: Book.self) { response in
            switch response.result {
            case .success(let success):
                dump(success.documents)
                
                self.bookList = success.documents
                
                self.bookCollectionView.reloadData()
                
            case .failure(let failure):
                print(failure)
            }
        }
    }

}

extension BookViewController: ViewProtocol {
    func configureView() {
        self.searchBar.delegate = self
    }
}

extension BookViewController {
    func configureCollectionView() {
        bookCollectionView.delegate = self
        bookCollectionView.dataSource = self
        
        let xib = UINib(nibName: BookCollectionViewCell.identifier, bundle: nil)
        bookCollectionView.register(xib, forCellWithReuseIdentifier: BookCollectionViewCell.identifier)
    }
    
    func setLayout() {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 8
        
        let cellWidth = UIScreen.main.bounds.width - 24
        let cellHeight = cellWidth / 2
        
        layout.itemSize = CGSize(width: cellWidth / 2, height: cellHeight)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.scrollDirection = .vertical
        
        bookCollectionView.collectionViewLayout = layout
    }
}

extension BookViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bookList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = bookCollectionView.dequeueReusableCell(withReuseIdentifier: BookCollectionViewCell.identifier, for: indexPath) as! BookCollectionViewCell
        
        let url = URL(string: bookList[indexPath.row].thumbnail)
        cell.bookIMG.kf.setImage(with: url)
        
        var autherName = ""
        
        if bookList[indexPath.row].authors.isEmpty {
            cell.authorLabel.text = "작가 미상"
        } else {
            
            for index in 0..<bookList[indexPath.row].authors.count {
                if index == 0 {
                    autherName = autherName + bookList[indexPath.row].authors[index]
                } else {
                    autherName = autherName + "," + bookList[indexPath.row].authors[index]
                }
            }
            cell.authorLabel.text = "지음"
        }
        
        cell.authorNameLabel.text = autherName
        cell.titleLabel.text = bookList[indexPath.row].title

        return cell
    }
    
    
}


extension BookViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        callRequest(text: searchBar.text!)
    }
}

