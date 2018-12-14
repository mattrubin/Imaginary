import UIKit

/// Configuration for all operations.
public struct Configuration {

  /// Track how many bytes have been used for downloading
  public static var trackBytesDownloaded = [URL: Int]()

  /// Track if any error occured
  public static var trackError: ((URL, Error) -> Void)?
}
