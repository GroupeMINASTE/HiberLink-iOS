//
//  UploadViewController.swift
//  HiberLink
//
//  Created by Nathan FALLET on 19/04/2020.
//  Copyright © 2020 Nathan FALLET. All rights reserved.
//

import UIKit

class UploadViewController: UIViewController, UITextFieldDelegate {
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    let input = UITextField()
    let generate = UIButton()
    let output = UITextField()
    let copy = UIButton()
    var bottomConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set background color
        view.backgroundColor = .background
        
        // Set title
        navigationItem.title = "upload_title".localized()
        
        // Add views
        view.addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomConstraint = scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        bottomConstraint.isActive = true
        
        scrollView.addSubview(contentView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        contentView.addSubview(input)
        contentView.addSubview(generate)
        contentView.addSubview(output)
        contentView.addSubview(copy)
        
        input.translatesAutoresizingMaskIntoConstraints = false
        input.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor, constant: 15).isActive = true
        input.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor, constant: 15).isActive = true
        input.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor, constant: -15).isActive = true
        input.placeholder = "upload_input".localized()
        input.textAlignment = .center
        input.autocorrectionType = .no
        input.autocapitalizationType = .none
        input.returnKeyType = .done
        input.keyboardType = .URL
        input.delegate = self
        
        generate.translatesAutoresizingMaskIntoConstraints = false
        generate.topAnchor.constraint(equalTo: input.bottomAnchor, constant: 15).isActive = true
        generate.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        generate.widthAnchor.constraint(equalToConstant: 300).isActive = true
        generate.heightAnchor.constraint(equalToConstant: 50).isActive = true
        generate.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        generate.setTitle("upload_generate".localized(), for: .normal)
        generate.setTitle("upload_generating".localized(), for: .disabled)
        generate.setTitleColor(.white, for: .normal)
        generate.backgroundColor = .systemBlue
        generate.layer.cornerRadius = 10
        generate.clipsToBounds = true
        
        output.translatesAutoresizingMaskIntoConstraints = false
        output.topAnchor.constraint(equalTo: generate.bottomAnchor, constant: 30).isActive = true
        output.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor, constant: 15).isActive = true
        output.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor, constant: -15).isActive = true
        output.placeholder = "upload_output".localized()
        output.textAlignment = .center
        output.isEnabled = false
        
        copy.translatesAutoresizingMaskIntoConstraints = false
        copy.topAnchor.constraint(equalTo: output.bottomAnchor, constant: 15).isActive = true
        copy.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor, constant: -15).isActive = true
        copy.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        copy.widthAnchor.constraint(equalToConstant: 300).isActive = true
        copy.heightAnchor.constraint(equalToConstant: 50).isActive = true
        copy.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        copy.setTitle("upload_copy".localized(), for: .normal)
        copy.setTitleColor(.white, for: .normal)
        copy.backgroundColor = .systemBlue
        copy.layer.cornerRadius = 10
        copy.clipsToBounds = true
        
        // Listen for keyboard changes
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChanged(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChanged(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func buttonClicked(_ sender: UIButton) {
        if sender == generate, let url = input.text {
            // Disable
            generate.isEnabled = false
            
            // Generate a link
            APIRequest("POST", path: "/link.php").with(body: "link=\(url)").execute() { string, status in
                // Check if request was sent
                if let string = string {
                    // Show generated link
                    self.output.text = string
                    
                    // Select it
                    self.output.becomeFirstResponder()
                    self.output.selectAll(nil)
                } else {
                    // An error occured
                    self.output.text = "upload_error".localized()
                }
                
                // Enable again
                self.generate.isEnabled = true
            }
        } else if sender == copy {
            // Select it
            output.becomeFirstResponder()
            output.selectAll(nil)
            
            // Copy link
            UIPasteboard.general.string = output.text
        }
    }
    
    @objc func keyboardChanged(_ sender: NSNotification) {
        if let userInfo = sender.userInfo {
            // Adjust frame to keyboard
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
            let tabBarFrame = tabBarController?.tabBar.frame
            let isKeyboardShowing = sender.name == UIResponder.keyboardWillShowNotification
            bottomConstraint.constant = isKeyboardShowing ? -((keyboardFrame?.height ?? 0) - (tabBarFrame?.height ?? 0)) : 0
            
            // And animate the transition
            UIView.animate(withDuration: 0, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }

}
