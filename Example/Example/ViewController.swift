//
//  ViewController.swift
//  Example
//
//  Created by kofktu on 2017. 3. 8..
//  Copyright © 2017년 Kofktu. All rights reserved.
//

import UIKit
import KUIKeyboard

class ViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var visibleHeightLabel: UILabel!
    @IBOutlet weak var bottomViewBottom: NSLayoutConstraint!

    fileprivate lazy var keyboard: KUIKeyboard = KUIKeyboard(with: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        keyboard.onChangedKeyboardHeight = { [unowned self] (visibleHeight) in
            self.visibleHeightLabel.text = "Keyboard Visible Height : \(Int(visibleHeight)), \(self.keyboard.isHidden ? "Hidden" : "Show")"
            self.bottomViewBottom.constant = visibleHeight
            self.view.layoutIfNeeded()
        }
        
        visibleHeightLabel.text = "Keyboard Visible Height : \(Int(keyboard.visibleHeight)), \(keyboard.isHidden ? "Hidden" : "Show")"
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        keyboard.addObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        keyboard.removeObservers()
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    // MARK: - UITableViewProtocol
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "identifier"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        cell.textLabel?.text = "IndexPath { \(indexPath.section), \(indexPath.row) }"
        return cell
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}
