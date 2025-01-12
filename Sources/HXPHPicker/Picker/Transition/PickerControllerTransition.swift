//
//  PickerControllerTransition.swift
//  HXPHPicker
//
//  Created by Slience on 2022/5/23.
//

import UIKit

class PickerControllerTransition: NSObject, UIViewControllerAnimatedTransitioning {
    public enum TransitionType {
        case push
        case pop
        case dismiss
    }
    let type: TransitionType
    
    init(type: TransitionType) {
        self.type = type
        super.init()
    }
    
    public func transitionDuration(
        using transitionContext: UIViewControllerContextTransitioning?
    ) -> TimeInterval {
        if type == .push {
            return 0.3
        }
        return 0.25
    }
    
    public func animateTransition(
        using transitionContext: UIViewControllerContextTransitioning
    ) {
        let fromVC = transitionContext.viewController(forKey: .from)!
        let toVC = transitionContext.viewController(forKey: .to)!
        
        let containerView = transitionContext.containerView
        if type == .push {
            containerView.addSubview(fromVC.view)
            containerView.addSubview(toVC.view)
        }else {
            containerView.addSubview(toVC.view)
            containerView.addSubview(fromVC.view)
        }
        let duration = transitionDuration(using: transitionContext)
        let options: UIView.AnimationOptions
        switch self.type {
        case .push:
            toVC.view.x = toVC.view.width
            options = .curveEaseOut
        case .pop:
            toVC.view.x = -(toVC.view.width * 0.3)
            options = .curveLinear
        default:
            options = .curveLinear
            break
        }
        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: options
        ) {
            switch self.type {
            case .push:
                fromVC.view.x = -(fromVC.view.width * 0.3)
                toVC.view.x = 0
            case .pop:
                fromVC.view.x = fromVC.view.width
                toVC.view.x = 0
            case .dismiss:
                fromVC.view.y = fromVC.view.height
            }
        } completion: { _ in
            switch self.type {
            case .pop, .dismiss:
                fromVC.view.removeFromSuperview()
            default:
                break
            }
            transitionContext.completeTransition(true)
        }
    }
}
