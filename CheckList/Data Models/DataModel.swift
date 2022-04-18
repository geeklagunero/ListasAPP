//
//  DataModel.swift
//  CheckList
//
//  Created by Ricardo Roman Landeros on 12/04/22.
//

import Foundation

class DataModel {
    var lists = [Checklist]()
    
    var indexOfSelectedChecklist: Int {
      get {
        return UserDefaults.standard.integer(
          forKey: "ChecklistIndex")
      }
      set {
        UserDefaults.standard.set(
          newValue,
          forKey: "ChecklistIndex")
      }
    }
    
    
    init() {
        loadChecklists()
        registerDefaults()
    }
    
    func registerDefaults() {
      let dictionary = [ "ChecklistIndex": -1 ]
      UserDefaults.standard.register(defaults: dictionary)
    }
    
    //metodos para sar el directorio de documentos de la app sandbox
   func documentsDirectory() -> URL {
       let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
       return paths[0]
   }
   
   func dataFilePath() -> URL {
       return documentsDirectory().appendingPathComponent("Checklists.plist")
   }
   
   func saveCheckLis() {
       let encoder = PropertyListEncoder()

       do {
           let data = try encoder.encode(lists)
           try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
       } catch  {
           print("error encoding item array \(error.localizedDescription)")
       }
   }

   func loadChecklists() {
       let path = dataFilePath()

       if let data = try? Data(contentsOf: path) {
           let decoder = PropertyListDecoder()
           do {
               lists = try  decoder.decode([Checklist].self, from: data)
           } catch  {
               print("Error de decodificacion del array \(error.localizedDescription)")
           }
       }
   }
}
