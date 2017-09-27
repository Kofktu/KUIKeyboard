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
            visibleHeight = max(0.0, screenHeight - keyboardFrame.minY)
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
    private var isObserving = false
 
    public func addObservers() {
        guard !isObserving else { return }
        
        isObserving = true
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardHandler(_:)), name: .UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardHandler(_:)), name: .UIKeyboardWillHide, object: nil)
        
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        panGesture?.delegate = self
        UIApplication.shared.windows.first?.addGestureRecognizer(panGesture!)
    }
    
    public func removeObservers() {
        guard isObserving else { return }
        
        isObserving = false
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
        
        if let gesture = panGesture {
            panGesture?.view?.removeGestureRecognizer(gesture)
            panGesture = nil
        }
    }
    
    // MARK: - Action
    @objc func onKeyboardHandler(_ noti: Notification) {
        guard let rect = (noti.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        keyboardFrame = rect
        
        switch noti.name {
        case Notification.Name.UIKeyboardWillChangeFrame:
            if rect.minY < 0.0 {
                var newFrame = rect
                newFrame.origin.y = screenHeight - newFrame.height
                keyboardFrame = newFrame
            }
        case Notification.Name.UIKeyboardWillHide:
            if rect.minY < 0.0 {
                var newFrame = rect
                newFrame.origin.y = screenHeight
                keyboardFrame = newFrame
            }
        default:
            break
        }
    }
    
    @objc func onPan(_ gesture: UIPanGestureRecognizer) {
        guard let window = UIApplication.shared.windows.first, gesture.state == .changed && keyboardFrame.minY < screenHeight else { return }
        
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
