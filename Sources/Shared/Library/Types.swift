// This file contains a collection of type aliases to make
// the implementation more unified. Instead of referencing
// platform specific UI objects, we make type aliases to point
// to different implementations depending on the platform.

public typealias Completion = (Result) -> Void
