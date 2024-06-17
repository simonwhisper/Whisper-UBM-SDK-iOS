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

//TODO: assure onResume callback works along with the on in notifServ
class ViewModel: ObservableObject{
    @Published var permission = false
    @Published var permissionDenied = false
    @Published var listening = false
    @Published var messages: [String] = []
    @Published var hash = "b40c8619283d79e73163abef4daeb9e138bba1a7dd2c552c32be48acc71cd5be"
    @Published var prefix = "b_00008_"
    @Published var whisper: WhisperUBM?
    
    var micTimeouter: DispatchSourceTimer = DispatchSource.makeTimerSource(queue: DispatchQueue.main)
    
    init(){
        getPermissionStatus()
    }
    
    func whisperInit(){
        do{
            self.whisper = try WhisperUBM(prefix: self.prefix, hash: self.hash)
            self.whisper?.setMainCallBack(callback: self.ubmRecived)
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
