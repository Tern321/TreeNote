//
//  SelectActionViewController.swift
//  TreeNote
//
//  Created by Evgenii Loshchenko on 13.11.2020.
//

import UIKit

class SelectActionViewController:  UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    public var contention:Contention!
    public var rootViewController:RootViewController!
    
    @IBOutlet weak var tableView: UITableView!
    var cells: [ActionTableViewCell] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "ActionTableViewCell", bundle: nil), forCellReuseIdentifier: "ActionTableViewCell")
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableView.automaticDimension
        
        reloadData()
        
    }
    func remove()
    {
        ModelController.shared.removeContention(contention)
        self.cancel(true)
    }
    func change()
    {
        self.cancel(false)
        
        let addContentionViewController = AddContentionViewController(nibName: "AddContentionViewController", bundle: nil)
        addContentionViewController.contention = contention
        addContentionViewController.parentContentionId = contention.parentContentionId
        self.rootViewController.navigationController?.pushViewController(addContentionViewController, animated: true)
    }
    func bookmark()
    {
        ModelController.shared.markAsTopic(contention, !contention.topic)
        self.cancel(true)
    }
    func collapse()
    {
        ModelController.shared.collapse(self.contention)
        self.cancel(true)
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func reloadData()
    {
        cells = [];
        
        var cell:ActionTableViewCell
        
        cell = tableView.dequeueReusableCell(withIdentifier: "ActionTableViewCell") as! ActionTableViewCell
        cell.cellAction = self.change
        cell.textLabel?.text = "Edit"
        cells.append(cell)
        
        cell = tableView.dequeueReusableCell(withIdentifier: "ActionTableViewCell") as! ActionTableViewCell
        cell.cellAction = self.bookmark
        cell.textLabel?.text = "Bookmark"
        cells.append(cell)
        
        cell = tableView.dequeueReusableCell(withIdentifier: "ActionTableViewCell") as! ActionTableViewCell
        cell.cellAction = self.collapse
        cell.textLabel?.text = "Collapse"
        cells.append(cell)
        
        cell = tableView.dequeueReusableCell(withIdentifier: "ActionTableViewCell") as! ActionTableViewCell
        cell.cellAction = self.remove
        cell.textLabel?.text = "Remove"
        cells.append(cell)
        
        self.tableView.reloadData()
    }
    
    func recursiveAddChildTopicsToCellList(_ contention:Contention, _ intendantion:Int)
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActionTableViewCell") as! ActionTableViewCell
        cells.append(cell)
        for subContention in contention.childTopics()
        {
            recursiveAddChildTopicsToCellList(subContention,intendantion+20)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        return cells[indexPath.row]
    }
    
    @IBAction func cancel(_ animated:Bool)
    {
        self.cells = []
        self.dismiss(animated: animated, completion: nil)
        self.rootViewController.reloadData(false)
    }
}
