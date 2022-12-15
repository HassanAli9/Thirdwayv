//
//  TransitionManager.swift
//  ThirdwayvTask
//
//  Created by Hassan Ali on 15/12/2022.
//

import Foundation
import UIKit


final class TransitionManager:  NSObject, UIViewControllerAnimatedTransitioning {
    private let duration: TimeInterval
    private var operation = UINavigationController.Operation.push
    
    init(duration: TimeInterval) {
        self.duration = duration
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromViewController = transitionContext.viewController(forKey: .from),
            let toViewController = transitionContext.viewController(forKey: .to)
        else {
            transitionContext.completeTransition(false)
            return
        }
        
        animateTransition(from: fromViewController, to: toViewController, with: transitionContext)
    }
   }

// MARK: - UINavigationControllerDelegate

extension TransitionManager: UINavigationControllerDelegate {
    func navigationController(
        _ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        self.operation = operation
        
        if operation == .push {
            return self
        }
        
        return nil
    }
}

// MARK: - Animations

private extension TransitionManager {
    func animateTransition(from fromViewController: UIViewController, to toViewController: UIViewController, with context: UIViewControllerContextTransitioning) {
        switch operation {
        case .push:
            guard
                let productViewController = fromViewController as? ProductViewController,
                let productDetailsViewController = toViewController as? ProductDetailsViewController
            else { return }
            
            presentViewController(productDetailsViewController, from: productViewController , with: context)
            
        case .pop:
            guard
                let productViewController = fromViewController as? ProductViewController,
                let productDetailsViewController = toViewController as? ProductDetailsViewController
            else { return }
            
            dismissViewController(productViewController, to: productDetailsViewController)
            
        default:
            break
        }
    }
    
    func presentViewController(_ toViewController: ProductDetailsViewController, from fromViewController: ProductViewController, with context: UIViewControllerContextTransitioning) {
        
        guard
            let productCell = fromViewController.currentCell
        else { return}
        
        toViewController.view.layoutIfNeeded()
        
        let containerView = context.containerView
        
        let snapshotContentView = UIView()
        snapshotContentView.backgroundColor = .white
        snapshotContentView.frame = containerView.convert(productCell.contentView.frame, from: productCell)
        snapshotContentView.layer.cornerRadius = productCell.contentView.layer.cornerRadius
        
     
        
        
        containerView.addSubview(toViewController.view)
        containerView.addSubview(snapshotContentView)
        
        toViewController.view.isHidden = true
        
        let animator = UIViewPropertyAnimator(duration: duration, curve: .easeInOut) {
            snapshotContentView.frame = containerView.convert(toViewController.view.frame, from: toViewController.view)
        }

        animator.addCompletion { position in
            toViewController.view.isHidden = false
            snapshotContentView.removeFromSuperview()
            context.completeTransition(position == .end)
        }

        animator.startAnimation()
    }
    
    func dismissViewController(_ fromViewController: ProductViewController, to toViewController: ProductDetailsViewController) {
        
    }
}


