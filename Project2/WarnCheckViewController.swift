//
//  WarnCheckViewController.swift
//  Project2
//
//  Created by DigitalMedia-2017 on 2018. 5. 29..
//  Copyright © 2018년 DigitalMedia-2017. All rights reserved.
//

import UIKit

class WarnCheckViewController: UIViewController {

    @IBOutlet var textDate: UITextField!
    @IBOutlet var textPlace: UITextField!
    @IBOutlet var textSeat: UITextField!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var textName: UITextField!
    
    var selectedData: WarnData?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        guard let warnData = selectedData else { return }
        textDate.text = warnData.date
        textPlace.text = warnData.place
        textSeat.text = warnData.seat
        var imageName = warnData.image // 숫자.jpg 로 저장된 파일 이름
        textName.text = warnData.name
        
        if (imageName != "") {
            let urlString = "http://condi.swu.ac.kr/student/W04iphone/warn/"
            imageName = urlString + imageName
            let url = URL(string: imageName)!
            if let imageData = try? Data(contentsOf: url) {
                imageView.image = UIImage(data: imageData)
                // 웹에서 파일 이미지를 접근함
            } }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.

    }
    */

}
