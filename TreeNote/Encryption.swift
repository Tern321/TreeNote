//
//  Encryption.swift
//  TreeNote
//
//  Created by Evgenii Loshchenko on 05.11.2020.
//

import UIKit
import CryptoKit
import CommonCrypto

class Encryption: NSObject {

//    func getKeyMaterial(password:string) {
//            let enc = new TextEncoder();
//            return window.crypto.subtle.importKey(
//                "raw",
//                enc.encode(password),
//                { name: "PBKDF2" },
//                false,
//                ["deriveBits", "deriveKey"]
//            );
//        }
    
    func test()
    {
        let password     = "password"
        //let salt       = "saltData".data(using: String.Encoding.utf8)!
        let salt         = Data(bytes: [0x73, 0x61, 0x6c, 0x74, 0x44, 0x61, 0x74, 0x61])
        let keyByteCount = 16
        let rounds       = 100000

        let derivedKey = pbkdf2SHA256(password:password, salt:salt, keyByteCount:keyByteCount, rounds:rounds)
        print("derivedKey (SHA1): \(derivedKey! as NSData)")
    }
//    func getKey(keyMaterial:String, salt: Data) {
//            return window.crypto.subtle.deriveKey(
//                {
//                    "name": "PBKDF2",
//                    salt: salt,
//                    "iterations": 100000,
//                    "hash": "SHA-256"
//                },
//                keyMaterial,
//                { "name": "AES-GCM", "length": 256 },
//                true,
//                ["encrypt", "decrypt"]
//            );
//    }
    func pbkdf2SHA256(password: String, salt: Data, keyByteCount: Int, rounds: Int) -> Data? {
        return pbkdf2(hash:CCPBKDFAlgorithm(kCCPRFHmacAlgSHA256), password:password, salt:salt, keyByteCount:keyByteCount, rounds:rounds)
    }

    func pbkdf2(hash :CCPBKDFAlgorithm, password: String, salt: Data, keyByteCount: Int, rounds: Int) -> Data? {
        let passwordData = password.data(using:String.Encoding.utf8)!
        var derivedKeyData = Data(repeating:0, count:keyByteCount)
//withUnsafeMutableBytes
//        derivedKeyData.withUnsafeMutableBytes(<#T##body: (UnsafeMutableRawBufferPointer) throws -> ResultType##(UnsafeMutableRawBufferPointer) throws -> ResultType#>)
        var pointer = {derivedKeyBytes in
            salt.withUnsafeBytes { saltBytes in

                CCKeyDerivationPBKDF(
                    CCPBKDFAlgorithm(kCCPBKDF2),
                    password, passwordData.count,
                    saltBytes, salt.count,
                    hash,
                    UInt32(rounds),
                    derivedKeyBytes, derivedKeyData.count)
            }
        }
        
        let derivationStatus = derivedKeyData.withUnsafeMutableBytes(pointer)
        if (derivationStatus != 0) {
            print("Error: \(derivationStatus)")
            return nil;
        }

        return derivedKeyData
    }
    
    
//    private func pbkdf2(hash: CCPBKDFAlgorithm, password: String, saltData: Data, keyByteCount: Int, rounds: Int) -> Data?
//    {
//        guard let passwordData = password.data(using: .utf8) else { return nil }
//        var derivedKeyData = Data(repeating: 0, count: keyByteCount)
//        let derivedCount = derivedKeyData.count
//        let derivationStatus: Int32 = derivedKeyData.withUnsafeMutableBytes { derivedKeyBytes in
//            let keyBuffer: UnsafeMutablePointer<UInt8> =
//                derivedKeyBytes.baseAddress!.assumingMemoryBound(to: UInt8.self)
//            return saltData.withUnsafeBytes { saltBytes -> Int32 in
//                let saltBuffer: UnsafePointer<UInt8> = saltBytes.baseAddress!.assumingMemoryBound(to: UInt8.self)
//                return CCKeyDerivationPBKDF(
//                    CCPBKDFAlgorithm(kCCPBKDF2),
//                    password,
//                    passwordData.count,
//                    saltBuffer,
//                    saltData.count,
//                    hash,
//                    UInt32(rounds),
//                    keyBuffer,
//                    derivedCount)
//            }
//        }
//        return derivationStatus == kCCSuccess ? derivedKeyData : nil
//    }
}
