//
//  BLTManager.swift
//  fitnessPro
//
//  Created by Nathan Chen on 5/21/17.
//  Copyright © 2017 Nathan Chen. All rights reserved.
//

import UIKit
import CoreBluetooth
enum Services: String {
    case heartMonitor = "CE4CFF01-B85D-49AA-8E03-0D34779A6EEF"
    case stepsMonitor = "3E18B512-D819-4550-8343-F9EFFDA2F896"
    case temperatureMonitor = "4B5CF42E-3224-43B4-AFA2-8A0917B34856"
}

enum Characteristics: String {
    case heartRate = "7821C91E-A551-4907-A5E0-F6CB64AC0A4B"
    case stepsCount = "EE6134CF-F907-45CD-B259-2AB681CA6B32"
    case temperatureStat = "2BCE8CF5-F03E-4EB2-BB35-77C87AC5F1A4"
}

protocol BLTManagerDelegate {
    func didGetStep(_ step : String)
    func didGetHeartRate (_ heartRate : String)
    func didGetTemp(_ temp : String)
    
}
extension BLTManagerDelegate{
    func didGetStep(_ step : String){
        
    }
    func didGetHeartRate (_ heartRate : String){
        
    }
    func didGetTemp(_ temp : String){
        
    }

}
class BLTManager: NSObject,CBCentralManagerDelegate,CBPeripheralDelegate {
    
    var centralManager: CBCentralManager?
    var myPeripheral: CBPeripheral?
    
    var heartRateCharacteristic: CBCharacteristic?
    var stepsCountCharacteristic: CBCharacteristic?
    var temperatureStatCharacteristic: CBCharacteristic?

    var uiDelegate : BLTManagerDelegate?
    static let shareInstance : BLTManager = {
        let instance = BLTManager()
        instance.centralManager = CBCentralManager(delegate: instance, queue: nil)
        
        
        return instance
    }()
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            central.scanForPeripherals(withServices: nil, options: nil)
        }
        else {
            print("Error with BLE")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        for (key, value) in advertisementData {
            if key == "kCBAdvDataLocalName" && (value as! String) == "Yang Chen's Apple Watch" {
                print("Found Mohit!!")
                myPeripheral = peripheral
                central.stopScan()
                central.connect(myPeripheral!, options: nil)
            }
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to: ", peripheral.name ?? "")
        peripheral.delegate = self
        
        peripheral.discoverServices(nil)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        for service in peripheral.services! {
            if service.uuid.uuidString == Services.heartMonitor.rawValue {
                print("Found heart monitor service")
                peripheral.discoverCharacteristics(nil, for: service)
            }
            
            if service.uuid.uuidString == Services.stepsMonitor.rawValue {
                print("Found steps monitor service")
                peripheral.discoverCharacteristics(nil, for: service)
            }
            
            if service.uuid.uuidString == Services.temperatureMonitor.rawValue {
                print("Found temperature service")
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        for characteristic in service.characteristics! {
            if characteristic.uuid.uuidString == Characteristics.heartRate.rawValue {
                heartRateCharacteristic = characteristic
                myPeripheral?.setNotifyValue(true, for: heartRateCharacteristic!)
            }
            
            if characteristic.uuid.uuidString == Characteristics.stepsCount.rawValue {
                stepsCountCharacteristic = characteristic
                getSteps()
            }
            
            if characteristic.uuid.uuidString == Characteristics.temperatureStat.rawValue {
                temperatureStatCharacteristic = characteristic
                getTemp()
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        if characteristic == heartRateCharacteristic {
            if let value = characteristic.value {
                let s = String(bytes: value, encoding: .utf8)
                uiDelegate?.didGetHeartRate(s!)
                print("Heart Rate: ", s ?? "")
            }
        }
        if characteristic == stepsCountCharacteristic {
            if let value = characteristic.value {
                let s = String(bytes: value, encoding: .utf8)
                uiDelegate?.didGetStep(s!)
                print("Steps count: ", s ?? "", "on date and time: ", Date().description)
            }
        }
        if characteristic == temperatureStatCharacteristic {
            if let value = characteristic.value {
                let s = String(bytes: value, encoding: .utf8)
                uiDelegate?.didGetTemp(s!)
                print("Body temperature: ", s ?? "")
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        
        if error != nil {
            print(error?.localizedDescription ?? "")
        }
    }
    
    func getSteps() {
        myPeripheral?.readValue(for: stepsCountCharacteristic!)
    }

    
    func getTemp() {
        myPeripheral?.readValue(for: temperatureStatCharacteristic!)
    }
    
    
}

