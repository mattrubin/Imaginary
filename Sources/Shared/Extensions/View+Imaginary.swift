import UIKit

extension UIImageView {
  /// Set image with url
  ///
  /// - Parameters:
  ///   - url: The url to fetch
  ///   - completion: Called after done
  public func setImage(url: URL, completion: Completion? = nil) {
    cancelImageFetch()

    self.imageFetcher = ImageFetcher()

    self.imageFetcher?.fetch(url: url, completion: { [weak self] result in
      guard let `self` = self else {
        return
      }

      defer {
        DispatchQueue.main.async {
          completion?(result)
        }
      }

      switch result {
      case .value(let image):
        DispatchQueue.main.async {
          UIView.transition(with: self, duration: 0.25,
                            options: [.transitionCrossDissolve, .allowUserInteraction],
                            animations: {
                              self.image = image
          }, completion: nil)
        }
      case .error:
          break
      }
    })
  }

  /// Cancel active image fetch
  public func cancelImageFetch() {
    if let imageFetcher = imageFetcher {
      imageFetcher.cancel()
      self.imageFetcher = nil
    }
  }

  private var imageFetcher: ImageFetcher? {
    get {
      return objc_getAssociatedObject(
        self, &AssociateKey.fetcher) as? ImageFetcher
    }
    set {
      objc_setAssociatedObject(
        self,
        &AssociateKey.fetcher,
        newValue,
        objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
      )
    }
  }
}

/// Used to associate ImageFetcher with ImageView
private struct AssociateKey {
  static var fetcher = 0
}
