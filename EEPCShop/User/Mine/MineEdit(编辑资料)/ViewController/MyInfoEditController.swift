//
//  MyInfoEditController.swift
//  EEPCShop
//
//  Created by Mac Pro on 2019/4/17.
//  Copyright © 2019年 CHENNIAN. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher
import TOCropViewController


class MyInfoEditController: SNBaseViewController {
    var model:UserModel?
    var imgBase64:String = ""
    var imgData:Data?

    fileprivate var cell:InfoEditCell = InfoEditCell()

    var croppingStyle:TOCropViewCroppingStyle?
    
    var cellType :[WalletInfoType] = []
    
    fileprivate let tableView:UITableView = UITableView().then{
        $0.backgroundColor = Color(0xf5f5f5)
        $0.register(InfoEditCell.self)

        $0.separatorStyle = .none
    }
    override func loadData() {
        
    }
    
    override func setupView() {
        self.title = "编辑资料"
        
        self.view.backgroundColor = Color(0xffffff)
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.right.equalToSuperview()
        }
    }
    
    
    fileprivate func pikerView(){
        
        let alertController = UIAlertController.init(title: nil, message: nil, preferredStyle:.actionSheet)
        let defaultAction = UIAlertAction.init(title: "相册", style: .default, handler: { (UIAlertAction) in
            self.croppingStyle = .default
            let standardPicker = UIImagePickerController.init()
            standardPicker.sourceType = .photoLibrary
            standardPicker.allowsEditing = false
            standardPicker.delegate = self
            self.present(standardPicker, animated: true, completion: nil)
        })
        
        
        let profileAction = UIAlertAction.init(title: "相机", style: .default, handler: { (UIAlertAction) in
            self.croppingStyle = .default
            let profilePicker = UIImagePickerController.init()
            profilePicker.sourceType = .camera
            profilePicker.allowsEditing = false
            profilePicker.delegate = self
            self.present(profilePicker, animated: true, completion: nil)
        })
        
        let acancel = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        
        alertController.addAction(defaultAction)
        alertController.addAction(profileAction)
        alertController.addAction(acancel)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func uploadImg(_ imgBase64:String,_ name:String,_ img:Data){
        let url = httpUrl + "/member/updateHead"
        let para = ["headimg":imgBase64,
                    "nick":name];
        
        Alamofire.request(url, method: .post, parameters:para, headers:["X-AUTH-TOKEN":XKeyChain.get(TOKEN)] ).responseJSON {[unowned self] (res) in
            let jsonData = JSON(data: res.data!)
            CNLog(jsonData)
            if  jsonData["code"].intValue == 1000{
                SZHUD("提交成功", type: .success, callBack: nil)
                self.navigationController?.popViewController(animated: true)
            }else if jsonData["code"].intValue == 1006{
                self.present(LoginViewController(), animated: true, completion: nil)
            }else{
                if !jsonData["msg"].stringValue.isEmpty{
                    SZHUD(jsonData["msg"].stringValue , type: .info, callBack: nil)
                }else{
                    SZHUD("请求错误" , type: .error, callBack: nil)
                }
            }
        }
    }
    
    
    
}

extension MyInfoEditController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell:InfoEditCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        self.cell = cell
        if let userModel = model {
            cell.niceName.text = userModel.nick_name
            if userModel.headimg == ""{
                cell.imageImageView.setImage(UIImage(named: "Avatar"), for: .normal)
            }else{
                cell.imageImageView.kf.setImage(with:URL(string:httpUrl + userModel.headimg), for: .normal)
            }
        }
        
        cell.clickEvent = {[unowned self] in
            self.pikerView()
        }
        
        cell.clickButton = {[unowned self] in
            
            if self.imgBase64 == "" {
                SZHUD("请上传图片", type: .info, callBack: nil)
                return
            }
            if self.cell.niceName.text == "" {
                SZHUD("请填写昵称", type: .info, callBack: nil)
                return
            }
            
            self.uploadImg(self.imgBase64,self.cell.niceName.text!,self.imgData!)

        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return fit(700)

    }
}
extension MyInfoEditController : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let img = info[UIImagePickerController.InfoKey.originalImage]
        let cropVC = TOCropViewController(croppingStyle: .default, image: img as! UIImage)
        //        cropVC.customAspectRatio = CGSize(width:fit(483),height:fit(260))
        cropVC.delegate = self
        picker.dismiss(animated: true) {
            self.present(cropVC, animated: true, completion: nil)
        }
    }
}

extension  MyInfoEditController: TOCropViewControllerDelegate{
    
    func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
        unowned let weakself = self
        SZHUD("上传图片中", type:.loading, callBack: nil)
        cropViewController.dismiss(animated: true) {
            DispatchQueue.main.async {
                let imageData =  image.compressImage(image: image)!
                let base64 = imageData.base64EncodedString()
                weakself.imgBase64 = base64
                weakself.imgData = imageData
                self.cell.imageImageView.setImage(UIImage(data:imageData), for: .normal)

                SZHUD("上传完成", type:.success, callBack: nil)
            }
        }
    }
}



