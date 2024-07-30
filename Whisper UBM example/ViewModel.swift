//
//  ViewModel.swift
//  Whisper UBM example
//
//  Created by Whisper Developer on 10/06/2024.
//

import Foundation

import Foundation
import AVFoundation
import UIKit
import ActivityKit
import WhisperUBM_SwiftSDK

class ViewModel: ObservableObject{
    @Published var permission = false
    @Published var permissionDenied = false
    @Published var listening = false
    @Published var messages: [String] = []
    @Published var hash = ""
    @Published var prefix = ""
    @Published var whisper: WhisperUBM?
    
    var micTimeouter: DispatchSourceTimer = DispatchSource.makeTimerSource(queue: DispatchQueue.main)
    
    init(){
        getPermissionStatus()
        self.prefix = UserDefaults.standard.string(forKey: "prefix") ?? ""
        self.hash = UserDefaults.standard.string(forKey: "hash") ?? ""
    }
    
    func whisperInit(){
        do{
            self.whisper = try WhisperUBM(prefix: self.prefix, hash: self.hash)
            self.whisper?.setCallBack(callback: self.ubmRecived)
            UserDefaults.standard.set(prefix, forKey: "prefix")
            UserDefaults.standard.set(hash, forKey: "hash")
        }catch{
            print("bad hash/prefix input")
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
    }
    
    func ubmRecived(ubm: String){
        print(ubm)
        messages.append(ubm)
    }
    
    func startListening(){
        if let whisp = whisper {
            whisp.startListening()
            listening = true
        } else {
            listening = false
            permission = false
        }
    }
    
    func stopListening(){
        if let whisp = whisper {
            whisp.stopListening()
            listening = false
        } else {
            listening = false
            permission = false
        }
    }
}

//permissions
extension ViewModel{
    func requestPermission(){
        AVAudioSession.sharedInstance().requestRecordPermission({ granted in
            self.getPermissionStatus()
        })
    }
    
    @objc func getPermissionStatus(){
        switch AVAudioSession.sharedInstance().recordPermission {
            case .granted:
                DispatchQueue.main.async {
                    
                    self.permission = true
                    self.permissionDenied = false
                }
            case .denied:
                DispatchQueue.main.async {
                    self.permission = false
                    self.permissionDenied = true
                
                }
            case .undetermined:
                DispatchQueue.main.async {
                    self.permission = false
                    self.permissionDenied = false
                    
                }
            @unknown default:
                print("Unknown case")
            }
    }
}
