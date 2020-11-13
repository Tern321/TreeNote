//
//  BookmarksViewController.swift
//  TreeNote
//
//  Created by Evgenii Loshchenko on 11.11.2020.
//

import UIKit

class BookmarksViewController:  UIViewController, UITableViewDelegate, UITableViewDataSource, ContentionTableViewCellDelegate  {
    @IBOutlet weak var tableView: UITableView!
    var cells: [ContentionTableViewCell] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "ContentionTableViewCell", bundle: nil), forCellReuseIdentifier: "ContentionTableViewCell")
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableView.automaticDimension
        
        reloadData()
    }
    
    func reloadData()
    {
        print("reloadData")
        cells = [];
        let rootNode = ModelController.shared.rootNode!;
        
        recursiveAddChildTopicsToCellList(rootNode,0)
        
        self.tableView.reloadData()
    }
    
    func recursiveAddChildTopicsToCellList(_ contention:Contention, _ intendantion:Int)
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContentionTableViewCell") as! ContentionTableViewCell
        cell.setData(contention, self, intendantion + 20, contention.id)
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
    
    

    @IBAction func cancel()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func moveToContention(_ :Contention)
    {
        
    }

    func selectContention(_ contention:Contention)
    {
        SceneDelegate.shared.rootViewCotroller.contentionId = contention.id
        SceneDelegate.shared.rootViewCotroller.navigationController?.popToRootViewController(animated: false)
        SceneDelegate.shared.rootViewCotroller.reloadData(true)
//        self.navigationController?.popViewController(animated: false)
        print("selectContention")
        self.cancel()
    }
    
}
