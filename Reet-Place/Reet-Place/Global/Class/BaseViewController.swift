//
//  BaseViewController.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/02/04.
//

import UIKit

import RxSwift
import RxCocoa
import RxGesture

import Then
import SnapKit

class BaseViewController: UIViewController {
    
    // MARK: - UI components
    
    // MARK: - Variables and Properties
    
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    
    let keyboardWillShow = NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
    let keyboardWillHide = NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
    
    var bag = DisposeBag()
  
    var alias: String {
      BaseViewController.className
    }
  
    deinit {
      bag = DisposeBag()
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        layoutView()
        bindRx()
        hideKeyboard()
    }
    
    // MARK: - Functions
    
    func setTBCtoRootVC() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.window?.rootViewController = ReetPlaceTBC()
    }
    
    // MARK: - Configure
    
    func configureView() {
        view.backgroundColor = AssetColors.white
    }
    
    // MARK: - Layout
    
    func layoutView() {}
    
    // MARK: - Bind
    
    func bindRx() {
        bindDependency()
        bindInput()
        bindOutput()
    }
    
    func bindDependency() {}
    
    func bindInput() {}
    
    func bindOutput() {}
    
}
