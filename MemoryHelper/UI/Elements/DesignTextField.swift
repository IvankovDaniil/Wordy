//
//  DesignTextField.swift
//  MemoryHelper
//
//  Created by Даниил Иваньков on 06.03.2025.
//


//
//  DesignTextField.swift
//  MemoryHelper
//
//  Created by Даниил Иваньков on 05.03.2025.
//
import SwiftUI

struct DesignTextField: View {
    @Binding var text: String
    @FocusState private var focusField: Field?
    @Binding var editing: Bool
    @State private var borderColor = Color.gray
    @State private var borderWidth = 1.0
    
    private let placeholder = "Введите слово"
    @State private var placeholderColor = Color.gray
    @State private var placeholderFontSize = 16.0
    @State private var placeholderBottomPadding = 0.0
    @State private var placeholderBackgroundOpacity = 0.0
    @State private var placeholderLeadingPadding = 2.0
    var isValid: Bool?
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                TextField("", text: $text)
                    .padding(6)
                    .background {
                        RoundedRectangle(cornerRadius: 4, style: .continuous)
                            .stroke(borderColor, lineWidth: borderWidth)
                    }
                    .focused($focusField, equals: .textField)
                
                HStack {
                    ZStack {
                        Color(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                            .opacity(placeholderBackgroundOpacity)
                        Text(placeholder)
                            .foregroundStyle(.white)
                            .colorMultiply(placeholderColor)
                            .animatableFont(size: placeholderFontSize)
                            .padding(2)
                            .layoutPriority(1)
                    }
                    .padding(.leading, placeholderLeadingPadding)
                    .padding(.bottom, placeholderBottomPadding)
                    Spacer()
                }
            }
            
            Text(isValid ?? true ? "" : "Ошибка")
                .font(.custom("Arial", size: 10))
                .foregroundStyle(isValid ?? true ? .gray : .red)
                .padding(.leading, 10)
        }
        .onTapGesture {
            editing = true
        }
        .onChange(of: focusField) { _, newValue in
            withAnimation(.easeOut(duration: 0.1)) {
                updateBorder()
                updatePlaceholder()
            }
        }
        .onChange(of: text) { _, _ in
            withAnimation(.easeOut(duration: 0.1)) {
                updatePlaceholder()
            }
        }
        
    }
    
    private func updateBorder() {
        updateBorderColor()
        updateBorderWidth()
    }
    
    private func updateBorderColor() {
        if isValid == nil {
            placeholderColor = editing ? .blue : .gray
        } else if isValid! {
            placeholderColor = editing ? .blue : .gray
        } else {
            placeholderColor = .red
        }
    }
    
    private func updateBorderWidth() {
        borderWidth = focusField == .textField ? 2.0 : 1.0
    }
    
    private func updatePlaceholder() {
       updatePlaceholderBackground()
       updatePlaceholderColor()
       updatePlaceholderFontSize()
       updatePlaceholderPosition()
     }

     private func updatePlaceholderBackground() {
       placeholderBackgroundOpacity = (editing || !text.isEmpty) ? 1.0 : 0.0
     }
       
     private func updatePlaceholderColor() {
         if isValid == nil {
             placeholderColor = editing ? .blue : .gray
         } else if isValid! {
             placeholderColor = editing ? .blue : .gray
         } else {
             placeholderColor = .red
         }
       
     }

     private func updatePlaceholderFontSize() {
       placeholderFontSize = (editing || !text.isEmpty) ? 10.0 : 16.0
     }

     private func updatePlaceholderPosition() {
       if editing || !text.isEmpty {
         placeholderBottomPadding = 34.0
         placeholderLeadingPadding = 8.0
       } else {
         placeholderBottomPadding = 0.0
         placeholderLeadingPadding = 8.0
       }
     }
    
    private enum Field {
      case textField
    }
}
