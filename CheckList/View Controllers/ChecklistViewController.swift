//
//  ViewController.swift
//  CheckList
//
//  Created by Ricardo Roman Landeros on 28/03/22.
//

import UIKit

//class ViewController: UIViewController {
class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {
    
    
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
        let newRowIndex = checklist.items.count
        checklist.items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        //saveCheckListItems()
        navigationController?.popViewController(animated: true)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
        //el firstIndex nos devulve la poscion en entero del primer elemento que conicndia con el item que le mandamos
        if let index = checklist.items.firstIndex(of: item){
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        }
        //saveCheckListItems()
        navigationController?.popViewController(animated: true)
    }
    
    // metodos para sar el directorio de documentos de la app sandbox
//    func documentsDirectory() -> URL {
//        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        return paths[0]
//    }
    
//    func dataFilePath() -> URL {
//        return documentsDirectory().appendingPathComponent("Checklists.plist")
//    }
    
//    func saveCheckListItems() {
//        let encoder = PropertyListEncoder()
//
//        do {
//            let data = try encoder.encode(checklist.items)
//            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
//        } catch  {
//            print("error encoding item array \(error.localizedDescription)")
//        }
//    }
//
//    func loadChecklistItems() {
//        let path = dataFilePath()
//
//        if let data = try? Data(contentsOf: path) {
//            let decoder = PropertyListDecoder()
//            do {
//                checklist.items = try  decoder.decode([ChecklistItem].self, from: data)
//            } catch  {
//                print("Error de decodificacion del array \(error.localizedDescription)")
//            }
//        }
//    }
    
    
    //var items = [ChecklistItem]()
    var checklist: Checklist!

    override func viewDidLoad() {
        super.viewDidLoad()
       // navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
        title = checklist.name
//        // Replace previous code with the following
//          let item1 = ChecklistItem()
//          item1.text = "Walk the dog"
//          items.append(item1)
//
//          let item2 = ChecklistItem()
//          item2.text = "Brush my teeth"
//          item2.checkedn = true
//          items.append(item2)
//
//          let item3 = ChecklistItem()
//          item3.text = "Learn iOS development"
//          item3.checkedn = true
//          items.append(item3)
//
//          let item4 = ChecklistItem()
//          item4.text = "Soccer practice"
//          items.append(item4)
//
//          let item5 = ChecklistItem()
//          item5.text = "Eat ice cream"
//          items.append(item5)
       // loadChecklistItems() //cargamos los datos con el metodo
        
//        print("La carpeta documentos esta en \(documentsDirectory())")
//        print("la ruta del archivo es \(dataFilePath())")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Navegacion
    //UIKit invoca ha este metodo cuando esta apunto de realiarse un cambio de una pantalla a otra
    //tambien este metodo permite pasar datos de un controalr de vista a otro antes de que se muestre
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //identificamos que segue queremos usar porque podemos tener muchos en la app
        if segue.identifier == "AddItem" {
            //seteamos el controlador destino a dodne queremos pasar los datos o la
            // infomacion qe queremos que sepa en este caso
            //queremos que se entere quien es su delgado
            // en otros casos pueden ser variable u objetos
            let controller = segue.destination as! ItemDetailViewController
            controller.delgate = self //le decinos a ese controlador tu delgado sere yoni merengues osea esta clase
        } else if segue.identifier == "EditItem" {
            let controller = segue.destination as! ItemDetailViewController
            controller.delgate = self
        
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell){
                controller.itemToEdit = checklist.items[indexPath.row]
            }
        }
    }
    
    func configureText(for cell: UITableViewCell, with item: ChecklistItem){
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
    
    func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem){
       // func configureCheckmark(for cell: UITableViewCell, at indexPath: IndexPath){
        let label = cell.viewWithTag(1001) as! UILabel
        
        if item.checkedn {
            label.text = "√"
        } else {
            label.text = ""
        }
//        if item.checkedn {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
    }
    
    // MARK: - Table View Delegate
    
    //metodo para cuando le das clik a una celda
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //recuperamos la fila seleccionada
        //usamos un condicional porque puede que no aya seleccionada nada y venga vacio
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = checklist.items[indexPath.row]
            item.checkedn.toggle()
            
            configureCheckmark(for: cell, with: item)
           // saveCheckListItems()
        }
        //al final deseleccionamos la celda para que no se quede seleccionada
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //metodo para deslizar y elimnar elementos
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //primero eliminamos el elemento de los datos
        checklist.items.remove(at: indexPath.row)
        //depues eliminamos la celda graficamente
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        //saveCheckListItems()
    }
    
    // MARK: - Table View DataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklist.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        
        let item = checklist.items[indexPath.row]
        configureText(for: cell, with: item)
        
        configureCheckmark(for: cell, with: item)
        
        return cell
    }
    
    // MARK: - IBACTIONS
    //este metodo esta inactivo actualmente
//    @IBAction func addItem(){
//        let newRowIndex = items.count
//        
//        let item = ChecklistItem()
//        item.text = "Nuevo renglon"
//        item.checkedn = true
//        items.append(item)
//        
//        let indexPath = IndexPath(row: newRowIndex, section: 0)
//        let indexPaths = [indexPath]
//        tableView.insertRows(at: indexPaths, with: .automatic)
//    }
    


}

