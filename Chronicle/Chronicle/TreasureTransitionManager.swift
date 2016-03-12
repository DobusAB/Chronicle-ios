//
//  TreasureTransitionManager.swift
//  
//
//  Created by Albin Martinsson on 2016-03-12.
//
//

//
//  AddIdeaTransitionManager.swift
//  Ideaswipe
//
//  Created by Sebastian Marcusson on 2015-08-10.
//  Copyright (c) 2015 Effective Mind AB. All rights reserved.
//

import Foundation
import UIKit
import pop

class TreasureTransitionManager: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate  {
    
    private var presenting = false
    
    // MARK: UIViewControllerAnimatedTransitioning protocol methods
    
    // animate a change from one viewcontroller to another
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        // get reference to our fromView, toView and the container view that we should perform the transition in
        let container = transitionContext.containerView()
        
        // create a tuple of our screens
        let screens : (from:UIViewController, to:UIViewController) = (transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!, transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!)
        
        // assign references to our menu view controller and the 'bottom' view controller from the tuple
        // remember that our menuViewController will alternate between the from and to view controller depending if we're presenting or dismissing
        let menuViewController = !self.presenting ? screens.from as! TreasureViewController : screens.to as! TreasureViewController
        let bottomViewController = !self.presenting ? screens.to as UIViewController : screens.from as UIViewController
        
        let menuView = menuViewController.view
        let bottomView = bottomViewController.view
        
        let offstageTop = CGAffineTransformMakeTranslation(0, -700)
        
        // prepare the menu
        if (self.presenting){
            menuView.alpha = 0
            menuViewController.modalContainer.transform = offstageTop
            
        }
        
        // add the both views to our view controller
        container!.addSubview(bottomView)
        container!.addSubview(menuView)
        
        let duration = self.transitionDuration(transitionContext)
        print(duration, terminator: "")
        
        
        // perform the animation!
        UIView.animateWithDuration(0.25, delay: 0.0, options: [], animations: {
            
            // either fade in or fade out
            menuView.alpha = self.presenting ? 1 : 0
            
            if (self.presenting){
                // fade in
                menuView.alpha = 1
                let spring = POPSpringAnimation(propertyNamed: kPOPLayerTranslationY)
                spring.toValue = 0
                spring.springBounciness = 10
                spring.springSpeed = 8
                menuViewController.modalContainer.layer.pop_addAnimation(spring, forKey: "moveUp")
            }
            else {
                // fade out
                //menuViewController.addIdeaModalView.transform = offstageTop
                let spring = POPSpringAnimation(propertyNamed: kPOPLayerTranslationY)
                spring.fromValue = 0
                spring.toValue = -700
                spring.springBounciness = 10
                spring.springSpeed = 8
                menuViewController.modalContainer.layer.pop_addAnimation(spring, forKey: "moveUp")
                menuView.alpha = 0
                
            }
            
            
            }, completion: { finished in
                
                // tell our transitionContext object that we've finished animating
                transitionContext.completeTransition(true)
                
                // bug: we have to manually add our 'to view' back http://openradar.appspot.com/radar?id=5320103646199808
                UIApplication.sharedApplication().keyWindow!.addSubview(screens.to.view)
                
        })
        
    }
    
    // return how many seconds the transiton animation will take
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    
    // MARK: UIViewControllerTransitioningDelegate protocol methods
    
    // return the animataor when presenting a viewcontroller
    // rememeber that an animator (or animation controller) is any object that aheres to the UIViewControllerAnimatedTransitioning protocol
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = true
        return self
    }
    
    // return the animator used when dismissing from a viewcontroller
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = false
        return self
    }
    
}