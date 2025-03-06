//
//  AnimatableCustomFontModifier.swift
//  MemoryHelper
//
//  Created by Даниил Иваньков on 05.03.2025.
//
import Foundation
import SwiftUI


struct AnimatableCustomFontModifier: AnimatableModifier {
	
  var animatableData: CGFloat {
    get { size }
    set { size = newValue }
  }
  var size: CGFloat

  func body(content: Content) -> some View {
    content
      .font(.custom("Arial", size: size))
  }

}

extension View {
  func animatableFont(size: CGFloat) -> some View {
    modifier(AnimatableCustomFontModifier(size: size))
  }
}
