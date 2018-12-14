import Foundation

/// Option applied when fetching image
public struct Option {
  /// To apply transition or custom animation when display image
  public let imageDisplayer: ImageDisplayer

  /// Specify ImageDownloader and request modifier
  public var downloaderMaker: () -> ImageDownloader = {
    return ImageDownloader(modifyRequest: { $0 })
  }

  public init(imageDisplayer: ImageDisplayer = ImageViewDisplayer()) {
    self.imageDisplayer = imageDisplayer
  }
}
