//
//  UIViewController+.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/02/04.
//

import UIKit
import SnapKit

extension UIViewController {
    
    /// 클래스 이름을 String형으로 반환
    static var className: String {
        NSStringFromClass(self.classForCoder()).components(separatedBy: ".").last!
    }
    
    var className: String {
        NSStringFromClass(self.classForCoder).components(separatedBy: ".").last!
    }
    
    /// 화면 터치 시 키보드 내리는 함수
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    /// 화면 터치 시 키보드 내리는 함수
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func popVC() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
    
    @objc func dismissAlert() {
        dismiss(animated: false)
    }
    
    /// 기기 스크린 hight에 맞춰 비율을 계산해 height를 리턴
    func calculateHeightbyScreenHeight(originalHeight: CGFloat) -> CGFloat {
        let screenHeight = UIScreen.main.bounds.height
        return originalHeight * (screenHeight / 812)
    }
    
    /// 확인 버튼 Alert 생성
    func makeAlert(title : String, message : String? = nil,
                   okTitle: String = "확인", okAction : ((UIAlertAction) -> Void)? = nil,
                   completion : (() -> Void)? = nil) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        let alertViewController = UIAlertController(title: title,
                                                    message: message,
                                                    preferredStyle: .alert)
        let okAction = UIAlertAction(title: okTitle,
                                     style: .default,
                                     handler: okAction)
        alertViewController.addAction(okAction)
        
        self.present(alertViewController, animated: true, completion: completion)
    }
    
    /// 에러 Alert 생성
    func showErrorAlert(_ message: String?) {
        let alertController = UIAlertController(title: "Error",
                                                message: message,
                                                preferredStyle: .alert)
        let action = UIAlertAction(title: "Confirm",
                                   style: .default)
        alertController.addAction(action)
        
        present(alertController, animated: true)
    }
    
    /// View Controller 안에 View Controller embed
    /// - Parameter viewController: Child view controller
    func embed(with viewController: UIViewController) {
      addChild(viewController)
      view.addSubview(viewController.view)
      viewController.didMove(toParent: self)
    }
    
    /// Embed된 View Controller 제거
    /// - Parameter embededViewController: Embeded view controller
    func remove(of embededViewController: UIViewController) {
      guard children.contains(embededViewController) else { return }
      
      embededViewController.willMove(toParent: nil)
      embededViewController.view.removeFromSuperview()
      embededViewController.removeFromParent()
    }
      
    /// Toast Message 노출
    func showToast(message: String) {
        
        let toastLabel = BaseAttributedLabel(font: .body2,
                                             text: message,
                                             alignment: .center,
                                             color: AssetColors.white)
        
        view.addSubview(toastLabel)
        
        toastLabel.snp.makeConstraints {
            $0.width.equalTo(335)
            $0.height.equalTo(45)
            $0.centerX.equalTo(view.snp.centerX)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-70.0)
        }
        
        toastLabel.backgroundColor = AssetColors.gray900.withAlphaComponent(0.8)
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 4.0
        toastLabel.clipsToBounds = true
            
        UIView.animate(withDuration: 0.5, delay: 2.0, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
        
    }
    
}
