//
//  BeerViewController.swift
//  Network
//
//  Created by 민지은 on 2024/01/16.
//

import UIKit
import Alamofire
import Kingfisher

struct Beer: Codable {
    let name: String
    let description: String
    let image_url: String
}


class BeerViewController: UIViewController {

    var beerList: [Beer] = []
    let manager = BeerAPIManager()
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var beerCollectionView: UICollectionView!
    @IBOutlet var recommandButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        manager.loadData { value in
            self.beerList = value
            self.beerCollectionView.reloadData()
        }
        configureCollectionView()
        setLayout()
    }
    
    @IBAction func recommandButtonTapped(_ sender: UIButton) {
        manager.loadData { value in
            self.beerList = value
            self.beerCollectionView.reloadData()
        }
    }
}

extension BeerViewController: ViewProtocol {
    func configureView() {
        titleLabel.text = "오늘의 추천 맥주입니다"
        titleLabel.textAlignment = .center
        titleLabel.font = .boldSystemFont(ofSize: 18)
        
        recommandButton.setTitle("다른 맥주 추천받기", for: .normal)
        recommandButton.backgroundColor = .systemYellow
        recommandButton.layer.cornerRadius = 15
        recommandButton.setTitleColor(.white, for: .normal)
    }
}

extension BeerViewController {
    func configureCollectionView() {
        
        beerCollectionView.delegate = self
        beerCollectionView.dataSource = self
        
        let xib = UINib(nibName: "BeerCollectionViewCell", bundle: nil)
        beerCollectionView.register(xib, forCellWithReuseIdentifier: "BeerCollectionViewCell")
    }
    
    func setLayout() {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 8
        
        let cellWidth = UIScreen.main.bounds.width
        let cellHeight = cellWidth * 1.5
        
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.scrollDirection = .vertical
        
        beerCollectionView.collectionViewLayout = layout
    }
}

extension BeerViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return beerList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  beerCollectionView.dequeueReusableCell(withReuseIdentifier: "BeerCollectionViewCell", for: indexPath) as! BeerCollectionViewCell
        
        print(beerList[indexPath.row].name)
        
        let url = URL(string: beerList[indexPath.row].image_url)
        cell.beerIMG.kf.setImage(with: url)
        cell.beerIMG.contentMode = .scaleAspectFit
        cell.beerName.text = beerList[indexPath.row].name
        cell.beerName.numberOfLines = 0
        cell.beerName.textAlignment = .center
        cell.beerDescription.text = beerList[indexPath.row].description
        cell.beerDescription.numberOfLines = 0
        cell.beerDescription.textAlignment = .center
        
        cell.backgroundColor = .blue
        return cell
    }
    
}
