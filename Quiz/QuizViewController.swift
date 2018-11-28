//
//  QuizViewController.swift
//  Practica5
//
//  Created by g836 DIT UPM on 21/11/18.
//  Copyright © 2018 g836 DIT UPM. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController {

    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var result: UILabel!
   
    @IBOutlet weak var respuesta: UITextField!
    var quizimage : UIImage!
    var thisQuestion: String = "j"
    var id: Int = 0
    var tips: NSArray = []
    
    
    
    //var thisQuestion: NSArray = []
    //var thisQuestion: NSArray = []
    var quiz : NSArray = []
    override func viewDidLoad() {
        super.viewDidLoad()
        question.text = thisQuestion
        image.image = quizimage
        //print("TIPS EN LA PAGINA DE LA PREGUNTA JIJI")
        //print(tips)
        

        title = "Responda: "
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

    @IBAction func comprobar(_ sender: UIButton) {
        //para comrpbar las respuestas meterse en esta url
        //https://quiz2019.herokuapp.com/api/quizzes/1/check?answer=rome&token=e9cc5e13063d01d4b550
        let token = "token=8fda199c75cb200b0f85"
        var stringURL = respuesta.text!
      
       if(stringURL.contains(" ")){
            stringURL = stringURL.replacingOccurrences(of: " ", with: "+")
        }
        /*if(stringURL.contains("ñ")){
            stringURL = stringURL.replacingOccurrences(of: "ñ", with: "%C3%B1")
        }*/
        stringURL = stringURL.addingPercentEncoding(withAllowedCharacters: ["ñ","´"," "])!
        let url = "https://quiz2019.herokuapp.com/api/quizzes/\(id)/check?answer=\(stringURL)&\(token)"
        print(url)
        
        guard let URL = URL(string : url) else  {
            print("error transformando la url")
            return
        }
        
        DispatchQueue.global().async {
            if let data = try?Data(contentsOf: URL) {
                if let checkAnswer = (try?JSONSerialization.jsonObject(with: data))as? [String:AnyObject] {
                    DispatchQueue.main.async {
                        print(checkAnswer)
                        
                        
                        if let result = checkAnswer["result"] as? Int {
                            if result == 1 {
                                let alert = UIAlertController(title: "Correcto", message: "La respuesta \(checkAnswer["answer"]!) es correcta", preferredStyle: .alert) //crea la alerta
                                
                                alert.addAction(UIAlertAction(title: "Continuar", style: .default))//boton para cerrar la alerta
                                
                                self.present(alert, animated: true) //la presenta por pantalla
                            }
                            else {
                                let alert = UIAlertController(title: "Incorrecto", message: "La respuesta \(checkAnswer["answer"]!) es incorrecta", preferredStyle: .alert) //crea la alerta
                                
                                alert.addAction(UIAlertAction(title: "Volver a intentar", style: .default))//boton para cerrar la alerta
                                
                                self.present(alert, animated: true) //la presenta por pantalla
                            }
                        }
                    }
                }
            }
            else {
                print("error")
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show tips"{
            let ttvc = segue.destination as! TipsTableViewController
            ttvc.tips = self.tips
        }
    }
}
