//
//  RootViewController.swift
//  UITest2
//
//  Created by Evgenii Loshchenko on 20.10.2020.
//

import UIKit

 // rename to ContentionsVC
class RootViewController: UIViewController, UITableViewDelegate, ContentionTableViewCellDelegate {
    @IBOutlet weak var tableView: UITableView!
    public var contentionId = "root"
    var selectedContentionId = "root"
    
    var cells: [ContentionTableViewCell] = []
    func rootContention() -> Contention
    {
        if let contention = ModelController.shared.contentionsMap[contentionId]
        {
            return contention
        }
        else
        {
            selectedContentionId = "root"
            contentionId = "root"
            self.navigationController?.popViewController(animated: false)
            return ModelController.shared.contentionsMap[contentionId]!
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "ContentionTableViewCell", bundle: nil), forCellReuseIdentifier: "ContentionTableViewCell")
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableView.automaticDimension
        
        setupNavigationBar()
    }
    
    func setupNavigationBar()
    {
        let action = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(actionButton(sender:)))
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButton(sender:)))
        let topic = UIBarButtonItem(title: "Bookmarks", style: .plain, target: self, action: #selector(topicButton(sender:)))
        let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        
        space.width = 10
        navigationItem.rightBarButtonItems = [ add, space, action, space, topic]
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func reloadData(_ reloadTable:Bool)
    {
        let intendantion = 35
        cells = []
        var cell = tableView.dequeueReusableCell(withIdentifier: "ContentionTableViewCell") as! ContentionTableViewCell
        cell.setData(rootContention(), self, intendantion, self.contentionId)
        cells.append(cell)
        for contention in rootContention().childs()
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "ContentionTableViewCell") as! ContentionTableViewCell
            cell.setData(contention, self, intendantion + 20, self.contentionId)
            cells.append(cell)
            if !contention.collapce
            {
                for subContention in contention.childs()
                {
                    cell = tableView.dequeueReusableCell(withIdentifier: "ContentionTableViewCell") as! ContentionTableViewCell
                    cell.setData(subContention, self, intendantion + 40, self.contentionId)
                    cells.append(cell)
                }
            }
        }
        self.tableView.reloadData()
        self.tableView.selectRow(at: selectedCellIndexPath(), animated: false, scrollPosition: .middle)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadData(true)
    }
    
    // MARK: actions
    func selectContention(_ contention:Contention)
    {
        self.selectedContentionId = contention.id
    }
    
    func moveToContention(_ contention: Contention)
    {
        let nextLevelViewController = RootViewController(nibName: "RootViewController", bundle: nil)
        nextLevelViewController.contentionId = contention.id
        self.navigationController?.pushViewController(nextLevelViewController, animated: true)
    }
    func editContention(_ contention: Contention)
    {
        let addContentionViewController = AddContentionViewController(nibName: "AddContentionViewController", bundle: nil)
        addContentionViewController.contention = contention
        addContentionViewController.parentContentionId = contention.parentContentionId
        self.navigationController?.pushViewController(addContentionViewController, animated: true)
    }
    
    @objc func actionButton(sender: UIBarButtonItem)
    {
        let selectActionViewController = SelectActionViewController(nibName: "SelectActionViewController", bundle: nil)
        selectActionViewController.contention = ModelController.shared.contentionsMap[self.selectedContentionId]
        selectActionViewController.rootViewController = self
        self.present(selectActionViewController, animated: true, completion: {selectActionViewController.cells=[]})
    }
    
    @objc func topicButton(sender: UIBarButtonItem)
    {
        let bookmarksViewController = BookmarksViewController(nibName: "BookmarksViewController", bundle: nil)
        self.present(bookmarksViewController, animated: true, completion: nil)
    }
    
    @objc func addButton(sender: UIBarButtonItem)
    {
        let addContentionViewController = AddContentionViewController(nibName: "AddContentionViewController", bundle: nil)
        
        addContentionViewController.parentContentionId = self.selectedContentionId
        self.navigationController?.pushViewController(addContentionViewController, animated: true)
    }
}

extension RootViewController: UITableViewDataSource
{
    // MARK: TableView datasourse
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row != 0
    }
    
    func selectedCellIndexPath() -> IndexPath
    {
        let row = self.cells.firstIndex(where: { cell in return cell.contention().id == self.selectedContentionId})
        if let row = row{
            return IndexPath(row: row, section: 0)
        }
        else
        {
            self.selectedContentionId = self.cells[0].contention().id
            return IndexPath(row: 0, section: 0)
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
