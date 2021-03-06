//
//  ViewController.swift
//  wildeye
//
//  Created by Elizabeth Carney on 5/22/20.
//  Copyright © 2020 Elizabeth Carney. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    private var itemsToFind = ToFindItem.getMockData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Scavenger Hunt"
        //self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New", style: .plain, target: self, action: #selector(ViewController.didTapNewListButton(_:)))
        
        self.tableView.rowHeight = 70.0
        
        // call applicationDidEnterBackground() when app about to close
        NotificationCenter.default.addObserver(self, selector: #selector(UIApplicationDelegate.applicationDidEnterBackground(_:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        do {
            self.itemsToFind = try itemsToFind.readFromPersistence()
        } catch let error as NSError {
            if error.domain == NSCocoaErrorDomain && error.code == NSFileReadNoSuchFileError {
                NSLog("No persistence file found, not necesserially an error...")
            } else { // alert if error loading items
                let alert = UIAlertController(
                    title: "Error",
                    message: "Could not load items to find.",
                    preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                NSLog("Error loading from persistence: \(error)")
            }
        }
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsToFind.count
    }
    
    // says what to display in each row of the table
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // look at this cell (with identifier cell_todo), set title, set either .checkmark or .none accessory type
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_tofind", for: indexPath)
        
        if indexPath.row < itemsToFind.count {
            let item = itemsToFind[indexPath.row]
            cell.textLabel?.text = item.title
            //cell.imageView?.image = self.getPhoto()
            
            let accessory: UITableViewCell.AccessoryType = item.found ? .checkmark : .none
            cell.accessoryType = accessory
        }
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row < itemsToFind.count {
            let item = itemsToFind[indexPath.row]
            item.found = !item.found
            
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
    }
    
    @objc public func applicationDidEnterBackground(_ notification: NSNotification) {
        
        do {
            try itemsToFind.writeToPersistence()
        } catch let error {
            NSLog("Error writing to persistence: \(error)")
        }
        
    }
    
    // on tap of new list button: send alert asking if user is sure
    //@objc func didTapNewListButton(_ sender: UIBarButtonItem) {
        
        //let alert = UIAlertController(
            //title: "",
            //message: "Are you sure you want to generate a new scavenger hunt list?",
            //preferredStyle: .alert)
        
        // add cancel button to alert
        //alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // add ok button to alert that fires new list generation
        //alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
            //(_) in self.generateNewList()
        //}))
        
        //self.present(alert, animated: true, completion: nil)
    
    //}
    
    // generate new scavenger hunt list
    //func generateNewList() {
        
        //self.getJSONData()
        
        //itemsToFind.removeAll()
        //tableView.reloadData()
        
                
        //itemsToFind = ToFindItem.getMockData2()

        //var index = 0
        //for item in itemsToFind {
           //let indexPath = IndexPath(row: index, section: 0)
            //if indexPath.row < itemsToFind.count {
                //addNewListItem(title: item.title)
                
                //tableView.reloadRows(at: [indexPath], with: .automatic)
            //}
           //index = index + 1
        //}
    
    //}
    
    // convert json file data to Swift objects
    struct JSONItem: Codable {
        var Symbol:String
        var Common_Name:String
        var State_and_Province:String
        var Category:String
        var Active_Growth_Period:String
        var Photo_URL:String
    }
    func getJSONData() {
        print("getjsondata")
        
        if let data = self.readLocalFile(forName: "mockdata") {
            self.parseData(jsonData: data)
        }
        
    }
    private func readLocalFile(forName filename: String) -> Data? {
        print("readlocalfile")
        
        do {
            if let bundlePath = Bundle.main.path(forResource: filename, ofType: "json"), let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
        }
        return nil
        
    }
    private func parseData(jsonData: Data) {
        print("parsedata")
        
        do {
            let decodedItem = try JSONDecoder().decode([JSONItem].self, from: jsonData)
            print(decodedItem[0].Symbol)
            print(decodedItem[0].Common_Name)
            print(decodedItem[0].State_and_Province)
            print(decodedItem[0].Category)
            print(decodedItem[0].Active_Growth_Period)
            print(decodedItem[0].Photo_URL)
        } catch {
            print(error)
        }
        
    }
    
    // create new list item and add to tableview
    private func addNewListItem(title: String) {
        
        let newIndex = itemsToFind.count
        // create new list item and append to list
        itemsToFind.append(ToFindItem(title: title))
        tableView.insertRows(at: [IndexPath(row: newIndex, section: 0)], with: .top)
    
    }
    
    func getPhoto() {
        let photoURL = URL(string: "https://plants.sc.egov.usda.gov/gallery/standard/echin4_001_svp.jpg")!
        
        let session = URLSession(configuration: .default)
        let downloadPicTask = session.dataTask(with: photoURL) { (data, response, error) in
            if let e = error {
                print("Error downloading photo: \(e)")
            } else {
                if let res = response as? HTTPURLResponse {
                    print("Downloaded photo with code \(res.statusCode)")
                    if let imageData = data {
                        let image = UIImage(data: imageData)
                        // Do something with the image.
                    } else {
                        print("Couldn't get image: Image is nil")
                    }
                } else {
                    print("Couldn't get response code")
                }
            }
        }
        
        downloadPicTask.resume()
    }

}

