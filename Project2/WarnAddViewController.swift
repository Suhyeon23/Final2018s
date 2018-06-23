//
//  WarnAddViewController.swift
//  Project2
//
//  Created by DigitalMedia-2017 on 2018. 5. 29..
//  Copyright © 2018년 DigitalMedia-2017. All rights reserved.
//

import UIKit

class WarnAddViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var pickerPlace: UIPickerView!
    @IBOutlet var textSeat: UITextField!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var buttonCamera: UIButton!
    
    
    let placeArray: [String] = ["제 1열람실", "제 2열람실","제 3열람실","제 4열람실","자유열람실"]
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        textSeat.becomeFirstResponder()
        return true
    }
    
    @IBAction func saveWarn (_ sender: UIBarButtonItem) {
        //변수에 텍스트 값 저장
        let place = placeArray[self.pickerPlace.selectedRow(inComponent: 0)]
        let seat = textSeat.text!
        
        //입력 확인 경고창
        if (seat == "") {
            let alert = UIAlertController(title: "좌석을 입력하세요",message: "Save Failed!!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                alert.dismiss(animated: true, completion: nil) }))
            self.present(alert, animated: true)
            return }
        guard let myImage = imageView.image else {
            let alert = UIAlertController(title: "이미지를 선택하세요",
                                          message: "Save Failed!!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                                            alert.dismiss(animated: true, completion: nil) }))
            self.present(alert, animated: true)
            return }
        
        //이미지 추가
        let myUrl = URL(string:"http://condi.swu.ac.kr/student/W04iphone/warn/upload.php");
        var request = URLRequest(url:myUrl!);
        request.httpMethod = "POST";
        let boundary = "Boundary-\(NSUUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)",forHTTPHeaderField: "Content-Type")
        guard let imageData = UIImageJPEGRepresentation(myImage, 1) else { return }
        var body = Data()
        var dataString = "--\(boundary)\r\n"
        dataString +=  "Content-Disposition: form-data; name=\"userfile\"; filename=\".jpg\"\r\n"
        dataString += "Content-Type: application/octet-stream\r\n\r\n"
        if let data = dataString.data(using: .utf8) { body.append(data) }
        
        // imageData 위 아래로 boundary 정보 추가
        body.append(imageData)
        
        dataString = "\r\n"
        dataString += "--\(boundary)--\r\n"
        if let data = dataString.data(using: .utf8) { body.append(data) }
        
        request.httpBody = body
        
    //이미지 전송
    var imageFileName: String = ""
    let semaphore = DispatchSemaphore(value: 0)
    let session = URLSession.shared
    let task = session.dataTask(with: request){ (responseData, response, responseError) in
        guard responseError == nil else { print("Error: calling POST"); return; }
        guard let receivedData = responseData else {print("Error: not receiving Data")
            return; }
        if let utf8Data = String(data: receivedData, encoding: .utf8) {
            // 서버에 저장한 이미지 파일 이름
            imageFileName = utf8Data
            print(imageFileName)
            semaphore.signal()
        } }
    task.resume()
    // 이미지 파일 이름을 서버로 부터 받은 후 해당 이름을 DB에 저장하기 위해wait()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
    
    
        //Table Insert
        let urlString: String = "http://condi.swu.ac.kr/student/W04iphone/data/insertWarn.php"
        guard let requestURL = URL(string: urlString) else { return }
        request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        
        //이름
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        guard let userName = appDelegate.name else { return }
        
        //날짜
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd h:mm:ss"
        let myDate = formatter.string(from: Date())
        
        var restString: String = "name=" + userName + "&place=" + place + "&seat=" + seat
        restString += "&image=" + imageFileName + "&date=" + myDate
        request.httpBody = restString.data(using: .utf8)
        let session2 = URLSession.shared
        let task2 = session2.dataTask(with: request) { (responseData, response, responseError) in
            guard responseError == nil else { return }
            guard let receivedData = responseData else { return }
            if let utf8Data = String(data: receivedData, encoding: .utf8) { print(utf8Data) }
        }
        task2.resume()
        _ = self.navigationController?.popViewController(animated: true)

        }

    
    
    //앨범에서 이미지 선택을 위한 함수
    @IBAction func selectPicture (_ sender: UIButton) {
        let myPicker = UIImagePickerController()
        myPicker.delegate = self;
        myPicker.sourceType = .photoLibrary
        self.present(myPicker, animated: true, completion: nil)
    }
    func imagePickerController (_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imageView.image = image
        }
        self.dismiss(animated: true, completion: nil) }
    func imagePickerControllerDidCancel (_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil) }
    
    
    // 카메라를 작동시키기 위한 함수
    @IBAction func takePicture (_ sender: UIButton) {
        let myPicker = UIImagePickerController()
        myPicker.delegate = self;
        myPicker.allowsEditing = true
        myPicker.sourceType = .camera
        self.present(myPicker, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if !(UIImagePickerController.isSourceTypeAvailable(.camera)) {
            let alert = UIAlertController(title: "Error!!", message: "Device has no Camera!",preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            buttonCamera.isEnabled = false // 카메라 버튼 사용을 금지시킴
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return placeArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return placeArray[row]
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
