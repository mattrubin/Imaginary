import UIKit

/// Error
public enum ImaginaryError: Error {
  case invalidResponse
  case invalidStatusCode
  case invalidData
  case invalidContentLength
  case conversionError
}

/// Result for fetching
public enum Result {
  case value(UIImage)
  case error(Error)
}

public typealias Completion = (Result) -> Void

/// Fetch image for you so that you don't have to think.
/// It can be fetched from storage or network.
public class ImageFetcher {
  private var task: URLSessionDataTask?
  private var active = false

  /// Initialize ImageFetcehr
  public init() {}

  /// Cancel operations
  public func cancel() {
    task?.cancel()
    active = false
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
    active = true

    let request = URLRequest(url: url)
    self.task = URLSession.shared.dataTask(with: request,
                                      completionHandler: { [weak self] data, response, error in
      guard let `self` = self, self.active else {
        return
      }

      defer {
        self.active = false
      }

      if let error = error {
        completion(.error(error))
        return
      }

      guard let httpResponse = response as? HTTPURLResponse else {
        completion(.error(ImaginaryError.invalidResponse))
        return
      }

      guard httpResponse.statusCode == 200 else {
        completion(.error(ImaginaryError.invalidStatusCode))
        return
      }

      guard let data = data, httpResponse.validateLength(data) else {
        completion(.error(ImaginaryError.invalidContentLength))
        return
      }

      guard let decodedImage = UIImage(data: data) else {
        completion(.error(ImaginaryError.conversionError))
        return
      }

      completion(.value(decodedImage))
    })

    self.task?.resume()
  }

  private func fetchFromDisk(url: URL, completion: @escaping (Result) -> Void) {
    DispatchQueue.global(qos: .utility).async {
      let fileManager = FileManager.default
      guard let data = fileManager.contents(atPath: url.path) else {
        completion(.error(ImaginaryError.invalidData))
        return
      }

      guard let image = UIImage(data: data) else {
        completion(.error(ImaginaryError.conversionError))
        return
      }

      completion(.value(image))
    }
  }
}

fileprivate extension HTTPURLResponse {
  func validateLength(_ data: Data) -> Bool {
    return expectedContentLength > -1
      ? (Int64(data.count) >= expectedContentLength)
      : true
  }
}
