
//
//  UBClassifiedCreateVC.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 18/09/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
class UBClassifiedCreateVC: UIViewController {
    @IBOutlet weak var tblViewss : UITableView!
    var numberOfRows : Int?
    var numberOfSection : Int?
    var subSubCat : CategoriesList?
    var selectSubCategoriesList : SubCategoriesList?

    var morePhotos: [UIImage]? = []
    var cover_image: UIImage?
    var titleOfItem : String?
    var priceOfItem : String?
    var phoneNum : String?
    var loc : String?
    var descriptionOfItem : String?
    var isPostAnonymous : Int?
    
    // category_id  is constant
    // sub_category_id its the car id from start
    // sub_sub_category after
    
    private  var fieldItem : [FieldClassified] = []
    var param =    [ : ] as [String : Any]
    
    var dict = Dictionary<String, Array<String>>()
    var arrayOfDict : NSMutableDictionary = [:]
    
    var paramDicts = Dictionary<String , String>()
    
    var selectCategorieId : String?
    var selectsubSubCat : String?
    var lastSubCategorie : String?
    
    var last_category_id : String?
    
    var myClassified : ClassifiedPost?
    var isAnonyMoust : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dict =  [:]
        last_category_id = "0".localized()
        if selectSubCategoriesList != nil {
            if (selectSubCategoriesList?.subSubCat!.count)! > 0 {
                numberOfSection = 2
            } else {
                numberOfSection = 1
            }

        } else {
            numberOfSection = 1
        }
        
        tblViewss.registerCells([
            CategorieHeaderCell.self , ClassifiedAddFooterCell.self ,
            ])
        for (_ , obj) in (subSubCat?.formList?.enumerated())! {
            fieldItem.append(FieldClassified(field_name: obj.field_name! , listItemId: "0"))
        }
        tblViewss.delegate = self
        tblViewss.dataSource = self
        tblViewss.reloadData()
    }
    
    @IBAction private func btnAddClassified_Pressed(_ sender : UIButton) {
        print(fieldItem)
        for (index  , obj) in self.fieldItem.enumerated() {
            paramDicts[obj.field_name] = obj.listItemId
        }
//        let subCategoryId = subSubCat?.id
//        let subSubCategoryId = selectSubCategoriesList?.id
//
        paramDicts["phone"] = phoneNum
        paramDicts["post_title"] = titleOfItem
        paramDicts["price"] = priceOfItem
        paramDicts["description"] = descriptionOfItem
        paramDicts["location"] = loc
        paramDicts["user_as"] = "\(isPostAnonymous!)"
        paramDicts["category_id"] = "2"
        paramDicts["sub_category_id"] = selectCategorieId
        paramDicts["sub_sub_category"] = selectsubSubCat
        paramDicts["last_sub_category"] = lastSubCategorie
//        morePhotos?.insert(cover_image!, at: 0)
        WebServiceManager.multiPartImageMorePhotos(params: paramDicts as Dictionary<String, AnyObject>, morePhotos: morePhotos , serviceName:CLASSIFIEDCREATE, imageParam: "file", serviceType: "", profileImage: cover_image, cover_image_param: "", cover_image: nil, modelType: UserResponse.self, success: { (response) in
            
            let parseResponse = response as! UserResponse
            if parseResponse.status == true {
                self.showAlertViewWithTitle(title: KMessageTitle , message: parseResponse.message!, dismissCompletion: {
                    self.navigationController?.popToRootViewController(animated: true)
                })
                
            }else {
                self.showAlert(title: "Error".localized(), message: parseResponse.message!, controller: self)
            }
        }, fail: { (error) in
            self.showAlert(title: "Error".localized(), message: "no internet".localized(), controller: self)
            
        })
        
        
    }
    
}

extension UBClassifiedCreateVC : UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if selectSubCategoriesList != nil {
            if (selectSubCategoriesList?.subSubCat!.count)! > 0 {
                return 2
            } else {
                return 1
            }
        } else {
            return 1
        }

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectSubCategoriesList != nil {
            if (selectSubCategoriesList?.subSubCat!.count)! > 0 {
                if section == 0 {
                    return 1
                } else {
                    return subSubCat?.formList?.count ?? 0
                }
            } else {
                return subSubCat?.formList?.count ?? 0
            }

        } else {
            return subSubCat?.formList?.count ?? 0

        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if selectSubCategoriesList != nil {
            if (selectSubCategoriesList?.subSubCat!.count)! > 0 {
                if indexPath.section == 0 {
                    let cell = tableView.dequeueReusableCell(with: CategorieHeaderCell.self, for: indexPath)
                    let titleOfItem = selectSubCategoriesList?.subSubCat![indexPath.row].categoryTitle
                    cell.btnCategorie.setTitle(titleOfItem, for: .normal)
                    cell.delegate = self
                    cell.indexSelect = indexPath
                    return cell
                } else {
                    if  subSubCat?.formList![indexPath.row].type == 1 {
                        let cell = tableView.dequeueReusableCell(with: ClassifiedAddFooterCell.self, for: indexPath)
                        cell.titleOfCategorie.tag = indexPath.row
                        cell.titleOfCategorie.delegate = self
                        cell.titleOfCategorie.placeholder = subSubCat?.formList![indexPath.row].field_name
                        return cell
                    } else {
                        let cell = tableView.dequeueReusableCell(with: CategorieHeaderCell.self, for: indexPath)
                        let titleOfItem = subSubCat?.formList![indexPath.row].title_english
                        cell.btnCategorie.setTitle(titleOfItem, for: .normal)
                        cell.delegate = self
                        cell.indexSelect = indexPath
                        return cell
                    }
                }
            }         else {
                if  subSubCat?.formList![indexPath.row].type == 1 {
                    let cell = tableView.dequeueReusableCell(with: ClassifiedAddFooterCell.self, for: indexPath)
                    cell.titleOfCategorie.tag = indexPath.row
                    cell.titleOfCategorie.delegate = self
                    cell.titleOfCategorie.placeholder = subSubCat?.formList![indexPath.row].field_name
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(with: CategorieHeaderCell.self, for: indexPath)
                    let titleOfItem = subSubCat?.formList![indexPath.row].title_english
                    cell.btnCategorie.setTitle(titleOfItem, for: .normal)
                    cell.delegate = self
                    cell.indexSelect = indexPath
                    return cell
                }
                
            }

        }
        else {
            if  subSubCat?.formList![indexPath.row].type == 1 {
                let cell = tableView.dequeueReusableCell(with: ClassifiedAddFooterCell.self, for: indexPath)
                cell.titleOfCategorie.tag = indexPath.row
                cell.titleOfCategorie.delegate = self
                cell.titleOfCategorie.placeholder = subSubCat?.formList![indexPath.row].field_name
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(with: CategorieHeaderCell.self, for: indexPath)
                let titleOfItem = subSubCat?.formList![indexPath.row].title_english
                cell.btnCategorie.setTitle(titleOfItem, for: .normal)
                cell.delegate = self
                cell.indexSelect = indexPath
                return cell
            }

        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension UBClassifiedCreateVC : CategorieCellDelegate {
    func categorieSelect(cell : CategorieHeaderCell , selectIndex : IndexPath) {
        if selectSubCategoriesList != nil {
            if (selectSubCategoriesList?.subSubCat!.count)! > 0 {
                if selectIndex.section == 0 {
                    var allOptionSelect  = [String]()
                    
                    for (_ , info) in (selectSubCategoriesList?.subSubCat!.enumerated())! {
                        allOptionSelect.append(info.categoryTitle!)
                    }
                    
                    ActionSheetStringPicker.show(withTitle: " ", rows: allOptionSelect , initialSelection: 0 , doneBlock: { [weak self](picker, index, value) in
                        let category = self!.selectSubCategoriesList?.subSubCat![index]
                        cell.btnCategorie.setTitle(category?.categoryTitle , for: .normal)
                        self!.last_category_id = category?.categoryTitle
                        //                    self?.fieldItem[selectIndex.row].listItemId = "\(category!.list_item_id!)"
                        
                        return
                        }, cancel: { (actionStrin ) in
                    }, origin: cell.btnCategorie)
                } else {
                    var allOptionSelect  = [String]()
                    for (_ , info) in (subSubCat?.formList![selectIndex.row].optionList!.enumerated())! {
                        allOptionSelect.append(info.title_english!)
                    }
                    
                    let titleOFSelect = subSubCat?.formList![selectIndex.row].title_english
                    let selectTitle = "Select".localized() + " \(titleOFSelect!)"
                    ActionSheetStringPicker.show(withTitle: selectTitle , rows: allOptionSelect , initialSelection: 0 , doneBlock: { [weak self](picker, index, value) in
                        let category = self!.subSubCat?.formList![selectIndex.row].optionList![index]
                        cell.btnCategorie.setTitle(category?.title_english , for: .normal)
                        self?.fieldItem[selectIndex.row].listItemId = "\(category!.list_item_id!)"
                        
                        return
                        }, cancel: { (actionStrin ) in
                    }, origin: cell.btnCategorie)
                }
            }
                
            else {
                var allOptionSelect  = [String]()
                for (_ , info) in (subSubCat?.formList![selectIndex.row].optionList!.enumerated())! {
                    allOptionSelect.append(info.title_english!)
                }
                
                let titleOFSelect = subSubCat?.formList![selectIndex.row].title_english
                let selectTitle = "Select".localized() + " \(titleOFSelect!)"

                ActionSheetStringPicker.show(withTitle: selectTitle , rows: allOptionSelect , initialSelection: 0 , doneBlock: { [weak self](picker, index, value) in
                    let category = self!.subSubCat?.formList![selectIndex.row].optionList![index]
                    cell.btnCategorie.setTitle(category?.title_english , for: .normal)
                    self?.fieldItem[selectIndex.row].listItemId = "\(category!.list_item_id!)"
                    
                    return
                    }, cancel: { (actionStrin ) in
                }, origin: cell.btnCategorie)
            }
        } else {
            var allOptionSelect  = [String]()
            for (_ , info) in (subSubCat?.formList![selectIndex.row].optionList!.enumerated())! {
                allOptionSelect.append(info.title_english!)
            }
            let titleOFSelect = subSubCat?.formList![selectIndex.row].title_english
            let selectTitle = "Select".localized() + " \(titleOFSelect!)"

            ActionSheetStringPicker.show(withTitle: selectTitle , rows: allOptionSelect , initialSelection: 0 , doneBlock: { [weak self](picker, index, value) in
                let category = self!.subSubCat?.formList![selectIndex.row].optionList![index]
                cell.btnCategorie.setTitle(category?.title_english , for: .normal)
                self?.fieldItem[selectIndex.row].listItemId = "\(category!.list_item_id!)"
                
                return
                }, cancel: { (actionStrin ) in
            }, origin: cell.btnCategorie)
        }



     }
}

extension UBClassifiedCreateVC : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let tag = textField.tag
        self.fieldItem[tag].listItemId  = textField.text!

        print("Ahmad")
        
        return true
    }
}


extension Dictionary where Key == String, Value == Any {
    
    mutating func appendss(anotherDict:[String:Any]) {
        for (key, value) in anotherDict {
            self.updateValue(value, forKey: key)
        }
    }
}

extension Sequence {
    func map<T>(_ keyPath: KeyPath<Element, T>) -> [T] {
        return map { $0[keyPath: keyPath] }
    }
}
