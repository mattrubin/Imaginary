import Foundation

/// How to display image onto view
public protocol ImageDisplayer {
  /// How to display the fetched image
  func display(image: Image, onto view: View)
}
