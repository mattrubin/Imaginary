// This file contains a collection of type aliases to make
// the implementation more unified. Instead of referencing
// platform specific UI objects, we make type aliases to point
// to different implementations depending on the platform.

  import UIKit
  public typealias View = UIView
  public typealias Image = UIImage
  public typealias ImageView = UIImageView
  public typealias Button = UIButton

public typealias Completion = (Result) -> Void
