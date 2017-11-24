//
//  FilterTableViewCell.swift
//  clothr
//
//  Created by Andrew Guterres on 11/20/17.
//  Copyright © 2017 cmps115. All rights reserved.
//

import UIKit
import Parse

class FilterTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {

    //need to: archive picked arrays, figure out sizes if possible, categories?, archive checklists (may want to use dictionary for checklists)
    @IBOutlet weak var filterCollection: UICollectionView!
    @IBOutlet weak var savedFilters: UICollectionView!
    @IBOutlet weak var filterHeight: NSLayoutConstraint!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var Filter: UIView!
    @IBOutlet weak var FilterLabel: UILabel!
    @IBOutlet weak var FilterView: UIView!
    var savedImages=NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "images") as! Data) as? [Any]
    var brands = NSKeyedUnarchiver.unarchiveObject(with:UserDefaults.standard.object(forKey: "brand") as! Data) as? [Any]
    var pickedBrands = NSKeyedUnarchiver.unarchiveObject(with:UserDefaults.standard.object(forKey: "pickedBrands") as! Data) as? [String]
    
    var retailers = NSKeyedUnarchiver.unarchiveObject(with:UserDefaults.standard.object(forKey: "retailer") as! Data) as? [Any]
    var pickedRetailers=NSKeyedUnarchiver.unarchiveObject(with:UserDefaults.standard.object(forKey: "pickedRetailers") as! Data) as? [String]
    
    var size : [String] = ["XXS","XS", "S", "M", "L", "XL", "XXL"]
    var pickedSizes = NSKeyedUnarchiver.unarchiveObject(with:UserDefaults.standard.object(forKey: "pickedSizes") as! Data) as? [String]
    
    var retailerCheck = NSKeyedUnarchiver.unarchiveObject(with:UserDefaults.standard.object(forKey: "retailerCheck") as! Data) as? [NSInteger]
    var brandCheck = NSKeyedUnarchiver.unarchiveObject(with:UserDefaults.standard.object(forKey: "brandCheck") as! Data) as? [NSInteger]
    var sizeCheck=NSKeyedUnarchiver.unarchiveObject(with:UserDefaults.standard.object(forKey: "sizeCheck") as! Data) as? [NSInteger]
    var colorCheck=NSKeyedUnarchiver.unarchiveObject(with:UserDefaults.standard.object(forKey: "colorCheck") as! Data) as? [NSInteger]
    
    var colors = NSKeyedUnarchiver.unarchiveObject(with:UserDefaults.standard.object(forKey: "color") as! Data) as? [Any]
    var pickedColors = NSKeyedUnarchiver.unarchiveObject(with:UserDefaults.standard.object(forKey: "pickedColors") as! Data) as? [String]
    
    var pickedIndexes=NSKeyedUnarchiver.unarchiveObject(with:UserDefaults.standard.object(forKey: "pickedIndexes") as! Data) as? [String: NSInteger] //indexes for filter collections
    var pickedUserFilters=NSKeyedUnarchiver.unarchiveObject(with:UserDefaults.standard.object(forKey: "pickedUserFilters") as! Data) as? [Any]  //array filled with pssproductfilters
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        retailerCheck = [NSInteger](repeating:0, count:(retailers?.count)!)
//        brandCheck = [NSInteger](repeating:0, count:(brands?.count)!)
        sizeCheck = [NSInteger](repeating:0, count:size.count)
//        colorCheck = [NSInteger](repeating:0, count:(colors?.count)!)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var showsDetails = false {
        didSet {
            filterHeight.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(showsDetails ? 250 : 999))
        }
    }
//-----------------------------------------load collection view--------------------------------------------//
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        print(FilterLabel.text)
        if collectionView == self.savedFilters  //if in savedFilters collectionview
        {
            let savedCell=collectionView.dequeueReusableCell(withReuseIdentifier: "savedFilterCell", for: indexPath) as! FilterCollectionViewCell
            //set up cell
            setupChosenCell(savedCell)
            savedCell.savedFilterLabel.textColor=UIColor.white
            let text = FilterLabel.text
            if text == "Retailer"
            {
                savedCell.savedFilterLabel.text = (pickedRetailers?[indexPath.row] )
            } else if text == "Brand"
            {
                savedCell.savedFilterLabel.text=(pickedBrands?[indexPath.row])
            } else if text == "Size"
            {
                savedCell.savedFilterLabel.text=(pickedSizes?[indexPath.row])
            } else if text == "Color"
            {
                savedCell.savedFilterLabel.text=(pickedColors?[indexPath.row])
            } else if text == "Size of Clothing"
            {
                savedCell.savedFilterLabel.text=(pickedSizes?[indexPath.row])
            }
            return savedCell
        } else //if in filterCollection viewController
        {
            let filterCell=collectionView.dequeueReusableCell(withReuseIdentifier: "currentFilterCell", for: indexPath) as! FilterCollectionViewCell
            //set up cell
            let background = filterCell.currentFilterBackground
            background?.image=UIImage(named:"background")
            background?.layer.cornerRadius=(background?.frame.size.width)!/2
            background?.clipsToBounds=true
            background?.layer.borderWidth=3.0
            background?.layer.borderColor=UIColor.black.cgColor
            filterCell.currentFilterLabel.textColor=UIColor.black
            let text = FilterLabel.text
            if text == "Retailer"
            {
                if retailerCheck![indexPath.row] == 1
                {
                    setupRegularCell(filterCell)
                    filterCell.currentFilterLabel.textColor=UIColor.white
                }
                let filter: PSSRetailer? = (retailers![indexPath.row] as! PSSRetailer)
                filterCell.currentFilterLabel.text = filter?.name
            } else if text == "Brand"
            {
                if brandCheck![indexPath.row] == 1
                {
                    setupRegularCell(filterCell)
                    filterCell.currentFilterLabel.textColor=UIColor.white
                }
                let filter: PSSBrand? = (brands![indexPath.row] as! PSSBrand)
                filterCell.currentFilterLabel.text=filter?.name
            } else if text == "Size"
            {
                if sizeCheck![indexPath.row] == 1
                {
                    setupRegularCell(filterCell)
                    filterCell.currentFilterLabel.textColor=UIColor.white
                }
                let filter: String = size[indexPath.row]
                filterCell.currentFilterLabel.text=filter
            } else if text == "Color"
            {
                if colorCheck![indexPath.row] == 1
                {
                    setupRegularCell(filterCell)
                    filterCell.currentFilterLabel.textColor=UIColor.white
                }
                let filter: PSSColor? = (colors![indexPath.row] as! PSSColor)
                filterCell.currentFilterLabel.text=filter?.name
            } else if text == "Size of Clothing"
            {
                let filter: String = size[indexPath.row]
                filterCell.currentFilterLabel.text=filter
            }
            
            return filterCell
        }
        
    }
    
    func setupRegularCell(_ filterCell: FilterCollectionViewCell)
    {
        let background = filterCell.currentFilterBackground
        background?.image=UIImage(named:"black")
        background?.layer.cornerRadius=(background?.frame.size.width)!/2
        background?.clipsToBounds=true
        background?.layer.borderWidth=3.0
        background?.layer.borderColor=UIColor.black.cgColor
    }
    
    func setupChosenCell(_ filterCell: FilterCollectionViewCell)
    {
        let background = filterCell.savedFilterBackground
        background?.image=UIImage(named:"black")
        background?.layer.cornerRadius=(background?.frame.size.width)!/2
        background?.clipsToBounds=true
        background?.layer.borderWidth=3.0
        background?.layer.borderColor=UIColor.black.cgColor
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView==self.savedFilters
        {
            switch FilterLabel.text
            {
            case "Retailer"?: return pickedRetailers!.count
            case "Brand"?: return pickedBrands!.count
            case "Size"?: return pickedSizes!.count
            case "Color"?: return pickedColors!.count
            case "Type of Clothing"?: return pickedSizes!.count
            default:
                return 0
            }
        } else
        {
            switch FilterLabel.text
            {
            case "Retailer"?: return retailers!.count
            case "Brand"?: return brands!.count
            case "Size"?: return size.count
            case "Color"?: return colors!.count
            case "Type of Clothing"?: return size.count
            default:
                return 0
            }
        }
        
    }
//--------------------------------if cell was chosen-------------------------------------//
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        addToList.append(objectsArray[indexPath.row])
//        let cell=collectionView.cellForItem(at: indexPath)
        print("touched filter")
        if collectionView==self.savedFilters
        {
            let filterCell=collectionView.cellForItem(at: indexPath) as! FilterCollectionViewCell
            let text = FilterLabel.text
            if text == "Retailer"
            {
                pickedRetailers?.remove(at: indexPath.row) //remove filter from array
                savedFilters!.deleteItems(at: [NSIndexPath(row: indexPath.row,section:0) as IndexPath]) //delete the cell
                retailerCheck![(pickedIndexes![filterCell.savedFilterLabel.text!])!]=0 //update the filter collection
                pickedIndexes!.removeValue(forKey: filterCell.savedFilterLabel.text!) //remove from global dictionary
                saveRetailers()
                saveIndexes()
                filterCollection?.reloadData() //reload views
                savedFilters?.reloadData()
            } else if text == "Brand"
            {
                pickedBrands!.remove(at: indexPath.row)
                savedFilters!.deleteItems(at: [NSIndexPath(row: indexPath.row,section:0) as IndexPath])
                brandCheck![(pickedIndexes![filterCell.savedFilterLabel.text!])!]=0
                pickedIndexes!.removeValue(forKey: filterCell.savedFilterLabel.text!) //remove from global dictionary
                saveBrands()
                saveIndexes()
                filterCollection?.reloadData()
                savedFilters?.reloadData()
            } else if text == "Size"
            {
                pickedSizes!.remove(at: indexPath.row) //remove filter from array
                savedFilters!.deleteItems(at: [NSIndexPath(row: indexPath.row,section:0) as IndexPath]) //delete the cell
                sizeCheck![(pickedIndexes![filterCell.savedFilterLabel.text!])!]=0 //update the filter collection
                pickedIndexes!.removeValue(forKey: filterCell.savedFilterLabel.text!) //remove from global dictionary
                saveSizes()
                saveIndexes()
                filterCollection?.reloadData() //reload views
                savedFilters?.reloadData()
            } else if text == "Color"
            {
                pickedColors!.remove(at: indexPath.row) //remove filter from array
                savedFilters!.deleteItems(at: [NSIndexPath(row: indexPath.row,section:0) as IndexPath]) //delete the cell
                colorCheck![(pickedIndexes![filterCell.savedFilterLabel.text!])!]=0 //update the filter collection
                pickedIndexes!.removeValue(forKey: filterCell.savedFilterLabel.text!) //remove from global dictionary
                saveColors()
                saveIndexes()
                filterCollection?.reloadData() //reload views
                savedFilters?.reloadData()
            } else if text == "Size of Clothing"
            {
                pickedSizes!.remove(at: indexPath.row) //remove filter from array
                savedFilters!.deleteItems(at: [NSIndexPath(row: indexPath.row,section:0) as IndexPath]) //delete the cell
                sizeCheck![(pickedIndexes![filterCell.savedFilterLabel.text!])!]=0 //update the filter collection
                pickedIndexes!.removeValue(forKey: filterCell.savedFilterLabel.text!) //remove from global dictionary
                saveSizes()
                saveIndexes()
                filterCollection?.reloadData() //reload views
                savedFilters?.reloadData()
            }
        } else //in filter collection
        {
            let filterCell=collectionView.cellForItem(at: indexPath) as! FilterCollectionViewCell
            if pickedIndexes![filterCell.currentFilterLabel.text!] == nil  //if cell was not chosen previously. chosen now
            {
                filterCell.currentFilterBackground.image=UIImage(named: "black")
                filterCell.currentFilterLabel.textColor = UIColor.white
                let text = FilterLabel.text
                if text == "Retailer"
                {
                    pickedRetailers!.append(filterCell.currentFilterLabel.text!)
                    savedFilters!.insertItems(at: [NSIndexPath(row: pickedRetailers!.count-1,section:0) as IndexPath])
                    retailerCheck![indexPath.row]=1
                    pickedIndexes![filterCell.currentFilterLabel.text!] = indexPath.row
                    let pickedRetailer: PSSRetailer? = (retailers![indexPath.row] as! PSSRetailer)
                    let pickedFilter = PSSProductFilter(type: "Retailer", filterID: pickedRetailer?.retailerID)
                    pickedUserFilters!.append(pickedFilter as Any)
                    saveRetailers()
                    saveUserFilters()
                    savePickedIndexes()
                    savedFilters?.reloadData()
                } else if text == "Brand"
                {
                    pickedBrands!.append(filterCell.currentFilterLabel.text!)
                    savedFilters!.insertItems(at: [NSIndexPath(row: pickedBrands!.count-1,section:0) as IndexPath])
                    brandCheck![indexPath.row]=1
                    pickedIndexes![filterCell.currentFilterLabel.text!] = indexPath.row
                    let pickedBrand: PSSBrand? = (brands![indexPath.row] as! PSSBrand)
                    let pickedFilter = PSSProductFilter(type: "Brand", filterID: pickedBrand?.brandID)
                    pickedUserFilters!.append(pickedFilter as Any)
                    saveUserFilters()
                    saveBrands()
                    savePickedIndexes()
                    savedFilters?.reloadData()
                } else if text == "Size"
                {
                    pickedSizes!.append(filterCell.currentFilterLabel.text!)
                    savedFilters!.insertItems(at: [NSIndexPath(row: pickedSizes!.count-1,section:0) as IndexPath])
                    sizeCheck![indexPath.row]=1
                    pickedIndexes![filterCell.currentFilterLabel.text!] = indexPath.row
//                    let pickedSize: PSSSize? = (size[indexPath.row] as! PSSSize)
//                    let pickedFilter = PSSProductFilter(type: "Size", filterID: pickedSize?.sizeID)
//                    pickedUserFilters.append(pickedFilter as Any)
//                    let encodedProduct = NSKeyedArchiver.archivedData(withRootObject: pickedUserFilters)
//                    let defaults = UserDefaults.standard
//                    defaults.set(encodedProduct, forKey: "userFilters")
                    saveSizes()
                    savePickedIndexes()
                    savedFilters?.reloadData()
                } else if text == "Color"
                {
                    pickedColors!.append(filterCell.currentFilterLabel.text!)
                    savedFilters!.insertItems(at: [NSIndexPath(row: pickedColors!.count-1,section:0) as IndexPath])
                    colorCheck![indexPath.row]=1
                    pickedIndexes![filterCell.currentFilterLabel.text!] = indexPath.row
                    let pickedColor: PSSColor? = (colors![indexPath.row] as! PSSColor)
                    let pickedFilter = PSSProductFilter(type: "Color", filterID: pickedColor?.colorID)
                    pickedUserFilters!.append(pickedFilter as Any)
                    saveColors()
                    saveUserFilters()
                    savePickedIndexes()
                    savedFilters?.reloadData()
                } else if text == "Size of Clothing"
                {
                    pickedSizes!.append(filterCell.currentFilterLabel.text!)
                    savedFilters!.insertItems(at: [NSIndexPath(row: pickedSizes!.count-1,section:0) as IndexPath])
                    sizeCheck![indexPath.row]=1
                    pickedIndexes![filterCell.currentFilterLabel.text!] = indexPath.row
                    saveUserFilters()
                    saveSizes()
                    savePickedIndexes()
                    savedFilters?.reloadData()
                }
            } else  //if cell was previously chosen
            {
                filterCell.currentFilterBackground.image=UIImage(named: "background")
                filterCell.layer.borderColor=UIColor.black.cgColor
                filterCell.currentFilterLabel.textColor = UIColor.black
                let text = FilterLabel.text
                if text == "Retailer"
                {
                    retailerCheck![indexPath.row]=0
                    pickedRetailers!.remove(at: pickedRetailers!.index(of: filterCell.currentFilterLabel.text!)!)
                    pickedIndexes!.removeValue(forKey: filterCell.currentFilterLabel.text!)
                    saveRetailers()
                    savePickedIndexes()
                    filterCollection?.reloadData()
                    savedFilters?.reloadData()
                } else if text == "Brand"
                {
                    brandCheck![indexPath.row]=0
                    pickedBrands!.remove(at: pickedBrands!.index(of: filterCell.currentFilterLabel.text!)!)
                    pickedIndexes!.removeValue(forKey: filterCell.currentFilterLabel.text!)
                    saveBrands()
                    savePickedIndexes()
                    filterCollection?.reloadData()
                    savedFilters?.reloadData()
                } else if text == "Size"
                {
                    sizeCheck![indexPath.row]=0
                    pickedSizes!.remove(at: pickedSizes!.index(of: filterCell.currentFilterLabel.text!)!)
                    pickedIndexes!.removeValue(forKey: filterCell.currentFilterLabel.text!)
                    saveSizes()
                    savePickedIndexes()
                    filterCollection?.reloadData()
                    savedFilters?.reloadData()
                } else if text == "Color"
                {
                    colorCheck![indexPath.row]=0
                    pickedColors!.remove(at: pickedColors!.index(of: filterCell.currentFilterLabel.text!)!)
                    pickedIndexes!.removeValue(forKey: filterCell.currentFilterLabel.text!)
                    saveColors()
                    savePickedIndexes()
                    filterCollection?.reloadData()
                    savedFilters?.reloadData()
                } else if text == "Size of Clothing"
                {
                    savedFilters?.reloadData()
                    sizeCheck![indexPath.row]=0
                    pickedSizes!.remove(at: pickedSizes!.index(of: filterCell.currentFilterLabel.text!)!)
                    pickedIndexes!.removeValue(forKey: filterCell.currentFilterLabel.text!)
                    saveSizes()
                    savePickedIndexes()
                    filterCollection?.reloadData()
                    savedFilters?.reloadData()
                }
                
            }
            
        }
    }
//archiving data
    func saveIndexes()
    {
        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: pickedIndexes as Any), forKey: "pickedIndexes")
    }
    
    func saveRetailers()
    {
        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: pickedRetailers as Any), forKey: "pickedRetailers")
        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: retailerCheck as Any), forKey: "retailerCheck")
    }
    
    func saveBrands()
    {
        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: pickedBrands as Any), forKey: "pickedBrands")
        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: brandCheck as Any), forKey: "brandCheck")
    }
    
    func saveSizes()
    {
        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: pickedSizes as Any), forKey: "pickedSizes")
    }
    
    func saveColors()
    {
        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: pickedColors as Any), forKey: "pickedColors")
        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: colorCheck as Any), forKey: "colorCheck")
    }
    
    func saveUserFilters()
    {
        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: pickedUserFilters as Any), forKey: "pickedUserFilters")
    }
    
    func savePickedIndexes()
    {
         UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: pickedIndexes as Any), forKey: "pickedIndexes")
    }
}

