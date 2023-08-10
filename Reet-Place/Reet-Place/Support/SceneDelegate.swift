//
//  SceneDelegate.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/02/04.
//

import UIKit

import KakaoSDKAuth
import AuthenticationServices

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        // Splash Show
        Thread.sleep(forTimeInterval: 1)
        
//        checkAvailableSignInWithApple()
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        if KeychainManager.shared.read(for: .isFirst) == nil {
            window?.rootViewController = OnboardingVC()
        } else if KeychainManager.shared.read(for: .accessToken) == nil {
            window?.rootViewController = LoginVC()
        } else {
            window?.rootViewController = BaseNavigationController(rootViewController: ReetPlaceTabBarVC())
        }
        
        window?.tintColor = AssetColors.primary500
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
}

// MARK: - 카카오 로그인

extension SceneDelegate {
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            // 카카오톡 앱으로 전환
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.handleOpenUrl(url: url)
            }
        }
    }
    
}

// MARK: - Sign in with Apple

extension SceneDelegate {
    
    private func checkAvailableSignInWithApple() {
        guard let appleToken = KeychainManager.shared.read(for: .appleUserAuthID) else { return }
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        appleIDProvider.getCredentialState(forUserID: appleToken) { (credentialState, error) in
            switch credentialState {
            case .authorized:
                break
            case .revoked,
                .notFound:
                KeychainManager.shared.removeAllKeys()
                print("Sign in With Apple no longer available")
            default:
                break
            }
        }
    }
    
}


// MARK: - Custom Method

extension SceneDelegate {
    
    /// RootVC를 홈 화면으로 변경하면서 VC 스택 초기화
    func changeRootVCToHome() {
        guard let window = self.window else { return }
        window.rootViewController = BaseNavigationController(rootViewController: ReetPlaceTabBarVC())
                
        UIView.transition(with: window, duration: 0.2, options: [.transitionCrossDissolve], animations: nil, completion: nil)
    }
    
}
