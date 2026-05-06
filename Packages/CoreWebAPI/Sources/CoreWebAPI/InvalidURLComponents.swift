//
//  InvalidURLComponents.swift
//  CoreWebAPI
//
//  Created by Matthew L. Quiros on 5/5/26.
//

import Foundation

public struct InvalidURLComponents: LocalizedError {
  
  public let components: URLComponents
  
  public init(components: URLComponents) {
    self.components = components
  }
  
  public var errorDescription: String? {
    "Cannot make a valid URL from supplied components"
  }
  
}
