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
import InstantSearchVoiceOverlay

class ListenExerciseViewController: UIViewController{

    @IBOutlet weak var exerciseImageView: UIImageView!
    var player: AVPlayer?
    let voiceOverlayController: VoiceOverlayController = {
      let recordableHandler = {
        return SpeechController(locale: Locale(identifier: "fr_FR"))
      }
      return VoiceOverlayController(speechControllerHandler: recordableHandler)
    }()
    var correctAnswer = ""
    var currentExercise = 0
    var currentUnit = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCurrentExercise()
        getCurrentUnit()
    }
    
    //MARK: - UI Methods
    
    func updateUI(){
        getExerciseImage(currentUnit, currentExercise)
        navigationItem.title = "Unidade \(currentUnit) - Exercício \(currentExercise)"
        voiceOverlaySettings()
    }
    
    func alert(title:String, message:String){
        let alertController:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok:UIAlertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(ok)
        self.present(alertController, animated: true, completion: nil)
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
    
    //MARK: - Recording Methods
    
    func voiceOverlaySettings(){
        voiceOverlayController.settings.layout.inputScreen.subtitleInitial = ""
        voiceOverlayController.settings.layout.inputScreen.subtitleBullet = ""
        voiceOverlayController.settings.layout.inputScreen.subtitleBulletList = []
        voiceOverlayController.settings.layout.inputScreen.titleInProgress = correctAnswer
        voiceOverlayController.settings.layout.inputScreen.titleListening = correctAnswer
    }
    
    @IBAction func recordPressed(_ sender: UIButton) {
        voiceOverlayController.start(on: self) { text, finalText, _ in
            if finalText{
                print("Final text: \(text)")
                if self.correctAnswer.lowercased() == text.lowercased(){
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.alert(title:"Sucesso", message:"Você conseguiu!")
                    }
                }else{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.alert(title:"Fail...", message:"Tente novamente!")
                    }
                }
            }else{
                print("In progress: \(text)")
            }
        } errorHandler: { error in
            
        } resultScreenHandler: { result in
            
        }
    }
    
    //MARK: - CoreData Methods
    
//    func getCurrentExercise()->Int{
//        var exercise:Int32?
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        let request : NSFetchRequest<User> = User.fetchRequest()
//        let predicate = NSPredicate(format: "uid MATCHES %@", Auth.auth().currentUser?.uid ?? "")
//        request.predicate = predicate
//
//        do {
//            let currentUser = try context.fetch(request)
//           exercise = currentUser[0].exercise
//        }catch{
//            print("Error fetching data from context: \(error)")
//        }
//
//        //print(Auth.auth().currentUser?.uid)
//        return Int(exercise ?? 0)
//    }
//
//    func getCurrentUnit()->Int{
//        var unit:Int32?
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        let request : NSFetchRequest<User> = User.fetchRequest()
//        let predicate = NSPredicate(format: "uid MATCHES %@", Auth.auth().currentUser?.uid ?? "")
//        request.predicate = predicate
//
//        do {
//            let currentUser = try context.fetch(request)
//           unit = currentUser[0].unit
//        }catch{
//            print("Error fetching data from context: \(error)")
//        }
//
//        //print(Auth.auth().currentUser?.uid)
//        return Int(unit ?? 0)
//    }
    
    //MARK: - Firebase Methods
    
    func getCurrentExercise(){
        if let uid = Auth.auth().currentUser?.uid{
            FirebaseData.userCollection(uid: uid).getDocument { document, error in
                if let document = document, document.exists {
                    self.currentExercise = document["current_exercise"] as! Int
                   } else {
                       print("Document does not exist")
                   }
            }
        }
    }
    
    func getCurrentUnit(){
        if let uid = Auth.auth().currentUser?.uid{
            FirebaseData.userCollection(uid: uid).getDocument { document, error in
                if let document = document, document.exists {
                    self.currentUnit = document["current_unity"] as! Int
                    self.getCorrectAnswer(self.currentUnit, self.currentExercise)
                   } else {
                       print("Document does not exist")
                   }
            }
        }
    }
    
    func getExerciseImage(_ currentUnit:Int, _ currentExercise:Int){
        FirebaseData.exerciseImage(unit: currentUnit, exercise: currentExercise).getData(maxSize: 4 * 1024 * 1024) { data, error in
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
    
    func getCorrectAnswer(_ currentUnit:Int, _ currentExercise:Int){
        FirebaseData.exerciseCollection(unit: currentUnit, exercise: currentExercise).getDocument { document, error in
            if let document = document, document.exists {
                self.correctAnswer =  document["check"] as! String
                self.updateUI()
               } else {
                   print("Document does not exist")
               }
        }
    }
    
    func goToNextExercise(){
        FirebaseData.exerciseCollection(unit: currentUnit, exercise: currentExercise+1).getDocument { document, error in
            if let document = document, document.exists {
                if document["answer"] as! Bool{
                    self.performSegue(withIdentifier: K.listenAndRepeatSegue, sender: self)
                }else{
                    //navegar para exercicio de escrita
                }
               } else {
                   print("Document does not exist")
               }
        }
    }
}
