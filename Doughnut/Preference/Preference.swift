//
//  Preference.swift
//  Doughnut
//
//  Created by Chris Dyer on 27/09/2017.
//  Copyright © 2017 Chris Dyer. All rights reserved.
//

import Cocoa

protocol InitializingFromKey {
  static var defaultValue: Self { get }
  init?(key: Preference.Key)
}

class Preference {
  
  struct Key: RawRepresentable {
    typealias RawValue = String
    var rawValue: String
    
    init(_ string: String) { self.rawValue = string }
    init?(rawValue: RawValue) { self.rawValue = rawValue }
    
    // Library
    static let libraryPath = Key("libraryPath")
    static let reloadFrequency = Key("reloadFrequency")
    
    // Playback
    static let skipForwardDuration = Key("skipForwardDuration")
    static let skipBackDuration = Key("skipBackDuration")
  }
  
  static let kLibraryPath = "LibraryPath"
  static let kVolume = "Volume"
  
  static let defaultPreference:[String: Any] = [
    Key.libraryPath.rawValue: Preference.userMusicPath().appendingPathComponent("Doughnut"),
    Key.reloadFrequency.rawValue: 60,
    
    Key.skipBackDuration.rawValue: 30,
    Key.skipForwardDuration.rawValue: 30
  ]
  
  static private let ud = UserDefaults.standard
  
  static func object(for key: Key) -> Any? {
    return ud.object(forKey: key.rawValue)
  }
  
  static func array(for key: Key) -> [Any]? {
    return ud.array(forKey: key.rawValue)
  }
  
  static func url(for key: Key) -> URL? {
    return ud.url(forKey: key.rawValue)
  }
  
  static func dictionary(for key: Key) -> [String : Any]? {
    return ud.dictionary(forKey: key.rawValue)
  }
  
  static func string(for key: Key) -> String? {
    return ud.string(forKey: key.rawValue)
  }
  
  static func stringArray(for key: Key) -> [String]? {
    return ud.stringArray(forKey: key.rawValue)
  }
  
  static func data(for key: Key) -> Data? {
    return ud.data(forKey: key.rawValue)
  }
  
  static func bool(for key: Key) -> Bool {
    return ud.bool(forKey: key.rawValue)
  }
  
  static func integer(for key: Key) -> Int {
    return ud.integer(forKey: key.rawValue)
  }
  
  static func float(for key: Key) -> Float {
    return ud.float(forKey: key.rawValue)
  }
  
  static func double(for key: Key) -> Double {
    return ud.double(forKey: key.rawValue)
  }
  
  static func value(for key: Key) -> Any? {
    return ud.value(forKey: key.rawValue)
  }
  
  static func set(_ value: Bool, for key: Key) {
    ud.set(value, forKey: key.rawValue)
  }
  
  static func set(_ value: Int, for key: Key) {
    ud.set(value, forKey: key.rawValue)
  }
  
  static func set(_ value: String, for key: Key) {
    ud.set(value, forKey: key.rawValue)
  }
  
  static func set(_ value: Float, for key: Key) {
    ud.set(value, forKey: key.rawValue)
  }
  
  static func set(_ value: Double, for key: Key) {
    ud.set(value, forKey: key.rawValue)
  }
  
  static func set(_ value: Any, for key: Key) {
    ud.set(value, forKey: key.rawValue)
  }
  
  static func set(_ value: URL, for key: Key) {
    ud.set(value, forKey: key.rawValue)
  }
  
  static func testEnv() -> Bool {
    return ProcessInfo.processInfo.environment["TEST"] != nil
  }
  
  static func libraryPath() -> URL? {
    if testEnv() {
      let url = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("Doughtnut_test")
      createLibraryIfNotExists(url)
      return url
    } else {
      #if DEBUG
        let url = Preference.userMusicPath().appendingPathComponent("Doughnut_dev")
        createLibraryIfNotExists(url)
        return url
      #else
        if let url = Preference.url(for: Key.libraryPath) {
          if let defaultUrl = defaultPreference[Key.libraryPath.rawValue] as? URL {
            if url == defaultUrl {
              createLibraryIfNotExists(url)
            }
          }
          return url
        } else {
          return nil
        }
      #endif
    }
  }
  
  static func createLibraryIfNotExists(_ url: URL) {
    var isDir = ObjCBool(true)
    if FileManager.default.fileExists(atPath: url.path, isDirectory: &isDir) == false {
      do {
        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
      } catch {
        print("Failed to create directory \(error)")
      }
    }
  }
  
  private static func userMusicPath() -> URL {
    if let path = FileManager.default.urls(for: .musicDirectory, in: .userDomainMask).first {
      return path
    } else {
      return URL(string: NSHomeDirectory())!
    }
  }
}
