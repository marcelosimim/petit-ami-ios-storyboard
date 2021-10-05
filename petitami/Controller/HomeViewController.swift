//
//  HomeViewController.swift
//  petitami
//
//  Created by Marcelo Simim on 29/09/21.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {

    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        navigationItem.hidesBackButton = true
        FirebaseRef.coverRef.getData(maxSize: 4 * 1024 * 1024) { data, error in
            if let e = error {
                print(e)
                self.coverImageView.image = UIImage(named: "attention")
                self.activityIndicator.stopAnimating()
            }
            if let d = data{
                self.coverImageView.image = UIImage(data: d)
                self.activityIndicator.stopAnimating()
            }
    }
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
}

