//
//  TableViewController.swift
//  Practica5
//
//  Created by g836 DIT UPM on 13/11/18.
//  Copyright © 2018 g836 DIT UPM. All rights reserved.
//


import UIKit

var urli = "https://quiz2019.herokuapp.com/api/quizzes?token=8fda199c75cb200b0f85"

class TableViewController: UITableViewController {
    
    //Contiene un array con todas las preguntas
    var questions: NSArray = []
    //Contiene un array con el username de cada pregunta en el mismo orden que el array de preguntas
    var authors: NSArray = []
    //Contiene las URLs de las imagenes de cada pregunta
    var images: NSArray = []
    
    var answers: NSArray = []
    var tips: NSArray = []
    var ids: NSArray = []
    
     var attachments: NSArray = []
    
    //	var quizzes = [String:AnyObject]()
    var quizzes = [AnyObject]()
    
    var imagesCache = [String:UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadConUrlSession(urli)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        //cuenta: User name: alv Password: 0000
        //let str = "https://quiz2019.herokuapp.com/api/users/?token=e9cc5e13063d01d4b550"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return questions.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "quiz cell", for: indexPath) as! CellViewController
        
        let question = questions[indexPath.row] 
        let author = authors[indexPath.row] 
        let image = images[indexPath.row]
        
        cell.question?.text = question as? String
        cell.autor?.text = author as? String
        
        if let imgUrl = image as? String {
            if let img = imagesCache[imgUrl]{
                cell.icon?.image = img
            } else {
                download(imgUrl, indexpath: indexPath)
                cell.icon?.image = UIImage(named: "imgUrl")
            }
        }
        
        
        return cell
    }
    
    var session = URLSession.shared
    
    private func downloadConUrlSession(_ urls: String){
            if let url = URL(string: urls){
                let task = self.session.dataTask(with: url) {
                    (data:Data? , response:URLResponse? , error:Error?) in
                    
                    if error == nil,
                        let res = response as? HTTPURLResponse,
                        res.statusCode == 200 {
                        //print(data!)
                        if let arr = (try? JSONSerialization.jsonObject(with: data!)) as? [String: AnyObject]{
                            DispatchQueue.main.async {
                                
                                self.questions = self.questions.addingObjects(from: arr["quizzes"]!.value(forKey: "question") as! [Any]) as NSArray
                                //print(self.questions)
                                self.authors = self.authors.addingObjects(from: (arr["quizzes"]!.value(forKey: "author")! as AnyObject).value(forKey: "username") as! [Any]) as NSArray
                                //print(self.authors)
                                self.images = self.images.addingObjects(from: (arr["quizzes"]!.value(forKey: "attachment")! as AnyObject).value(forKey: "url") as! [Any]) as NSArray
                                //print(self.images)
                                self.attachments = self.attachments.addingObjects(from: (arr["quizzes"]!.value(forKey: "attachment")! as AnyObject).value(forKey: "url") as! [Any]) as NSArray
                                //print(self.attachments)
                                self.ids = self.ids.addingObjects(from: arr["quizzes"]!.value(forKey: "id") as! [Any]) as NSArray
                                //print(self.ids)
                                //print(arr["quizzes"])
                                self.tips = self.tips.addingObjects(from: arr["quizzes"]!.value(forKey: "tips") as! [Any]) as NSArray
                                
                                //print("PRIMERA PANTALLA")
                                //print(self.tips)
                                
                                self.tableView.reloadData()
                                
                                if(arr["nextUrl"] as! String != ""){
                                    self.downloadConUrlSession(arr["nextUrl"] as! String)
                                }
                                
                            }
                        }
                    }
                    
                }
                task.resume()
            }
    }
    
    
    private func download(_ urls: String, indexpath: IndexPath) {
        DispatchQueue.global().async{
            if let url = URL (string: urls){
                if let data = try? Data(contentsOf: url){
                    if let image = UIImage (data: data){
                        DispatchQueue.main.async {
                            self.imagesCache[urls] = image
                            //self.tableView.reloadRows(at: [indexpath], with: .fade)
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func refresh(_ sender: UIBarButtonItem) {
        self.questions = []
        self.authors = []
        self.images = []
        self.imagesCache = [:]
        viewDidLoad()
    }
    //let a = self.questions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show quiz"{
            let qvc = segue.destination as! QuizViewController
            if let ip = tableView.indexPathForSelectedRow{
                qvc.thisQuestion = questions.object(at: ip.row) as! String
                qvc.quizimage = imagesCache[attachments.object(at: ip.row) as! String]
                qvc.id = ids.object(at: ip.row) as! Int
                qvc.tips = tips.object(at: ip.row) as! NSArray
                }
            }
        }

    
}
