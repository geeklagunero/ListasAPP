//
//  AllListsViewController.swift
//  CheckList
//
//  Created by Ricardo Roman Landeros on 09/04/22.
//

import UIKit

class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate, UINavigationControllerDelegate {
    func ListDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func ListDetailViewController(_ controller: ListDetailViewController, didFinishAdding item: Checklist) {
        let newRowIndex = dataModel.lists.count
        dataModel.lists.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        //saveCheckListItems()
        navigationController?.popViewController(animated: true)
    }
    
    func ListDetailViewController(_ controller: ListDetailViewController, didFinishEditing item: Checklist) {
        if let index = dataModel.lists.firstIndex(of: item){
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                //configureText(for: cell, with: item)
                cell.textLabel!.text = item.name
            }
        }
       // saveCheckListItems()
        navigationController?.popViewController(animated: true)
    }
    
    
    //var lists = [Checklist]()
    var dataModel: DataModel!
    let cellIdentifier = "ChecklistCell"

    override func viewDidLoad() {
        super.viewDidLoad()
//        var list = Checklist(name: "Cumpleaños")
//        lists.append(list)
//        
//        list = Checklist(name: "Compras")
//        lists.append(list)
//        
//        list = Checklist(name: "Cool Apps")
//        lists.append(list)
//        
//        list = Checklist(name: "Por Hacer")
//        lists.append(list)
//        
//        for list in lists {
//            let item = ChecklistItem()
//            item.text = "Item for \(list.name)"
//            list.items.append(item)
//        }
        
        //tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        //loadChecklists()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("Metodo del cidclo de vida de la vista")
        navigationController?.delegate = self
        
       // let index =  UserDefaults.standard.integer(forKey: "ChecklistIndex")
        let index = dataModel.indexOfSelectedChecklist
        
//        if index != -1 {
//            let checklist  = dataModel.lists[index]
//            performSegue(withIdentifier: "ShowChecklist", sender: checklist)
//        }
        
        if index >= 0 && index < dataModel.lists.count {
            let checklist  = dataModel.lists[index]
            performSegue(withIdentifier: "ShowChecklist", sender: checklist)
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataModel.lists.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let cell: UITableViewCell!
        if let temp = tableView.dequeueReusableCell(withIdentifier: cellIdentifier){
            cell = temp
        } else {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        }
        let checklist = dataModel.lists[indexPath.row]
        cell.textLabel?.text = checklist.name
        cell.accessoryType = .detailDisclosureButton
        //cell.detailTextLabel!.text = "\(checklist.countUncheckedItems()) Remaining"
        let count = checklist.countUncheckedItems()
        if checklist.items.count == 0 {
          cell.detailTextLabel!.text = "(No Items)"
        } else {
          cell.detailTextLabel!.text = count == 0 ? "All Done" : "\(count) Remaining"
        }
        cell.detailTextLabel?.text = "\(checklist.countUncheckedItems()) Remaining"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //guardamos el inidice de cual lista precionamos en lugar de guardar el nombre
        //UserDefaults.standard.set(indexPath.row, forKey: "ChecklistIndex")
        dataModel.indexOfSelectedChecklist = indexPath.row
        
        let checklist = dataModel.lists[indexPath.row]
        //este meotod ejecuta un segue si no lo puedes hacer desde storyboard
        //y nos manda al detalle de esta lista ayudado del metodo prepare
        performSegue(withIdentifier: "ShowChecklist", sender: checklist)
        
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChecklist" {
            let controller = segue.destination as! ChecklistViewController
            
            controller.checklist = sender as? Checklist
        } else if segue.identifier == "AddChecklist" {
            let controller = segue.destination as! ListDetailViewController
            controller.delegate = self
          }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //primero eliminamos el elemento de los datos
        dataModel.lists.remove(at: indexPath.row)
        //depues eliminamos la celda graficamente
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        //saveCheckListItems()
    }

    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "ListDetailViewController") as! ListDetailViewController
        controller.delegate = self
        
        let checklist = dataModel.lists[indexPath.row]
        controller.checklistToEdit = checklist
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - Navigation Controller Delegates
    //metodo que se llama cada ves que el controlador de navegacion muestra una nueva pantalla
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        print("metodo del delgado de navegacion")
        //si el viewController a donde le diste para tras soy yo
        //aqui estamos comprobando si dos variables se refieren exactamente al mismo objeto
        if viewController === self {
            //borramos la user default si estviera setadada
            //UserDefaults.standard.set(-1, forKey: "ChecklistIndex")
            dataModel.indexOfSelectedChecklist = -1
        }
    }
    
     
}
