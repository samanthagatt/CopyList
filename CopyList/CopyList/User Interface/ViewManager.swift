//
//  ViewManager.swift
//  CopyList
//
//  Created by Samantha Gatt on 7/5/19.
//  Copyright © 2019 Samantha Gatt. All rights reserved.
//

import UIKit

enum ViewManager {
    
    /**
     Creates a customized UILabel
     
     Use this function when creating a new label
     - Note: Chain `addStyling` `UIView` instance method to customize 'UIView' properties as well
     - Author: Samantha Gatt
     - Parameters:
         - text: The current text that is displayed by the label.
         - attributedText: The current styled text that is displayed by the label.
         - font: The font used to display the text.
         - textColor: The color of the text.
         - textAlignment: The technique to use for aligning the text.
         - lineBreakMode: The technique to use for wrapping and truncating the label’s text.
         - numberOfLines: The maximum number of lines to use for rendering text.
         - translatesMask: A Boolean value that determines whether the view’s autoresizing mask is translated into Auto Layout constraints.
     */
    static func label(text: String? = nil, attributedText: NSAttributedString? = nil, font: UIFont, textColor: UIColor, textAlignment: NSTextAlignment = .natural, lineBreakMode: NSLineBreakMode = .byTruncatingTail, numberOfLines: Int = 0, translatesMask: Bool = false) -> UILabel {
        let label = UILabel()
        label.text = text
        if let attributedText = attributedText {
            label.attributedText = attributedText
        }
        label.font = font
        label.textColor = textColor
        label.textAlignment = textAlignment
        label.lineBreakMode = lineBreakMode
        label.numberOfLines = numberOfLines
        label.translatesAutoresizingMaskIntoConstraints = translatesMask
        return label
    }
    
    /**
     Creates a customized UITextField
     
     Use this function when creating a new text field
     - Note: Chain `addStyling` `UIView` instance method to customize 'UIView' properties as well
     - Author: Samantha Gatt
     - Parameters:
         - text: The text displayed by the text field.
         - placeholder: The string that is displayed when there is no other text in the text field.
         - font: The font of the text.
         - textColor: The color of the text.
         - textAlignment: The technique to use for aligning the text.
         - borderStyle: The border style used by the text field.
         - keyboardType: The keyboard style associated with the text object.
         - returnKeyType: The visible title of the Return key.
         - textContentType: ndicates the semantic meaning expected by a text-entry area.
         - isSecureTextEntry: Identifies whether the text object should disable text copying and in some cases hide the text being entered.
         - autocapitalizationType: The auto-capitalization style for the text object.
         - autocorrectionType: The autocorrection style for the text object.
         - spellCheckingType: The spell-checking style for the text object.
         - delegate: The receiver’s delegate.
         - translatesMask: A Boolean value that determines whether the view’s autoresizing mask is translated into Auto Layout constraints.
     */
    static func textField(text: String? = nil, placeholder: String? = nil, font: UIFont = .preferredFont(forTextStyle: .body), textColor: UIColor = .black, textAlignment: NSTextAlignment = .natural, borderStyle: UITextField.BorderStyle = .none, textContentType: UITextContentType? = nil, keyboardType: UIKeyboardType = .default, returnKeyType: UIReturnKeyType = .default, isSecureTextEntry: Bool = false, autocapitalizationType: UITextAutocapitalizationType = .sentences, autocorrectionType: UITextAutocorrectionType = .default, spellCheckingType: UITextSpellCheckingType = .default, delegate: UITextFieldDelegate? = nil, translatesMask: Bool = false) -> UITextField {
        let textField = UITextField()
        textField.text = text
        textField.placeholder = placeholder
        textField.font = font
        textField.textColor = textColor
        textField.textAlignment = textAlignment
        textField.borderStyle = borderStyle
        textField.keyboardType = keyboardType
        textField.returnKeyType = returnKeyType
        textField.textContentType = textContentType
        textField.isSecureTextEntry = isSecureTextEntry
        textField.autocapitalizationType = autocapitalizationType
        textField.autocorrectionType = autocorrectionType
        textField.spellCheckingType = spellCheckingType
        textField.delegate = delegate
        textField.translatesAutoresizingMaskIntoConstraints = translatesMask
        return textField
    }
    
    static func button(type: UIButton.ButtonType = .custom, titlesForStates: [(String?, UIControl.State)] = [], attributedTitlesForStates: [(NSAttributedString?, UIControl.State)] = [], textColorsForStates: [(UIColor?, UIControl.State)] = [], font: UIFont? = nil, shadowColorsForStates: [(UIColor?, UIControl.State)] = [], contentEdgeInsets: UIEdgeInsets = .zero, titleEdgeInsets: UIEdgeInsets = .zero, imageEdgeInsets: UIEdgeInsets = .zero, translatesMask: Bool = false) -> UIButton {
        let button = UIButton(type: type)
        for (title, state) in titlesForStates {
            button.setTitle(title, for: state)
        }
        for (attributedTitle, state) in attributedTitlesForStates {
            button.setAttributedTitle(attributedTitle, for: state)
        }
        for (color, state) in textColorsForStates {
            button.setTitleColor(color, for: state)
        }
        for (shadowColor, state) in shadowColorsForStates {
            button.setTitleShadowColor(shadowColor, for: state)
        }
        button.titleLabel?.font = font
        button.contentEdgeInsets = contentEdgeInsets
        button.titleEdgeInsets = titleEdgeInsets
        button.imageEdgeInsets = imageEdgeInsets
        button.translatesAutoresizingMaskIntoConstraints = translatesMask
        return button
    }
}
