//
//  ItemViewController.swift
//  BlackStar
//
//  Created by Dmitriy Lee on 26.04.2021.
//

import UIKit

class ItemViewController: UIViewController, UIScrollViewDelegate {
    
    var productImages: [ProductImages] = []
    var item: Item?
    var offers: [Offers] = []
    var frame = CGRect.zero
    var size: String?
    var color: String?
    var amount = Int()
    
    @IBOutlet weak var colorsTableView: UITableView!
    @IBOutlet weak var sizesTableView: UITableView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var addIntoBasketButton: UIButton!
    @IBOutlet weak var itemDescriptionTextView: UITextView!
    
    @IBAction func addIntoBasketAction(_ sender: Any) {
        
        if colorsTableView.isHidden == false && sizesTableView.isHidden == false {
            if color != nil && size != nil {
                if let item = item, let size = size, let color = color {
                    for i in Persistence().loadData() {
                        if item.article == i.article && item.colorName == i.color && size == i.size {
                            amount = i.amount
                            amount += 1
                        }
                    }
                    if amount > 1 {
                        Persistence().updateData(amount: amount, item: item, size: size)
                    } else {
                        Persistence().saveData(item: item, size: size, color: color, amount: amount)
                    }
                    self.navigationItem.rightBarButtonItem?.updateBadge(number: Persistence().totalAmount())
                }
                
                let alertControllerItemAdded = UIAlertController(title: "Товар добавлен", message: "", preferredStyle: .alert)
                let alertActionOk = UIAlertAction(title: "Хорошо", style: .default) { (alert) in
                }
                
                alertControllerItemAdded.addAction(alertActionOk)
                present(alertControllerItemAdded, animated: true, completion: nil)
                
                navigationItem.rightBarButtonItem?.addBadge(number: Persistence().totalAmount())
                
            } else {
                let alertControllerChooseColorAndText = UIAlertController(title: "Выберите цвет и размер", message: "", preferredStyle: .alert)
                let alertActionYes = UIAlertAction(title: "Ок", style: .default) { (alert) in
                }
                
                alertControllerChooseColorAndText.addAction(alertActionYes)
                present(alertControllerChooseColorAndText, animated: true, completion: nil)
            }
        } else {
            colorsTableView.isHidden = false
            sizesTableView.isHidden = false
        }
        
        amount = 1
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        pageControl.currentPage = Int(pageNumber)
    }
    
    func setBlackAlpha() {
        let backView = UIImageView(frame: frame)
        backView.backgroundColor = .black
        backView.alpha = 0.3
        scrollView.addSubview(backView)
    }
    
    func setProductImages() {
        for index in 0..<productImages.count {
            
            frame.origin.x = scrollView.frame.size.width * CGFloat(index)
            
            let itemImageView = UIImageView(frame: frame)
            
            DataLoader().loadImages(url: productImages[index].imageURL, view: itemImageView)
            
            scrollView.addSubview(itemImageView)
            setBlackAlpha()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        colorsTableView.isHidden = true
        sizesTableView.isHidden = true
        
        //MARK: Add badge on navigation right bar button
        navigationItem.rightBarButtonItem = navigationController?.addButton(color: .white)
        
        navigationItem.rightBarButtonItem?.addBadge(number: Persistence().totalAmount())
        
        //MARK: Get Navigation Bar invisible
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        
        //MARK: Change top bar icon
        self.navigationController?.navigationBar.backIndicatorImage = UIImage.init(systemName: "arrow.backward")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage.init(systemName: "arrow.backward")
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addIntoBasketButton.layer.cornerRadius = view.frame.size.height / 50
        
        if let item = item {
            DataLoader().loadProductImages(completion: { productImages in
                self.productImages = productImages
            }, item: item)
            
            DataLoader().loadOffers(completion: { offers in
                self.offers = offers
            }, item: item)
        }
        
        itemNameLabel.text = self.item?.name
        itemNameLabel.layer.addBorder(edge: .bottom, color: UIColor.systemGray4)
        
        
        let doublePrice = Double(item?.price ?? "")
        let intPrice = Int(doublePrice ?? 0)
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        numberFormatter.groupingSeparator = " "
        if let formattedNumber = numberFormatter.string(from: NSNumber(value:intPrice)) {
            itemPriceLabel.text = formattedNumber + "₽"
        }
        itemDescriptionTextView.text = item?.description
        
        scrollView.delegate = self
        pageControl.numberOfPages = productImages.count
        
        frame.origin.y = -91
        frame.size = scrollView.frame.size
        
        if let item = item {
            if productImages.isEmpty {
                let mainImageView = UIImageView(frame: frame)
                
                DataLoader().loadImages(url: item.mainImage, view: mainImageView)
                scrollView.addSubview(mainImageView)
                setBlackAlpha()
            } else {
                setProductImages()
            }
        }
        
        scrollView.contentSize = CGSize(width: (scrollView.frame.size.width * CGFloat(productImages.count)), height: scrollView.frame.size.height - 91)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        //MARK: Get default navigation bar design
        self.navigationController?.navigationBar.setBackgroundImage(.none, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
        
        //MARK: Change top bar icon to default
        self.navigationController?.navigationBar.backIndicatorImage = UIImage.init(systemName: "chevron.backward")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage.init(systemName: "chevron.backward")
        self.navigationController?.navigationBar.tintColor = .systemBlue
    }
}

extension ItemViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == colorsTableView {
            return offers.count
        } else if tableView == sizesTableView {
            return offers.count
        }
        return Int()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == colorsTableView {
            let colorsCell = tableView.dequeueReusableCell(withIdentifier: "ColorsCell", for: indexPath) as! ColorsTableViewCell
            
            colorsCell.delegate = self
            
            colorsCell.colorLabel.text = item?.colorName
            
            return colorsCell
        } else if tableView == sizesTableView {
            let sizesCell = tableView.dequeueReusableCell(withIdentifier: "SizesCell", for: indexPath) as! SizesTableViewCell
            
            sizesCell.delegate = self
            
            let rows = offers[indexPath.row]
            
            switch rows.size {
            case "XXS":
                sizesCell.sizeLabel.text = "37 RUS   \(rows.size)"
            case "XS":
                sizesCell.sizeLabel.text = "38 RUS   \(rows.size)"
            case "S":
                sizesCell.sizeLabel.text = "39 RUS   \(rows.size)"
            case "M":
                sizesCell.sizeLabel.text = "40 RUS   \(rows.size)"
            case "L":
                sizesCell.sizeLabel.text = "41 RUS   \(rows.size)"
            case "XL":
                sizesCell.sizeLabel.text = "42 RUS   \(rows.size)"
            case "XXL":
                sizesCell.sizeLabel.text = "43 RUS   \(rows.size)"
            default:
                sizesCell.sizeLabel.text = rows.size
            }
            
            return sizesCell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == colorsTableView {
            self.color = item?.colorName
        } else if tableView == sizesTableView {
            self.size = offers[indexPath.row].size
        }
    }
}

extension ItemViewController: SizesCellDelegate, ColorsCellDelegate {
    func getSizeLabelHidden(image: UIImageView) {
        image.isHidden = true
        self.size = nil
    }
    
    func getSizeLabelVisible(image: UIImageView) {
        image.isHidden = false
    }
    
    func getColorLabelHidden(image: UIImageView) {
        image.isHidden = true
        self.color = nil
    }
    
    func getColorLabelVisible(image: UIImageView) {
        image.isHidden = false
    }
}

