//
//  ViewController.swift
//  photo-location
//
//  Created by Hafiz Wahid on 16/05/2017.
//  Copyright © 2017 hw. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var geoLabel: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loadNewPic(_ sender: Any)
    {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        var chosenImage:UIImage?
        var location = "Not Known"
        
        
        if let URL = info[UIImagePickerControllerReferenceURL] as? URL
        {
            print("We got the URL as \(URL)")
            let opts = PHFetchOptions()
            opts.fetchLimit = 1
            let assets = PHAsset.fetchAssets(withALAssetURLs: [URL], options: opts)
            for assetIndex in 0..<assets.count
            {
                let asset = assets[assetIndex]
                // print("Location: \(asset.location?.description) Taken: \(asset.creationDate)")
                location = String(describing: asset.location!)
                
                
                CLGeocoder().reverseGeocodeLocation(asset.location!, completionHandler: {(placemarks, error) -> Void in
                    print(location)
                    
                    if let error = error
                    {
                        print("Reverse geocoder failed with error" + error.localizedDescription)
                        return
                    }
                    
                    if placemarks != nil && placemarks!.count > 0
                    {
                        DispatchQueue.main.async
                        {
                            self.geoLabel.text = placemarks![0].locality!
                        }
                        
                    } else
                    {
                        print("Problem with the data received from geocoder")
                    }
                })
            }
        }
        
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            chosenImage = editedImage
        } else if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            chosenImage = selectedImage
        }
        
        dismiss(animated: true) {
            DispatchQueue.main.async {
                self.imageView.image = chosenImage
                self.locationLabel.text = location
                
            }
        }
    }

}

