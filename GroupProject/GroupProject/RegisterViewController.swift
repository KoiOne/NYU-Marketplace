//
//  RegisterViewController.swift
//  GroupProject
//
//  Created by Chen Hanrui on 2022/4/9.
//

import UIKit
import AlamofireImage
import Parse
import MBProgressHUD
import CameraManager
import Parse
import DropDown

extension UITextField {
    func setLeftView(icon: UIImage, btnView: UIButton) {
    btnView.setImage(icon, for: .normal)
    btnView.tintColor = .lightGray
    btnView.imageEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: -4)
    self.leftViewMode = .always
    self.leftView = btnView
  }
}

extension UIImage {
    func scalePreservingAspectRatio(targetSize: CGSize) -> UIImage {
        let widthRatio = targetSize.width / size.width
            let heightRatio = targetSize.height / size.height

            let scaleFactor = min(widthRatio, heightRatio)

            let scaledImageSize = CGSize(
                width: size.width * scaleFactor,
                height: size.height * scaleFactor
            )

            let renderer = UIGraphicsImageRenderer(
                size: scaledImageSize
            )

            let scaledImage = renderer.image { _ in
                self.draw(in: CGRect(
                    origin: .zero,
                    size: scaledImageSize
                ))
            }

            return scaledImage
        }
}


class RegisterViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
    let btn2 = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
    let btn3 = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
    let btn4 = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
    let btn5 = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
    let user = PFUser()

    let targetSize = CGSize(width: 25, height: 25)
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var username: UITextField!
    {
        didSet{
            let image = UIImage.init(named: "username icon")!
            let scaledImage = image.scalePreservingAspectRatio(
                targetSize: targetSize
            )
            username.setLeftView(icon: scaledImage, btnView: btn)
            username.tintColor = .lightGray
            username.isSecureTextEntry = true
        }
    }
    
    @IBOutlet weak var password: UITextField!
    {
        didSet{
            let image = UIImage.init(named: "password icon")!
            let scaledImage = image.scalePreservingAspectRatio(
                targetSize: targetSize
            )
            password.setLeftView(icon: scaledImage, btnView: btn2)
            password.tintColor = .lightGray
            password.isSecureTextEntry = true
        }
    }
    
    @IBOutlet weak var nyuemail: UITextField!
    {
        didSet{
            let image = UIImage.init(named: "email_icon")!
            let scaledImage = image.scalePreservingAspectRatio(
                targetSize: targetSize
            )
            nyuemail.setLeftView(icon: scaledImage, btnView: btn3)
            nyuemail.tintColor = .lightGray
            nyuemail.isSecureTextEntry = true
        }
    }
    

    
    @IBOutlet weak var vwDropDown:UIView!
    @IBOutlet weak var school: UITextField!
    {
        didSet{
            let image = UIImage.init(named: "school icon")!
            let scaledImage = image.scalePreservingAspectRatio(
                targetSize: targetSize
            )
            school.setLeftView(icon: scaledImage, btnView: btn4)
            school.tintColor = .lightGray
            school.isSecureTextEntry = true
        }
    }
    
    let dropDown = DropDown()
    let schoolArray = ["CAS","Stern", "Courant", "Gallatin", "Tisch", "Steinhardt", "Tandon", "Silver", "SPS", "NYU Abu Dhabi", "NYU Shanghai"]
    let yearDropDown = DropDown()
    let yearArray = ["Freshman", "Sophomore", "Junior", "Senior", "First-year graduate student","Second-year graduate student", "PhD candidate"]
    
    
    
    @IBOutlet weak var yearVwDropDown: UIView!
    @IBOutlet weak var schoolyear: UITextField!
    {
        didSet{
            let image = UIImage.init(named: "school year icon")!
            let scaledImage = image.scalePreservingAspectRatio(
                targetSize: targetSize
            )
            schoolyear.setLeftView(icon: scaledImage, btnView: btn5)
            schoolyear.tintColor = .lightGray
            schoolyear.isSecureTextEntry = true
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        username.isSecureTextEntry = false
        // Do any additional setup after loading the view.
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        profileImage.clipsToBounds = true
        
        let placeholderU = NSAttributedString(string: "username", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])
        username.attributedPlaceholder = placeholderU;
        self.view.addSubview(username)
        
        password.isSecureTextEntry = false
        let placeholderP = NSAttributedString(string: "password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])
        password.attributedPlaceholder = placeholderP;
        self.view.addSubview(password)
        
        nyuemail.isSecureTextEntry = false
        let placeholderE = NSAttributedString(string: "NYU email", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])
        nyuemail.attributedPlaceholder = placeholderE;
        self.view.addSubview(nyuemail)
        
        school.isSecureTextEntry = false
        //let placeholderS = NSAttributedString(string: "school (e.g. CAS, Stern, ...)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])
        //school.attributedPlaceholder = placeholderS;
        //self.view.addSubview(school)
        
        
        school.text = "Select a school"
        school.textColor = UIColor.gray
        dropDown.anchorView = vwDropDown
        dropDown.dataSource = schoolArray
        dropDown.bottomOffset = CGPoint(x: 0, y: (dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.topOffset = CGPoint(x: 0, y: -(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.direction = .bottom
        dropDown.selectionAction = { [unowned self]
            (index: Int, item: String) in print("Selected item: \(item) at index: \(index)")
            self.school.textColor = UIColor.black
            self.school.text = schoolArray[index]
        }
        
        
        schoolyear.isSecureTextEntry = false
        schoolyear.text = "Select a school year"
        schoolyear.textColor = UIColor.gray
        yearDropDown.anchorView = yearVwDropDown
        yearDropDown.dataSource = yearArray
        yearDropDown.bottomOffset = CGPoint(x: 0, y: (yearDropDown.anchorView?.plainView.bounds.height)!)
        yearDropDown.topOffset = CGPoint(x: 0, y: -(yearDropDown.anchorView?.plainView.bounds.height)!)
        yearDropDown.direction = .bottom
        yearDropDown.selectionAction = { [unowned self]
            (index: Int, item: String) in print("Selected item: \(item) at index: \(index)")
            self.schoolyear.textColor = UIColor.black
            self.schoolyear.text = yearArray[index]
        }
        
        
        self.view.addSubview(password)
        
    }
    
    @IBAction func showSchoolOptions(_ sender: Any) {
        dropDown.show()
    }
    
    @IBAction func showYearOptions(_ sender: Any) {
        yearDropDown.show()
    }
    
    
    @IBAction func onImage(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            picker.sourceType = .camera
        }else{
            picker.sourceType = .photoLibrary
        }
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        
        let size = CGSize(width: 300, height: 300)
        let scaledImage = image.af_imageScaled(to: size)
        
        profileImage.image = scaledImage
        
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func onSignUp(_ sender: Any) {
        user.username = username.text
        user.password = password.text
        user.email = nyuemail.text
        user["school"] = school.text
        user["schoolyear"] = schoolyear.text
        let imageData = profileImage.image!.pngData()
        let file = PFFileObject(name: "image.png", data: imageData! )
        user["profileImage"] = file
        
        user.signUpInBackground{ (success, error) in
            if success{
                self.performSegue(withIdentifier: "signUpSegue", sender: nil)
            }else{
                print("Error: \(error?.localizedDescription)")
            }
        }
    }

    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination
//        // Pass the selected object to the new controller
////        let cell = sender as! UICollectionViewCell
////        let indexPath = collectionView.indexPath(for: cell)
//        let userI = user
//
//        let profileViewController = segue.destination as! ProfileViewController
//        profileViewController.user = userI
//
//    }

}
