import Foundation

/// Option applied when fetching image
public struct Option {
  /// To apply transition or custom animation when display image
  public let imageDisplayer: ImageDisplayer

  public init(imageDisplayer: ImageDisplayer = ImageViewDisplayer()) {
    self.imageDisplayer = imageDisplayer
  }
}
