//
//  IconPickerViewController.swift
//  CheckList
//
//  Created by Ricardo Roman Landeros on 19/04/22.
//

import UIKit

protocol IconPickerViewControllerDelegate: AnyObject {
  func iconPicker(
    _ picker: IconPickerViewController,
    didPick iconName: String)
}

class IconPickerViewController: UITableViewController {
    
  weak var delegate: IconPickerViewControllerDelegate?
    
    let icons = [
      "No Icon", "Appointments", "Birthdays", "Chores",
      "Drinks", "Folder", "Groceries", "Inbox", "Photos", "Trips"
    ]
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return icons.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IconCell", for: indexPath)
        
        let iconName = icons[indexPath.row]
        cell.textLabel?.text = iconName
        cell.imageView?.image = UIImage(named: iconName)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let delgate = delegate {
            let iconName = icons[indexPath.row]
            delgate.iconPicker(self, didPick: iconName)
        }
    }
}


