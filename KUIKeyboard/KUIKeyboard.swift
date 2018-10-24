//
//  KUIKeyboard.swift
//  KUIKeyboard
//
//  Created by kofktu on 2017. 3. 8..
//  Copyright © 2017년 Kofktu. All rights reserved.
//

import UIKit
import Foundation

public protocol KUIKeyboardDelegate: class {
    func keyboard(_ keyboard: KUIKeyboard, changed visibleHeight: CGFloat)
}

public final class KUIKeyboard: NSObject {
    public var isHidden: Bool {
        return visibleHeight == 0.0
    }
    public fileprivate(set) var keyboardFrame = CGRect.zero {
        didSet {
            var height: CGFloat = max(0.0, screenHeight - keyboardFrame.minY)
            
            if isAdjustSafeAreaInset, #available(iOS 11.0, *) {
                if let window = UIApplication.shared.windows.first, height > 0 {
                    height -= window.safeAreaInsets.bottom
                }
            }
            
            visibleHeight = height
        }
    }
    public fileprivate(set) var visibleHeight: CGFloat = 0.0 {
        didSet {
            onChangedKeyboardHeight?(visibleHeight)
            delegate?.keyboard(self, changed: visibleHeight)
        }
    }
    public var onChangedKeyboardHeight: ((CGFloat) -> Void)?
    public weak var delegate: KUIKeyboardDelegate?
    
    fileprivate var panGesture: UIPanGestureRecognizer?
    private var isObserving: Bool = false
    private var isAdjustSafeAreaInset: Bool = false
 
    convenience public init(with adjustSafeAreaInset: Bool) {
        self.init()
        self.isAdjustSafeAreaInset = adjustSafeAreaInset
    }
    
    public func addObservers() {
        guard !isObserving else { return }
        
        isObserving = true
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardHandler(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardHandler(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        panGesture?.delegate = self
        UIApplication.shared.windows.first?.addGestureRecognizer(panGesture!)
    }
    
    public func removeObservers() {
        guard isObserving else { return }
        
        isObserving = false
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
        if let gesture = panGesture {
            panGesture?.view?.removeGestureRecognizer(gesture)
            panGesture = nil
        }
    }
    
    // MARK: - Action
    @objc func onKeyboardHandler(_ noti: Notification) {
        guard let rect = (noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        var newFrame = rect
        
        switch noti.name {
        case UIResponder.keyboardWillChangeFrameNotification:
            if rect.origin.y < 0 {
                newFrame.origin.y = screenHeight - newFrame.height
            }
        case UIResponder.keyboardWillHideNotification:
            if rect.minY < 0.0 {
                newFrame.origin.y = screenHeight
            }
        default:
            break
        }
        
        keyboardFrame = newFrame
    }
    
    @objc func onPan(_ gesture: UIPanGestureRecognizer) {
        guard let window = UIApplication.shared.windows.first, gesture.state == .changed && visibleHeight > 0 else { return }
        
        let origin = gesture.location(in: window)
        var newFrame = keyboardFrame
        newFrame.origin.y = max(origin.y, screenHeight - keyboardFrame.height)
        keyboardFrame = newFrame
    }
}

extension KUIKeyboard: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let point = touch.location(in: gestureRecognizer.view)
        var view = gestureRecognizer.view?.hitTest(point, with: nil)
        while let candidate = view {
            if let scrollView = candidate as? UIScrollView, scrollView.keyboardDismissMode == .interactive {
                return true
            }
            view = candidate.superview
        }
        return false
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return gestureRecognizer == panGesture
    }
}

fileprivate extension KUIKeyboard {
    var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
}
