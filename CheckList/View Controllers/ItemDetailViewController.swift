//
//  AddItemViewController.swift
//  CheckList
//
//  Created by Ricardo Roman Landeros on 31/03/22.
//

import UIKit

//protocolo del delegado para additemvieController se comunicque con la pantalla de checklistviewcontroller
protocol ItemDetailViewControllerDelegate: AnyObject {
    // en resumen le decimos que cualquier clase que se adirera ha este protocolo delgado tendra que implentar estos
    //metodos para que asi se peudan cominicar con con el dueño de este protocolo y hacer una coneccion devil y no depender uno del otro
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem)
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem)
    
}

class ItemDetailViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var textField: UITextField!
    
    //variable para hacer referencia al delegado
    // en si le decimos este es tu delegado son los pasos que alguien tiene que cumplir para ayudarte hacer algo y peude o no estar porque es optional
    weak var delgate: ItemDetailViewControllerDelegate?
    
    var itemToEdit: ChecklistItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        navigationItem.largeTitleDisplayMode = .never
        
        if let item = itemToEdit {
            //ase referencia ala variable global del scena title
            title = "Edit Item"
            textField.text = item.text
            doneBarButton.isEnabled = true
        }

       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //cuando se vaya a mostrar esta vista le decimos que queremos el foto o el primer responder al textField
        textField.becomeFirstResponder()
    }
    
    //este metodo dice que se seleccionara la finala y al devolver nil le decimos que no se puede
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    // MARK: - Actions
    
    @IBAction func cancel(){
       // navigationController?.popViewController(animated: true)
        //llama al delgado y su metodo pasandole el proptierio de ese delgado con self
        delgate?.itemDetailViewControllerDidCancel(self)
        
    }
    
    @IBAction func done(){
//        print("Contenido del textField \(textField.text!)")
//        navigationController?.popViewController(animated: true)
        if let item = itemToEdit {
            item.text = textField.text!
            delgate?.itemDetailViewController(self, didFinishEditing: item)
        } else {
            let item = ChecklistItem()
            item.text = textField.text!
            delgate?.itemDetailViewController(self, didFinishAdding: item)
        }
        
    }
    
    // MARK: - Method delegate of textField
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let oldText = textField.text!
        //aqui solo combertimos el NSRange en Rango para poder utilizarlo
        //porque los metodos en swift entiendesn range no NSRange
        let stringRange = Range(range, in: oldText)!
        //aqui solo remplasamos el nuevo string con el viejo en el rango que la signamos
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        print(newText)
        
        if newText.isEmpty {
            doneBarButton.isEnabled = false
        } else {
            doneBarButton.isEnabled = true
        }
        
        return true
    }
    
    //metodo que se llama si se preciona al boton de cerrado auxiliar
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneBarButton.isEnabled = false
        return true
    }

    
}
