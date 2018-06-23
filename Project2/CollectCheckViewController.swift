//
//  CollectCheckViewController.swift
//  Project2
//
//  Created by DigitalMedia-2017 on 2018. 5. 29..
//  Copyright © 2018년 DigitalMedia. All rights reserved.
//

import UIKit

class CollectCheckViewController: UIViewController {
    @IBOutlet var textDate: UITextField!
    @IBOutlet var textPlace: UITextField!
    @IBOutlet var textSeat: UITextField!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var textName: UITextField!
    
    //인수
    @IBOutlet var passName: UITextField!
    @IBOutlet var passNo: UITextField!
    @IBOutlet var passPhone: UITextField!
    @IBOutlet var passDate: UITextField!
    @IBOutlet var passStaff: UITextField!
    
    //수거 내역 조회
    var selectedData: CollectData?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        guard let collectData = selectedData else { return }
        textDate.text = collectData.date
        textPlace.text = collectData.place
        textSeat.text = collectData.seat
        var imageName = collectData.image // 숫자.jpg 로 저장된 파일 이름
        textName.text = collectData.name
        
        if (imageName != "") {
            let urlString = "http://condi.swu.ac.kr/student/W04iphone/collect/"
            imageName = urlString + imageName
            let url = URL(string: imageName)!
            if let imageData = try? Data(contentsOf: url) {
                imageView.image = UIImage(data: imageData)
                // 웹에서 파일 이미지를 접근함
            } }
    }
    
    @IBAction func saveData(_ sender: UIBarButtonItem) {
        //입력확인
        if (passName.text == "" || passNo.text == "" || passPhone.text == "")
        {let alert = UIAlertController(title:"인수자, 학번, 연락처를 빠짐없이 입력해주세요 :)",message: "",preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "입력하기", style: .cancel, handler: nil))
            self.present(alert, animated: true)}
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        
    }
    

}
