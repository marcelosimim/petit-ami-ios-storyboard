//
//  ListenExerciseViewController.swift
//  petitami
//
//  Created by Marcelo Simim on 23/10/21.
//

import UIKit
import CoreData
import AVFoundation
import FirebaseAuth
import FirebaseStorage

class ListenExerciseViewController: UIViewController {

    @IBOutlet weak var exerciseImageView: UIImageView!
    var player: AVPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    func updateUI(){
        let currentExercise = getCurrentExercise()
        let currentUnit = getCurrentUnit()
        
        navigationItem.title = "Unidade \(currentUnit) - Exercício \(currentExercise)"
        
        Material.exerciseImage(unit: currentUnit, exercise: currentExercise).getData(maxSize: 4 * 1024 * 1024) { data, error in
            if let e = error {
                print(e)
                self.exerciseImageView.image = UIImage(named: "attention")
//                self.activityIndicator.stopAnimating()
            }
            if let d = data{
                self.exerciseImageView.image = UIImage(data: d)
//                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    //MARK: - CoreData Methods
    
    func getCurrentExercise()->Int{
        var exercise:Int32?
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request : NSFetchRequest<User> = User.fetchRequest()
        let predicate = NSPredicate(format: "uid MATCHES %@", Auth.auth().currentUser?.uid ?? "")
        request.predicate = predicate
        
        do {
            let currentUser = try context.fetch(request)
           exercise = currentUser[0].exercise
        }catch{
            print("Error fetching data from context: \(error)")
        }
        
        //print(Auth.auth().currentUser?.uid)
        return Int(exercise ?? 0)
    }
    
    func getCurrentUnit()->Int{
        var unit:Int32?
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request : NSFetchRequest<User> = User.fetchRequest()
        let predicate = NSPredicate(format: "uid MATCHES %@", Auth.auth().currentUser?.uid ?? "")
        request.predicate = predicate
        
        do {
            let currentUser = try context.fetch(request)
           unit = currentUser[0].unit
        }catch{
            print("Error fetching data from context: \(error)")
        }
        
        //print(Auth.auth().currentUser?.uid)
        return Int(unit ?? 0)
    }
    
    //MARK: - Audio Methods
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        playSound(unit: 1, exercise: 1)
    }
    
    
    func playSound(unit:Int, exercise:Int){
        let reference = Storage.storage().reference(withPath: "exercises/unit\(unit)/audios/\(exercise).mp3")
        reference.downloadURL { url, error in
            if let error = error{
                print("Error downloading the audio: \(error)")
            }else{
                let sound = URL.init(string: url?.absoluteString ?? "")
                let playerItem = AVPlayerItem.init(url: sound!)
                self.player = AVPlayer.init(playerItem: playerItem)
                self.player!.play()
            }
        }
    }
}
