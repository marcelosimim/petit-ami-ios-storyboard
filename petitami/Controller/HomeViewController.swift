//
//  HomeViewController.swift
//  petitami
//
//  Created by Marcelo Simim on 29/09/21.
//

import UIKit
import FirebaseAuth
import CoreData

class HomeViewController: UIViewController {

    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //FirebaseRef.getUserProgress(uid: Auth.auth().currentUser!.uid)
        progressView.progress = 0.0
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(gesture:)))
        coverImageView.addGestureRecognizer(tapGesture)
        coverImageView.isUserInteractionEnabled = true
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        updateUI()
    }
    
    func updateUI(){
        navigationItem.hidesBackButton = true
        
        //cover
        Material.coverImage(unit: 1).getData(maxSize: 4 * 1024 * 1024) { data, error in
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
        progressView.progress = Float(getUserProgress())
    }
    
    @objc func imageTapped(gesture: UIGestureRecognizer) {
            if (gesture.view as? UIImageView) != nil {
                print("Image Tapped")
                //Here you can initiate your new ViewController
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
    
    //MARK: - CoreData Methods
    
    func getUserProgress()->Double{
        var progress:Double?
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request : NSFetchRequest<User> = User.fetchRequest()
        let predicate = NSPredicate(format: "uid MATCHES %@", Auth.auth().currentUser?.uid ?? "")
        request.predicate = predicate
        
        do {
            let currentUser = try context.fetch(request)
           progress = currentUser[0].progress
        }catch{
            print("ERRO DO REQUEST???? OXE")
            print("Error fetching data from context: \(error)")
        }
        
        //print(Auth.auth().currentUser?.uid)
        return progress ?? 0.0
    }
}

