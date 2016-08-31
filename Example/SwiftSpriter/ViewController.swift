//
//  ViewController.swift
//  SwiftSpriter
//
//  Created by Matthew Herz on 08/31/2016.
//  Copyright (c) 2016 Matthew Herz. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    var scenes: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = Bundle.main.path(forResource: "Scenes", ofType: "plist")!
        guard let content = NSArray(contentsOfFile: path) as? [String] else {
            fatalError("Cannot read file")
        }
        scenes = content
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
        /*
         // Do any additional setup after loading the view, typically from a nib.
         let skView = SKView(frame: CGRect.zero)
         skView.backgroundColor = UIColor.blue
         skView.translatesAutoresizingMaskIntoConstraints = false
         skView.showsFPS = true
         skView.showsNodeCount = true
         skView.showsDrawCount = true
         
         self.view.addSubview(skView)
         skView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
         skView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
         skView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
         skView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
         
         self.skView = skView
         */
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = scenes[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let scene = scenes[indexPath.row]
        
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "SceneViewController") as! SceneViewController
        controller.sceneName = scene
        
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scenes.count
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
