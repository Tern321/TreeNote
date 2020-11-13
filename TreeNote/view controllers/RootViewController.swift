//
//  RootViewController.swift
//  UITest2
//
//  Created by Evgenii Loshchenko on 20.10.2020.
//

import UIKit

class RootViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ContentionTableViewCellDelegate {
    @IBOutlet weak var tableView: UITableView!
    public var contentionId = "root"
    var selectedContentionId = "root"
    
    var cells: [ContentionTableViewCell] = []
    func rootContention() -> Contention
    {
        return ModelController.shared.contentionsMap[contentionId]!
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "ContentionTableViewCell", bundle: nil), forCellReuseIdentifier: "ContentionTableViewCell")
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableView.automaticDimension
        
        let action = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(actionButton(sender:)))
        
        let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        space.width = 10
        
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButton(sender:)))
        
        let topic = UIBarButtonItem(title: "Bookmarks", style: .plain, target: self, action: #selector(topicButton(sender:)))
        
        navigationItem.rightBarButtonItems = [ add, space, action, space, topic]
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row != 0
    }
//    - (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
    
    func reloadData(_ reloadTable:Bool)
    {
        print("reloadData")
        let intendantion = 10
        cells = []
        var cell = tableView.dequeueReusableCell(withIdentifier: "ContentionTableViewCell") as! ContentionTableViewCell
        cell.setData(rootContention(), self, intendantion, self.contentionId)
        cells.append(cell)
        
        for contention in rootContention().childs()
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "ContentionTableViewCell") as! ContentionTableViewCell
            cell.setData(contention, self, intendantion + 20, self.contentionId)
            cells.append(cell)
            for subContention in contention.childs()
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "ContentionTableViewCell") as! ContentionTableViewCell
                cell.setData(subContention, self, intendantion + 40, self.contentionId)
                cells.append(cell)
            }
        }
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
//        print("moveToContention")
        let cell:ContentionTableViewCell? = tableView.cellForRow(at: indexPath) as! ContentionTableViewCell?
        if let cell = cell
        {
            let nextLevelViewController = RootViewController(nibName: "RootViewController", bundle: nil)
            nextLevelViewController.contentionId = cell.contention().id
            self.navigationController?.pushViewController(nextLevelViewController, animated: true)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadData(true)
    }
//    override func viewDidAppear(_ animated: Bool) {
//        reloadData()
//    }
//
    func selectContention(_ contention:Contention)
    {
        self.selectedContentionId = contention.id
        print("selectContention")
    }
    
    func moveToContention(_ contention: Contention)
    {
        let nextLevelViewController = RootViewController(nibName: "RootViewController", bundle: nil)
        nextLevelViewController.contentionId = contention.id
        self.navigationController?.pushViewController(nextLevelViewController, animated: true)
        
        print("moveToContention")
    }
    
    @objc func actionButton(sender: UIBarButtonItem)
    {
        print("actionButton")
    }
    
    @objc func topicButton(sender: UIBarButtonItem)
    {
        let bookmarksViewController = BookmarksViewController(nibName: "BookmarksViewController", bundle: nil)
        self.present(bookmarksViewController, animated: true, completion: nil)
        print("topicButton")
    }
    @objc func addButton(sender: UIBarButtonItem)
    {
        let addContentionViewController = AddContentionViewController(nibName: "AddContentionViewController", bundle: nil)
        
        addContentionViewController.parentContentionId = self.selectedContentionId
        self.navigationController?.pushViewController(addContentionViewController, animated: true)
        
        print("addButton")
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let cell = self.cells[indexPath.row]
            ModelController.shared.removeContention(cell.contention())
            self.cells.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.reloadData(false)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

    }
    
    
}
