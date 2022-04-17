//
//  newPostViewController.swift
//  GroupProject
//
//  Created by Xingyu Wang on 4/14/22.
//

import UIKit
import AlamofireImage
import Parse

class newPostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var posterView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var nameText: UITextField!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var priceText: UITextField!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var locationText: UITextField!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var descriptionText: UITextView!
    
    @IBAction func onSubmitButton(_ sender: Any) {
        let item = PFObject(className: "Items")
        
        item["name"] = nameText.text!
        item["owner"] = PFUser.current()!
        item["price"] = priceText.text!
        item["location"] = locationText.text!
        item["description"] = descriptionText.text!
        
        let imageData = posterView.image!.pngData()
        let file = PFFileObject(name: "image.png", data: imageData! )
        item["image"] = file
        
        item.saveInBackground {(success, error) in
            if success{
                print("saved")
                self.dismiss(animated: true, completion: nil)
            } else{
                print("error\(error?.localizedDescription)")
            }
            
        }
        
    }
    
    // Adding picture through camera
    
    @IBAction func onCameraButton(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            picker.sourceType = .camera
        }
        else{
            picker.sourceType = .photoLibrary
        }
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        
        let size = CGSize(width: 300, height: 300)
        let scaledImage = image.af.imageScaled(to: size)
        
        posterView.image = scaledImage
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
