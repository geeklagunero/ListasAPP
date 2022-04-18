//
//  ListDetailViewController.swift
//  CheckList
//
//  Created by Ricardo Roman Landeros on 09/04/22.
//

import Foundation
import UIKit

protocol ListDetailViewControllerDelegate: AnyObject {
    // en resumen le decimos que cualquier clase que se adirera ha este protocolo delgado tendra que implentar estos
    //metodos para que asi se peudan cominicar con con el dueño de este protocolo y hacer una coneccion devil y no depender uno del otro
    func ListDetailViewControllerDidCancel(_ controller: ListDetailViewController)
    func ListDetailViewController(_ controller: ListDetailViewController, didFinishAdding item: Checklist)
    func ListDetailViewController(_ controller: ListDetailViewController, didFinishEditing item: Checklist)
    
}


class ListDetailViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet var textField: UITextField!
    @IBOutlet var doneBarButton: UIBarButtonItem!
    
    weak var delegate: ListDetailViewControllerDelegate?
    
    var checklistToEdit: Checklist?
    
    override func viewDidLoad() {
        if let checklist = checklistToEdit {
            //ase referencia ala variable global del scena title
            title = "Edit CheckList"
            textField.text = checklist.name
            doneBarButton.isEnabled = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //cuando se vaya a mostrar esta vista le decimos que queremos el foto o el primer responder al textField
        textField.becomeFirstResponder()
    }
    
    @IBAction func cancel(){
       // navigationController?.popViewController(animated: true)
        //llama al delgado y su metodo pasandole el proptierio de ese delgado con self
        delegate?.ListDetailViewControllerDidCancel(self)
        
    }
    
    @IBAction func done(){
//        print("Contenido del textField \(textField.text!)")
//        navigationController?.popViewController(animated: true)
        if let checklist = checklistToEdit {
            checklist.name = textField.text!
            delegate?.ListDetailViewController(self, didFinishEditing: checklist)
        } else {
            let checklist = Checklist(name: textField.text!)
            checklist.name = textField.text!
            delegate?.ListDetailViewController(self, didFinishAdding: checklist)
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let oldText = textField.text!
        //aqui solo combertimos el NSRange en Rango para poder utilizarlo
        //porque los metodos en swift entiendesn range no NSRange
        let stringRange = Range(range, in: oldText)!
        //aqui solo remplasamos el nuevo string con el viejo en el rango que la signamos
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        print(newText)
        
        doneBarButton.isEnabled = !newText.isEmpty
        
        return true
    }
    
    //metodo que se llama si se preciona al boton de cerrado auxiliar
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneBarButton.isEnabled = false
        return true
    }
}
