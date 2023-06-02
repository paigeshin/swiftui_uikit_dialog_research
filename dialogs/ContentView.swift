//
//  ContentView.swift
//  dialogs
//
//  Created by paige shin on 2023/06/02.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Button {
                PresentingViewController().presentPopup()
            } label: {
                Text("show modal")
            }

        }
        .padding()
        
    }
}



class PresentingViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    var transitionStyle: PopupDialogTransitionStyle = .zoomIn
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = PresentationController(presentedViewController: presented, presenting: presenting)
        return presentationController
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        var transition: TransitionAnimator
        switch transitionStyle {
        case .bounceUp:
            transition = BounceUpTransition(direction: .in)
        case .bounceDown:
            transition = BounceDownTransition(direction: .in)
        case .zoomIn:
            transition = ZoomTransition(direction: .in)
            print("zoom in !")
        case .fadeIn:
            transition = FadeTransition(direction: .in)
        }

        return transition
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        print("dismiss called!")
        var transition: TransitionAnimator
        switch transitionStyle {
        case .bounceUp:
            transition = BounceUpTransition(direction: .out)
        case .bounceDown:
            transition = BounceDownTransition(direction: .out)
        case .zoomIn:
            transition = ZoomTransition(direction: .out)
            print("zoom out !")
        case .fadeIn:
            transition = FadeTransition(direction: .out)
        }

        return transition
    }

    func presentPopup() {
        let popupContentViewController = UIHostingController(rootView: DialogView())
        popupContentViewController.modalPresentationStyle = .custom
        popupContentViewController.transitioningDelegate = self
        popupContentViewController.view.backgroundColor = .clear
        UIApplication.shared.present(popupContentViewController)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            popupContentViewController.dismiss(animated: true)
        }
    }
}

struct DialogView: View {
    
    var body: some View {
        ZStack {
            Text("hello world").foregroundColor(.white)
        }
        .frame(width: 200, height: 200)
        .background(Color.black)

    }
}

extension UIApplication {
    
    var firstWindow: UIWindow? {
        let scenes: Set<UIScene> = UIApplication.shared.connectedScenes
        let windowScene: UIWindowScene? = scenes.first as? UIWindowScene
        return windowScene?.windows.first
    }
    
    var topMostViewController: UIViewController? {
        var topMostVC = self.firstWindow?.rootViewController
        while let presentedVC = topMostVC?.presentedViewController {
            topMostVC = presentedVC
        }
        return topMostVC
    }
    
    func present(_ vc: UIViewController) {
        self.topMostViewController?.present(vc, animated: true)
    }
    
}
