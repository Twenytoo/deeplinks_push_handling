//
//  WeakRefContainer.swift
//  DeeplinksAndPushNotifications
//
//  Created by Artem Lushchan on 24.08.2023.
//

@dynamicMemberLookup
public final class WeakRefContainer<T: AnyObject> {
  
  public weak var object: T!
  
  public init(_ object: T) {
    self.object = object
  }
  
  public subscript<Value>(dynamicMember keyPath: ReferenceWritableKeyPath<T, Value>) -> Value {
    get {
      object[keyPath: keyPath]
    }
    set {
      object[keyPath: keyPath] = newValue
    }
  }
  
}
