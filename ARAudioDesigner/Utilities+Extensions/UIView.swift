//
//  UIView.swift
//  ARAudioDesigner
//
//  Created by Zachery Wagner on 3/28/22.
//

import Foundation
import UIKit

/**
 Extensions for `UIView`
 */
extension UIView {
    
    // MARK: - Layout Constraint Helpers

    private static let pinSuperviewNilErrorMessage = "pinToSuperview: View's superview is nil."

    /**
     * Superview constraint helpers
     */
    @discardableResult
    func pinToSuperview(inset: CGFloat = 0) -> (top: NSLayoutConstraint, leading: NSLayoutConstraint, bottom: NSLayoutConstraint, trailing: NSLayoutConstraint) {
        return pinToSuperview(inset: inset, relations: (top: .equal, leading: .equal, bottom: .equal, trailing: .equal), priorities: (top: .required, leading: .required, bottom: .required, trailing: .required))
    }
    
    /**
     * Superview constraint helpers
     */
    @discardableResult
    func pinToSuperview(inset: CGFloat = 0, relation: NSLayoutConstraint.Relation) -> (top: NSLayoutConstraint, leading: NSLayoutConstraint, bottom: NSLayoutConstraint, trailing: NSLayoutConstraint) {
        return pinToSuperview(inset: inset, relations: (top: relation, leading: relation, bottom: relation, trailing: relation), priorities: (top: .required, leading: .required, bottom: .required, trailing: .required))
    }
    
    /**
     * Superview constraint helpers
     */
    @discardableResult
    func pinToSuperview(inset: CGFloat = 0, priority: UILayoutPriority) -> (top: NSLayoutConstraint, leading: NSLayoutConstraint, bottom: NSLayoutConstraint, trailing: NSLayoutConstraint) {
        return pinToSuperview(inset: inset, relations: (top: .equal, leading: .equal, bottom: .equal, trailing: .equal), priorities: (top: priority, leading: priority, bottom: priority, trailing: priority))
    }
    
    /**
     * Superview constraint helpers
     */
    @discardableResult
    func pinToSuperview(inset: CGFloat = 0 ,relation: NSLayoutConstraint.Relation, priority: UILayoutPriority) -> (top: NSLayoutConstraint, leading: NSLayoutConstraint, bottom: NSLayoutConstraint, trailing: NSLayoutConstraint) {
        return pinToSuperview(inset: inset, relations: (top: relation, leading: relation, bottom: relation, trailing: relation), priorities: (top: priority, leading: priority, bottom: priority, trailing: priority))
    }
    
    /**
     * Superview constraint helpers
     */
    @discardableResult
    func pinToSuperview(inset: CGFloat, relations: (top: NSLayoutConstraint.Relation, leading: NSLayoutConstraint.Relation, bottom: NSLayoutConstraint.Relation, trailing: NSLayoutConstraint.Relation), priorities: (top: UILayoutPriority, leading: UILayoutPriority, bottom: UILayoutPriority, trailing: UILayoutPriority)) -> (top: NSLayoutConstraint, leading: NSLayoutConstraint, bottom: NSLayoutConstraint, trailing: NSLayoutConstraint) {
        
        return pinToSuperviewWithInsets(UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset), relations: relations, priorities: priorities)
    }
    
    /**
     * Superview constraint helpers
     */
    @discardableResult
    func pinToSuperviewWithInsets(_ insets: UIEdgeInsets, relations: (top: NSLayoutConstraint.Relation, leading: NSLayoutConstraint.Relation, bottom: NSLayoutConstraint.Relation, trailing: NSLayoutConstraint.Relation), priorities: (top: UILayoutPriority, leading: UILayoutPriority, bottom: UILayoutPriority, trailing: UILayoutPriority)) -> (top: NSLayoutConstraint, leading: NSLayoutConstraint, bottom: NSLayoutConstraint, trailing: NSLayoutConstraint) {
        
        guard superview != nil else {
            fatalError("\(UIView.pinSuperviewNilErrorMessage): \(self.description)")
        }
        
        let top = pinToSuperviewTopWithInset(insets.top, relation: relations.top, priority: priorities.top)
        let leading = pinToSuperviewLeadingWithInset(insets.left, relation: relations.leading, priority: priorities.leading)
        let bottom = pinToSuperviewBottomWithInset(insets.bottom, relation: relations.bottom, priority: priorities.bottom)
        let trailing = pinToSuperviewTrailingWithInset(insets.right, relation: relations.trailing, priority: priorities.trailing)

        NSLayoutConstraint.activate([top, leading, bottom, trailing])
        
        return (top, leading, bottom, trailing)
    }

    /**
     * Superview constraint helpers
     */
    @discardableResult
    func pinToSuperviewWithInsets(_ insets: UIEdgeInsets = .zero) -> (top: NSLayoutConstraint, leading: NSLayoutConstraint, bottom: NSLayoutConstraint, trailing: NSLayoutConstraint) {
        return pinToSuperviewWithInsets(insets, relations: (top: .equal, leading: .equal, bottom: .equal, trailing: .equal), priorities: (top: .required, leading: .required, bottom: .required, trailing: .required))
    }
    
    /**
     * Superview constraint helpers
     */
    @discardableResult
    func pinToSuperviewSafeArea(inset: CGFloat = 0) -> (top: NSLayoutConstraint, leading: NSLayoutConstraint, bottom: NSLayoutConstraint, trailing: NSLayoutConstraint) {
        return pinToSuperviewSafeArea(inset: inset, relations: (top: .equal, leading: .equal, bottom: .equal, trailing: .equal), priorities: (top: .required, leading: .required, bottom: .required, trailing: .required))
    }
    
    /**
     * Superview constraint helpers
     */
    @discardableResult
    func pinToSuperviewSafeArea(inset: CGFloat = 0, relation: NSLayoutConstraint.Relation) -> (top: NSLayoutConstraint, leading: NSLayoutConstraint, bottom: NSLayoutConstraint, trailing: NSLayoutConstraint) {
        return pinToSuperviewSafeArea(inset: inset, relations: (top: relation, leading: relation, bottom: relation, trailing: relation), priorities: (top: .required, leading: .required, bottom: .required, trailing: .required))
    }
    
    /**
     * Superview constraint helpers
     */
    @discardableResult
    func pinToSuperviewSafeArea(inset: CGFloat = 0, priority: UILayoutPriority) -> (top: NSLayoutConstraint, leading: NSLayoutConstraint, bottom: NSLayoutConstraint, trailing: NSLayoutConstraint) {
        return pinToSuperviewSafeArea(inset: inset, relations: (top: .equal, leading: .equal, bottom: .equal, trailing: .equal), priorities: (top: priority, leading: priority, bottom: priority, trailing: priority))
    }

    /**
     * Superview constraint helpers
     */
    @discardableResult
    func pinToSuperviewSafeArea(inset: CGFloat = 0 ,relation: NSLayoutConstraint.Relation, priority: UILayoutPriority) -> (top: NSLayoutConstraint, leading: NSLayoutConstraint, bottom: NSLayoutConstraint, trailing: NSLayoutConstraint) {
        return pinToSuperviewSafeArea(inset: inset, relations: (top: relation, leading: relation, bottom: relation, trailing: relation), priorities: (top: priority, leading: priority, bottom: priority, trailing: priority))
    }
    
    /**
     * Superview constraint helpers
     */
    @discardableResult
    func pinToSuperviewSafeArea(inset: CGFloat = 0, relations: (top: NSLayoutConstraint.Relation, leading: NSLayoutConstraint.Relation, bottom: NSLayoutConstraint.Relation, trailing: NSLayoutConstraint.Relation), priorities: (top: UILayoutPriority, leading: UILayoutPriority, bottom: UILayoutPriority, trailing: UILayoutPriority)) -> (top: NSLayoutConstraint, leading: NSLayoutConstraint, bottom: NSLayoutConstraint, trailing: NSLayoutConstraint) {
        
        guard superview != nil else {
            fatalError("\(UIView.pinSuperviewNilErrorMessage): \(self.description)")
        }
        
        let top = pinToSuperviewSafeAreaTopWithInset(inset, relation: relations.top, priority: priorities.top)
        top.isActive = true
        
        let leading = pinToSuperviewSafeAreaLeadingWithInset(inset, relation: relations.leading, priority: priorities.leading)
        leading.isActive = true
        
        let bottom = pinToSuperviewSafeAreaBottomWithInset(inset, relation: relations.bottom, priority: priorities.bottom)
        bottom.isActive = true
        
        let trailing = pinToSuperviewSafeAreaTrailingWithInset(inset, relation: relations.trailing, priority: priorities.trailing)
        trailing.isActive = true
        
        return (top, leading, bottom, trailing)
    }
    
    // MARK: - Top to Superview Top

    /**
     * Top constraint helpers
     */
    @discardableResult
    func pinToSuperviewTop() -> NSLayoutConstraint {
        return pinToSuperviewTopWithInset(0, relation: .equal)
    }

    @discardableResult
    func pinToSuperviewTop(_ relation: NSLayoutConstraint.Relation) -> NSLayoutConstraint {
        return pinToSuperviewTopWithInset(0, relation: relation)
    }

    @discardableResult
    func pinToSuperviewTopWithInset(_ inset: CGFloat, relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        return pinToSuperviewTopWithInset(inset, relation: relation, priority: .required)
    }

    @discardableResult
    func pinToSuperviewTopWithInset(_ inset: CGFloat, relation: NSLayoutConstraint.Relation, priority: UILayoutPriority) -> NSLayoutConstraint {
        if let superview = self.superview {
            let top = getYAxisConstraintFromAnchor(topAnchor, toAnchor: superview.topAnchor, withRelation: relation, withConstant: inset)
            top.priority = priority
            top.isActive = true
            return top
        }

        print("\(UIView.pinSuperviewNilErrorMessage): \(self.description)")
        fatalError("\(UIView.pinSuperviewNilErrorMessage): \(self.description)")
    }

    @discardableResult
    func pinToSuperviewSafeAreaTop() -> NSLayoutConstraint {
        return pinToSuperviewSafeAreaTopWithInset(0, relation: .equal)
    }

    @discardableResult
    func pinToSuperviewSafeAreaTop(_ relation: NSLayoutConstraint.Relation) -> NSLayoutConstraint {
        return pinToSuperviewSafeAreaTopWithInset(0, relation: relation)
    }

    @discardableResult
    func pinToSuperviewSafeAreaTopWithInset(_ inset: CGFloat, relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        return pinToSuperviewSafeAreaTopWithInset(inset, relation: relation, priority: .required)
    }

    @discardableResult
    func pinToSuperviewSafeAreaTopWithInset(_ inset: CGFloat, relation: NSLayoutConstraint.Relation, priority: UILayoutPriority) -> NSLayoutConstraint {
        if let superview = self.superview {
            if #available(iOS 11, *) {
                let top = getYAxisConstraintFromAnchor(self.topAnchor, toAnchor: superview.safeAreaLayoutGuide.topAnchor, withRelation: relation, withConstant: inset)
                top.priority = priority
                top.isActive = true
                return top
            } else {
                pinToSuperviewTopWithInset(inset, relation: relation)
            }
        }
        print("\(UIView.pinSuperviewNilErrorMessage): \(self.description)")
        fatalError("\(UIView.pinSuperviewNilErrorMessage): \(self.description)")
    }
    
    // MARK: - Leading to Superview Leading

    /**
     * Leading constraint helpers
     */
    @discardableResult
    func pinToSuperviewLeading() -> NSLayoutConstraint {
        return pinToSuperviewLeadingWithInset(0, relation: .equal)
    }

    @discardableResult
    func pinToSuperviewLeading(_ relation: NSLayoutConstraint.Relation) -> NSLayoutConstraint {
        return pinToSuperviewLeadingWithInset(0, relation: relation)
    }

    @discardableResult
    func pinToSuperviewLeadingWithInset(_ inset: CGFloat, relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        return pinToSuperviewLeadingWithInset(inset, relation: relation, priority: .required)
    }

    @discardableResult
    func pinToSuperviewLeadingWithInset(_ inset: CGFloat, relation: NSLayoutConstraint.Relation, priority: UILayoutPriority) -> NSLayoutConstraint {
        if let superview = self.superview {
            let leading = getXAxisConstraintFromAnchor(leadingAnchor, toAnchor: superview.leadingAnchor, withRelation: relation, withConstant: inset)
            leading.priority = priority
            leading.isActive = true
            return leading
        }

        print("\(UIView.pinSuperviewNilErrorMessage): \(self.description)")
        fatalError("\(UIView.pinSuperviewNilErrorMessage): \(self.description)")
    }

    @discardableResult
    func pinToSuperviewSafeAreaLeading() -> NSLayoutConstraint {
        return pinToSuperviewSafeAreaLeadingWithInset(0, relation: .equal)
    }

    @discardableResult
    func pinToSuperviewSafeAreaLeading(_ relation: NSLayoutConstraint.Relation) -> NSLayoutConstraint {
        return pinToSuperviewSafeAreaLeadingWithInset(0, relation: relation)
    }

    @discardableResult
    func pinToSuperviewSafeAreaLeadingWithInset(_ inset: CGFloat, relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        return pinToSuperviewSafeAreaLeadingWithInset(inset, relation: relation, priority: .required)
    }

    @discardableResult
    func pinToSuperviewSafeAreaLeadingWithInset(_ inset: CGFloat, relation: NSLayoutConstraint.Relation, priority: UILayoutPriority) -> NSLayoutConstraint {
        if let superview = self.superview {
            if #available(iOS 11, *) {
                let leading = getXAxisConstraintFromAnchor(self.leadingAnchor, toAnchor: superview.safeAreaLayoutGuide.leadingAnchor, withRelation: relation, withConstant: inset)
                leading.priority = priority
                leading.isActive = true
                return leading
            } else {
                pinToSuperviewLeadingWithInset(inset, relation: relation)
            }
        }
        print("\(UIView.pinSuperviewNilErrorMessage): \(self.description)")
        fatalError("\(UIView.pinSuperviewNilErrorMessage): \(self.description)")
    }
    
    // MARK: - Bottom to Superview Bottom

    /**
     * Bottom constraint helpers
     */
    @discardableResult
    func pinToSuperviewBottom() -> NSLayoutConstraint {
        return pinToSuperviewBottomWithInset(0, relation: .equal)
    }

    @discardableResult
    func pinToSuperviewBottom(_ relation: NSLayoutConstraint.Relation) -> NSLayoutConstraint {
        return pinToSuperviewBottomWithInset(0, relation: relation)
    }

    @discardableResult
    func pinToSuperviewBottomWithInset(_ inset: CGFloat, relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        return pinToSuperviewBottomWithInset(inset, relation: relation, priority: .required)
    }

    @discardableResult
    func pinToSuperviewBottomWithInset(_ inset: CGFloat, relation: NSLayoutConstraint.Relation, priority: UILayoutPriority) -> NSLayoutConstraint {
        if let superview = self.superview {
            let bottom = getYAxisConstraintFromAnchor(superview.bottomAnchor, toAnchor: bottomAnchor, withRelation: relation, withConstant: inset)
            bottom.priority = priority
            bottom.isActive = true
            return bottom
        }

        print("\(UIView.pinSuperviewNilErrorMessage): \(self.description)")
        fatalError("\(UIView.pinSuperviewNilErrorMessage): \(self.description)")
    }

    @discardableResult
    func pinToSuperviewSafeAreaBottom() -> NSLayoutConstraint {
        return pinToSuperviewSafeAreaBottomWithInset(0, relation: .equal)
    }

    @discardableResult
    func pinToSuperviewSafeAreaBottom(_ relation: NSLayoutConstraint.Relation) -> NSLayoutConstraint {
        return pinToSuperviewSafeAreaBottomWithInset(0, relation: relation)
    }

    @discardableResult
    func pinToSuperviewSafeAreaBottomWithInset(_ inset: CGFloat, relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        return pinToSuperviewSafeAreaBottomWithInset(inset, relation: relation, priority: .required)
    }

    @discardableResult
    func pinToSuperviewSafeAreaBottomWithInset(_ inset: CGFloat, relation: NSLayoutConstraint.Relation, priority: UILayoutPriority) -> NSLayoutConstraint {
        if let superview = self.superview {
            if #available(iOS 11, *) {
                let bottom = getYAxisConstraintFromAnchor(superview.safeAreaLayoutGuide.bottomAnchor, toAnchor: bottomAnchor, withRelation: relation, withConstant: inset)
                bottom.priority = priority
                bottom.isActive = true
                return bottom
            } else {
                pinToSuperviewBottomWithInset(inset, relation: relation, priority: priority)
            }
        }
        print("\(UIView.pinSuperviewNilErrorMessage): \(self.description)")
        fatalError("\(UIView.pinSuperviewNilErrorMessage): \(self.description)")
    }
    
    // MARK: - Traling to Superview Trailing

    /**
     * Trailing constraint helpers
     */

    @discardableResult
    func pinToSuperviewTrailing() -> NSLayoutConstraint {
        return pinToSuperviewTrailingWithInset(0, relation: .equal)
    }

    @discardableResult
    func pinToSuperviewTrailing(_ relation: NSLayoutConstraint.Relation) -> NSLayoutConstraint {
        return pinToSuperviewTrailingWithInset(0, relation: relation)
    }

    @discardableResult
    func pinToSuperviewTrailingWithInset(_ inset: CGFloat, relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        return pinToSuperviewTrailingWithInset(inset, relation: relation, priority: .required)
    }

    @discardableResult
    func pinToSuperviewTrailingWithInset(_ inset: CGFloat, relation: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority) -> NSLayoutConstraint {
        if let superview = self.superview {
            let trailing = getXAxisConstraintFromAnchor(superview.trailingAnchor, toAnchor: trailingAnchor, withRelation: relation, withConstant: inset)
            trailing.priority = priority
            trailing.isActive = true
            return trailing
        }

        print("\(UIView.pinSuperviewNilErrorMessage): \(self.description)")
        fatalError("\(UIView.pinSuperviewNilErrorMessage): \(self.description)")
    }

    @discardableResult
    func pinToSuperviewSafeAreaTrailing() -> NSLayoutConstraint {
        return pinToSuperviewSafeAreaTrailingWithInset(0, relation: .equal)
    }

    @discardableResult
    func pinToSuperviewSafeAreaTrailing(_ relation: NSLayoutConstraint.Relation) -> NSLayoutConstraint {
        return pinToSuperviewSafeAreaTrailingWithInset(0, relation: relation)
    }

    @discardableResult
    func pinToSuperviewSafeAreaTrailingWithInset(_ inset: CGFloat, relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        return pinToSuperviewSafeAreaTrailingWithInset(inset, relation: relation, priority: .required)
    }

    @discardableResult
    func pinToSuperviewSafeAreaTrailingWithInset(_ inset: CGFloat, relation: NSLayoutConstraint.Relation, priority: UILayoutPriority) -> NSLayoutConstraint {
        if let superview = self.superview {
            if #available(iOS 11, *) {
                let trailing = getXAxisConstraintFromAnchor(superview.safeAreaLayoutGuide.trailingAnchor, toAnchor: trailingAnchor, withRelation: relation, withConstant: inset)
                trailing.priority = priority
                trailing.isActive = true
                return trailing
            } else {
                pinToSuperviewTrailingWithInset(inset, relation: relation, priority: priority)
            }
        }
        print("\(UIView.pinSuperviewNilErrorMessage): \(self.description)")
        fatalError("\(UIView.pinSuperviewNilErrorMessage): \(self.description)")
    }
    
    // MARK: - View to Size

    /**
     * Size constraint helpers
     */

    @discardableResult
    func pinToSize(_ size: CGSize) -> (width: NSLayoutConstraint, height: NSLayoutConstraint) {
        return (width: pinWidthTo(size.width), height: pinHeightTo(size.height))
    }

    @discardableResult
    func pinHeightTo(_ constant: CGFloat) -> NSLayoutConstraint {
        let height = getHeightConstraintWithRelation(.equal, withConstant: constant)
        height.isActive = true
        return height
    }

    @discardableResult
    func pinHeightTo(_ constant: CGFloat, priority: UILayoutPriority) -> NSLayoutConstraint {
        return pinHeightTo(constant, relation: .equal, priority: priority)
    }

    @discardableResult
    func pinHeightTo(_ constant: CGFloat, relation: NSLayoutConstraint.Relation, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        let height = getHeightConstraintWithRelation(relation, withConstant: constant)
        height.priority = priority
        height.isActive = true
        return height
    }

    @discardableResult
    func pinHeightTo(_ heightAnchor: NSLayoutAnchor<NSLayoutDimension>, constant: CGFloat = 0) -> NSLayoutConstraint {
        let height = self.heightAnchor.constraint(equalTo: heightAnchor, constant: constant)
        height.isActive = true
        return height
    }

    @discardableResult
    func pinHeightTo(_ anchor: NSLayoutAnchor<NSLayoutDimension>, constant: CGFloat, relation: NSLayoutConstraint.Relation, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        let height = getDimensionConstraintFromAnchor(heightAnchor, toAnchor: anchor, withRelation: relation, withConstant: constant)
        height.priority = priority
        height.isActive = true
        return height
    }

    @discardableResult
    func pinHeightToWidthWithRatio(_ ratio: CGFloat, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        let constraint = heightAnchor.constraint(equalTo: widthAnchor, multiplier: ratio)
        constraint.priority = priority
        constraint.isActive = true
        return constraint
    }

    @discardableResult
    func pinWidthToHeightWithRatio(_ ratio: CGFloat, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        let constraint = widthAnchor.constraint(equalTo: heightAnchor, multiplier: ratio)
        constraint.priority = priority
        constraint.isActive = true
        return constraint
    }

    @discardableResult
    func pinWidthTo(_ constant: CGFloat) -> NSLayoutConstraint {
        let width = getWidthConstraintWithRelation(.equal, withConstant: constant)
        width.isActive = true
        return width
    }

    @discardableResult
    func pinWidthTo(_ constant: CGFloat, priority: UILayoutPriority) -> NSLayoutConstraint {
        return pinWidthTo(constant, relation: .equal, priority: priority)
    }

    @discardableResult
    func pinWidthTo(_ constant: CGFloat, relation: NSLayoutConstraint.Relation, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        let width = getWidthConstraintWithRelation(relation, withConstant: constant)
        width.priority = priority
        width.isActive = true
        return width
    }

    @discardableResult
    func pinWidthTo(_ widthAnchor: NSLayoutAnchor<NSLayoutDimension>, constant: CGFloat = 0) -> NSLayoutConstraint {
        let width = self.widthAnchor.constraint(equalTo: widthAnchor, constant: constant)
        width.isActive = true
        return width
    }

    @discardableResult
    func pinWidthTo(_ anchor: NSLayoutAnchor<NSLayoutDimension>, constant: CGFloat, relation: NSLayoutConstraint.Relation) -> NSLayoutConstraint {
        let width = getDimensionConstraintFromAnchor(widthAnchor, toAnchor: anchor, withRelation: relation, withConstant: constant)
        width.isActive = true
        return width
    }

    @discardableResult
    func pinWidthTo(_ anchor: NSLayoutAnchor<NSLayoutDimension>, constant: CGFloat, relation: NSLayoutConstraint.Relation, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        let width = getDimensionConstraintFromAnchor(widthAnchor, toAnchor: anchor, withRelation: relation, withConstant: constant)
        width.priority = priority
        width.isActive = true
        return width
    }
    
    // MARK: - Top to Anchor

    @discardableResult
    func pinTopToAnchor(_ anchor: NSLayoutYAxisAnchor, withInset inset: CGFloat = 0) -> NSLayoutConstraint {
        return pinTopToAnchor(anchor, withInset: inset, relation: .equal)
    }

    @discardableResult
    func pinTopToAnchor(_ anchor: NSLayoutYAxisAnchor, withPriority priority: UILayoutPriority) -> NSLayoutConstraint {
        return pinTopToAnchor(anchor, withInset: 0, relation: .equal, priority: priority)
    }

    @discardableResult
    func pinTopToAnchor(_ anchor: NSLayoutYAxisAnchor, withRelation relation: NSLayoutConstraint.Relation) -> NSLayoutConstraint {
        return pinTopToAnchor(anchor, withInset: 0, relation: relation)
    }

    @discardableResult
    func pinTopToAnchor(_ anchor: NSLayoutYAxisAnchor, withInset inset: CGFloat, relation: NSLayoutConstraint.Relation, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        var top = self.topAnchor.constraint(equalTo: anchor, constant: inset)

        switch relation {
        case .lessThanOrEqual:
            top = self.topAnchor.constraint(lessThanOrEqualTo: anchor, constant: inset)
        case .equal:
            top = self.topAnchor.constraint(equalTo: anchor, constant: inset)
        case .greaterThanOrEqual:
            top = self.topAnchor.constraint(greaterThanOrEqualTo: anchor, constant: inset)
        @unknown default:
            top = self.topAnchor.constraint(equalTo: anchor, constant: inset)
        }

        top.priority = priority
        top.isActive = true
        return top
    }
    
    // MARK: - Leading to Anchor

    @discardableResult
    func pinLeadingToAnchor(_ anchor: NSLayoutXAxisAnchor, withInset inset: CGFloat = 0) -> NSLayoutConstraint {
        return pinLeadingToAnchor(anchor, withInset: inset, relation: .equal)
    }

    @discardableResult
    func pinLeadingToAnchor(_ anchor: NSLayoutXAxisAnchor, withPriority priority: UILayoutPriority) -> NSLayoutConstraint {
        return pinLeadingToAnchor(anchor, withInset: 0, relation: .equal, priority: priority)
    }

    @discardableResult
    func pinLeadingToAnchor(_ anchor: NSLayoutXAxisAnchor, withRelation relation: NSLayoutConstraint.Relation) -> NSLayoutConstraint {
        return pinLeadingToAnchor(anchor, withInset: 0, relation: relation)
    }

    @discardableResult
    func pinLeadingToAnchor(_ anchor: NSLayoutXAxisAnchor, withInset inset: CGFloat, relation: NSLayoutConstraint.Relation, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        var leading = self.leadingAnchor.constraint(equalTo: anchor, constant: inset)

        switch relation {
        case .lessThanOrEqual:
            leading = self.leadingAnchor.constraint(lessThanOrEqualTo: anchor, constant: inset)
        case .equal:
            leading = self.leadingAnchor.constraint(equalTo: anchor, constant: inset)
        case .greaterThanOrEqual:
            leading = self.leadingAnchor.constraint(greaterThanOrEqualTo: anchor, constant: inset)
        @unknown default:
            leading = self.leadingAnchor.constraint(equalTo: anchor, constant: inset)
        }
        
        leading.priority = priority
        leading.isActive = true
        return leading
    }
    
    // MARK: - Bottom to Anchor

    @discardableResult
    func pinBottomToAnchor(_ anchor: NSLayoutYAxisAnchor, withInset inset: CGFloat = 0) -> NSLayoutConstraint {
        return pinBottomToAnchor(anchor, withInset: inset, relation: .equal)
    }

    @discardableResult
    func pinBottomToAnchor(_ anchor: NSLayoutYAxisAnchor, withPriority priority: UILayoutPriority) -> NSLayoutConstraint {
        return pinBottomToAnchor(anchor, withInset: 0, relation: .equal, priority: priority)
    }

    @discardableResult
    func pinBottomToAnchor(_ anchor: NSLayoutYAxisAnchor, withRelation relation: NSLayoutConstraint.Relation) -> NSLayoutConstraint {
        return pinBottomToAnchor(anchor, withInset: 0, relation: relation)
    }

    @discardableResult
    func pinBottomToAnchor(_ anchor: NSLayoutYAxisAnchor, withInset inset: CGFloat, relation: NSLayoutConstraint.Relation, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        var bottom = anchor.constraint(equalTo: self.bottomAnchor, constant: inset)

        switch relation {
        case .lessThanOrEqual:
            bottom = anchor.constraint(lessThanOrEqualTo: self.bottomAnchor, constant: inset)
        case .equal:
            bottom = anchor.constraint(equalTo: self.bottomAnchor, constant: inset)
        case .greaterThanOrEqual:
            bottom = anchor.constraint(greaterThanOrEqualTo: self.bottomAnchor, constant: inset)
        @unknown default:
            bottom = anchor.constraint(equalTo: self.bottomAnchor, constant: inset)
        }

        bottom.priority = priority
        bottom.isActive = true
        return bottom
    }

    @discardableResult
    func pinBottomToAnchor(_ anchor: NSLayoutYAxisAnchor, withInset inset: CGFloat, withRelation relation: NSLayoutConstraint.Relation) -> NSLayoutConstraint {
        let bottom = getYAxisConstraintFromAnchor(anchor, toAnchor: self.bottomAnchor, withRelation: relation, withConstant: inset)
        bottom.isActive = true
        return bottom
    }
    
    // MARK: - Trailing to Anchor

    @discardableResult
    func pinTrailingToAnchor(_ anchor: NSLayoutXAxisAnchor, withInset inset: CGFloat = 0) -> NSLayoutConstraint {
        return pinTrailingToAnchor(anchor, withInset: inset, relation: .equal)
    }

    @discardableResult
    func pinTrailingToAnchor(_ anchor: NSLayoutXAxisAnchor, withPriority priority: UILayoutPriority) -> NSLayoutConstraint {
        return pinTrailingToAnchor(anchor, withInset: 0, relation: .equal, priority: priority)
    }

    @discardableResult
    func pinTrailingToAnchor(_ anchor: NSLayoutXAxisAnchor, withRelation relation: NSLayoutConstraint.Relation) -> NSLayoutConstraint {
        return pinTrailingToAnchor(anchor, withInset: 0, relation: relation)
    }

    @discardableResult
    func pinTrailingToAnchor(_ anchor: NSLayoutXAxisAnchor, withInset inset: CGFloat, relation: NSLayoutConstraint.Relation, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        var trailing = self.trailingAnchor.constraint(equalTo: anchor, constant: inset)

        switch relation {
        case .lessThanOrEqual:
            trailing = self.trailingAnchor.constraint(lessThanOrEqualTo: anchor, constant: inset)
        case .equal:
            trailing = self.trailingAnchor.constraint(equalTo: anchor, constant: inset)
        case .greaterThanOrEqual:
            trailing = self.trailingAnchor.constraint(greaterThanOrEqualTo: anchor, constant: inset)
        @unknown default:
            trailing = self.trailingAnchor.constraint(equalTo: anchor, constant: inset)
        }

        trailing.priority = priority
        trailing.isActive = true
        return trailing
    }
    
    // MARK: - Center
    
    @discardableResult
    func pinCenterXToAnchor(_ anchor: NSLayoutAnchor<NSLayoutXAxisAnchor>, withConstant constant: CGFloat) -> NSLayoutConstraint {
        let constraint = self.centerXAnchor.constraint(equalTo: anchor, constant: constant)
        constraint.isActive = true
        return constraint
    }

    @discardableResult
    func pinCenterYToAnchor(_ anchor: NSLayoutAnchor<NSLayoutYAxisAnchor>, withConstant constant: CGFloat) -> NSLayoutConstraint {
        let constraint = self.centerYAnchor.constraint(equalTo: anchor, constant: constant)
        constraint.isActive = true
        return constraint
    }

    @discardableResult
    func pinCenterYToAnchor(_ anchor: NSLayoutAnchor<NSLayoutYAxisAnchor>, withConstant constant: CGFloat, priority: UILayoutPriority) -> NSLayoutConstraint {
        let constraint = self.centerYAnchor.constraint(equalTo: anchor, constant: constant)
        constraint.isActive = true
        constraint.priority = priority
        return constraint
    }

    @discardableResult
    func pinToSuperviewCenterX() -> NSLayoutConstraint {
        if let superview = self.superview {
            return pinCenterXToAnchor(superview.centerXAnchor, withConstant: 0)
        }
        print("\(UIView.pinSuperviewNilErrorMessage): \(self.description)")
        fatalError("\(UIView.pinSuperviewNilErrorMessage): \(self.description)")
    }

    @discardableResult
    func pinToSuperviewCenterY() -> NSLayoutConstraint {
        if let superview = self.superview {
            return pinCenterYToAnchor(superview.centerYAnchor, withConstant: 0)
        }
        print("\(UIView.pinSuperviewNilErrorMessage): \(self.description)")
        fatalError("\(UIView.pinSuperviewNilErrorMessage): \(self.description)")
    }

    @discardableResult
    func pinToSuperviewCenter() -> (centerX: NSLayoutConstraint, centerY: NSLayoutConstraint) {
        if let superview = self.superview {
            return (centerX: pinCenterXToAnchor(superview.centerXAnchor, withConstant: 0), centerY: pinCenterYToAnchor(superview.centerYAnchor, withConstant: 0))
        }
        print("\(UIView.pinSuperviewNilErrorMessage): \(self.description)")
        fatalError("\(UIView.pinSuperviewNilErrorMessage): \(self.description)")
    }

    // MARK: - Internal Getters
    
    private func getHeightConstraintWithRelation(_ relation: NSLayoutConstraint.Relation, withConstant constant: CGFloat = 0) -> NSLayoutConstraint {
        switch relation {

        case .lessThanOrEqual:
            return heightAnchor.constraint(lessThanOrEqualToConstant: constant)
        case .equal:
            return heightAnchor.constraint(equalToConstant: constant)
        case .greaterThanOrEqual:
            return heightAnchor.constraint(greaterThanOrEqualToConstant: constant)
        @unknown default:
            return heightAnchor.constraint(equalToConstant: constant)
        }
    }
    
    private func getWidthConstraintWithRelation(_ relation: NSLayoutConstraint.Relation, withConstant constant: CGFloat = 0) -> NSLayoutConstraint {
        switch relation {

        case .lessThanOrEqual:
            return widthAnchor.constraint(lessThanOrEqualToConstant: constant)
        case .equal:
            return widthAnchor.constraint(equalToConstant: constant)
        case .greaterThanOrEqual:
            return widthAnchor.constraint(greaterThanOrEqualToConstant: constant)
        @unknown default:
            return widthAnchor.constraint(equalToConstant: constant)
        }
    }

    private func getYAxisConstraintFromAnchor(_ anchor: NSLayoutYAxisAnchor, toAnchor anchor2: NSLayoutYAxisAnchor, withRelation relation: NSLayoutConstraint.Relation, withConstant constant: CGFloat = 0) -> NSLayoutConstraint {
        switch relation {

        case .lessThanOrEqual:
            return anchor.constraint(lessThanOrEqualTo: anchor2, constant: constant)
        case .equal:
            return anchor.constraint(equalTo: anchor2, constant: constant)
        case .greaterThanOrEqual:
            return anchor.constraint(greaterThanOrEqualTo: anchor2, constant: constant)
        @unknown default:
            return anchor.constraint(equalTo: anchor2, constant: constant)
        }
    }

    private func getXAxisConstraintFromAnchor(_ anchor: NSLayoutXAxisAnchor, toAnchor anchor2: NSLayoutXAxisAnchor, withRelation relation: NSLayoutConstraint.Relation, withConstant constant: CGFloat = 0) -> NSLayoutConstraint {
        switch relation {

        case .lessThanOrEqual:
            return anchor.constraint(lessThanOrEqualTo: anchor2, constant: constant)
        case .equal:
            return anchor.constraint(equalTo: anchor2, constant: constant)
        case .greaterThanOrEqual:
            return anchor.constraint(greaterThanOrEqualTo: anchor2, constant: constant)
        @unknown default:
            return anchor.constraint(equalTo: anchor2, constant: constant)
        }
    }

    private func getDimensionConstraintFromAnchor(_ anchor: NSLayoutAnchor<NSLayoutDimension>, toAnchor anchor2: NSLayoutAnchor<NSLayoutDimension>, withRelation relation: NSLayoutConstraint.Relation, withConstant constant: CGFloat = 0) -> NSLayoutConstraint {
        switch relation {

        case .lessThanOrEqual:
            return anchor.constraint(lessThanOrEqualTo: anchor2, constant: constant)
        case .equal:
            return anchor.constraint(equalTo: anchor2, constant: constant)
        case .greaterThanOrEqual:
            return anchor.constraint(greaterThanOrEqualTo: anchor2, constant: constant)
        @unknown default:
            return anchor.constraint(equalTo: anchor2, constant: constant)
        }
    }
}
