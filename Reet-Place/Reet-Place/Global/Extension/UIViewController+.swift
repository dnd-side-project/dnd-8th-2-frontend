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
      
    
    /// Toast Message를 노출합니다.
    /// - Parameters:
    ///   - message: 노출할 메세지
    ///   - bottomViewHeight: Toast 메세지 아래에 추가로 View가 존재할 시 해당 View의 높이
    func showToast(message: String, bottomViewHeight: Double = 0.0) {
        
        let toastLabel = BaseAttributedLabel(font: .body2,
                                             text: message,
                                             alignment: .center,
                                             color: AssetColors.white)
        
        let paddingHeight = 20.0
        
        view.addSubview(toastLabel)
        
        toastLabel.snp.makeConstraints {
            $0.width.equalTo(335)
            $0.height.equalTo(45)
            $0.centerX.equalTo(view.snp.centerX)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-(bottomViewHeight + paddingHeight))
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
    
    /// Pop Up 노출
    func showPopUp(popUpType: PopUpType, targetVC: UIViewController, confirmBtnAction: Selector) {
        let popUpVC = ReetPopUp()
        
        popUpVC.configurePopUp(popUpType: popUpType,
                               targetVC: targetVC,
                               confirmBtnAction: confirmBtnAction)
        popUpVC.modalPresentationStyle = .overFullScreen
        targetVC.present(popUpVC, animated: false)
    }
    
    /// Select Box 노출
    func showSelectBox(targetVC: UIViewController, location: CGRect, style: SelectBoxStyle, completion: @escaping (Int) -> Void) {
        let selectBoxVC = ReetSelectBox()
        
        selectBoxVC.location = location
        selectBoxVC.style = style
        selectBoxVC.modalPresentationStyle = .overFullScreen
        
        selectBoxVC.selected = { row in
            completion(row)
        }
        
        targetVC.present(selectBoxVC, animated: false)
    }
    
    /// 릿플의 최상위 RootViewContoller를 반환
    static func getRootViewController() -> BaseNavigationController? {
        guard let rootVC = UIApplication.shared.windows.first?.rootViewController as? BaseNavigationController
        else {
            print("Cannot Find RootViewController!")
            return nil
        }
        
        return rootVC
    }
    
}
