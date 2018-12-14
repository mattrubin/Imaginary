import Foundation

/// Fetch image for you so that you don't have to think.
/// It can be fetched from storage or network.
public class ImageFetcher {
  private let downloader: ImageDownloader

  /// Initialize ImageFetcehr
  ///
  /// - Parameters:
  ///   - downloader: Used to download images.
  ///   - storage: Used to store downloaded images. Pass nil to ignore cache
  public init(downloader: ImageDownloader) {
    self.downloader = downloader
  }

  /// Cancel operations
  public func cancel() {
    downloader.cancel()
  }

  /// Fetch image from url.
  ///
  /// - Parameters:
  ///   - url: The url to fetch.
  ///   - completion: The callback upon completion.
  public func fetch(url: URL, completion: @escaping (Result) -> Void) {
      if url.isFileURL {
        self.fetchFromDisk(url: url, completion: completion)
      } else {
        self.fetchFromNetwork(url: url, completion: completion)
      }
  }

  // MARK: - Helper

  private func fetchFromNetwork(url: URL, completion: @escaping (Result) -> Void) {
    downloader.download(url: url, completion: { result in
      switch result {
      case .value(let image):
        completion(.value(image))
      case .error(let error):
        completion(.error(error))
      }
    })
  }

  private func fetchFromDisk(url: URL, completion: @escaping (Result) -> Void) {
    DispatchQueue.global(qos: .utility).async {
      let fileManager = FileManager.default
      guard let data = fileManager.contents(atPath: url.path) else {
        completion(.error(ImaginaryError.invalidData))
        return
      }

      guard let image = Decompressor().decompress(data: data) else {
        completion(.error(ImaginaryError.conversionError))
        return
      }

      completion(.value(image))
    }
  }

}
