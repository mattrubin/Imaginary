import Foundation

extension View {
  /// Set image with url
  ///
  /// - Parameters:
  ///   - url: The url to fetch
  ///   - completion: Called after done
  public func setImage(url: URL,
                       completion: Completion? = nil) {
    cancelImageFetch()

    self.imageFetcher = ImageFetcher(
      downloader: ImageDownloader(modifyRequest: { $0 })
    )

    self.imageFetcher?.fetch(url: url, completion: { [weak self] result in
      guard let `self` = self else {
        return
      }

      self.handle(url: url, result: result,
                  completion: completion)
    })
  }

  /// Cancel active image fetch
  public func cancelImageFetch() {
    if let imageFetcher = imageFetcher {
      imageFetcher.cancel()
      self.imageFetcher = nil
    }
  }

  private func handle(url: URL, result: Result,
                      completion: Completion?) {
    let option: Option = Option()

    defer {
      DispatchQueue.main.async {
        completion?(result)
      }
    }

    switch result {
    case .value(let image):
      let processedImage = image
      DispatchQueue.main.async {
        option.imageDisplayer.display(image: processedImage, onto: self)
      }
    case .error:
        break
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
