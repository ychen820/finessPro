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
    //    case pairingService = "4B5CF42E-3224-43B4-AFA2-8A0917B34856"
}
enum Characteristics: String {
    case heartRate = "7821C91E-A551-4907-A5E0-F6CB64AC0A4B"
    case stepsCount = "EE6134CF-F907-45CD-B259-2AB681CA6B32"
    //    case pairingCharacteristic = "2BCE8CF5-F03E-4EB2-BB35-77C87AC5F1A4"
}
protocol BLTManagerDelegate {
    func didGetStep(step : String)
    func didGetHeartRate (heartRate : String)
}
class BLTManager: NSObject,CBCentralManagerDelegate,CBPeripheralDelegate {
    
    var centralManager : CBCentralManager?
    var myPeripheral : CBPeripheral?
    var heartMonitorCharacteristic : CBCharacteristic?
    var stepsCharacteristic : CBCharacteristic?
    var uiDelegate : BLTManagerDelegate?
    static let shareInstance : BLTManager = {
        let instance = BLTManager()
        instance.centralManager = CBCentralManager(delegate: instance, queue: nil)
        
        
        return instance
    }()
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn{
            print("BLE ON")
            central.scanForPeripherals(withServices: nil, options: nil)
        }
        else{
            print("BLE OFF")
        }
    }
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        for(key,value) in advertisementData{
            if key == CBAdvertisementDataLocalNameKey && (value as! String)=="Yang Chen's Apple Watch"{
                print("Found Yang!",value as! String)
                myPeripheral = peripheral
                central.stopScan()
                central.connect(myPeripheral!, options: nil)
            }
        }
    }
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to\(peripheral.name!)")
        peripheral.delegate=self
        peripheral.discoverServices(nil)
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        for service in peripheral.services! {
            if service.uuid.uuidString == Services.heartMonitor.rawValue{
                print("Found heart monitor service")
                peripheral.discoverCharacteristics(nil, for: service)
            }
            if service.uuid.uuidString == Services.stepsMonitor.rawValue{
                print("Found steps monitor service")
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
    func peripheral(_ peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]) {
        print("services modified")
        centralManager?.cancelPeripheralConnection(peripheral)
        centralManager?.scanForPeripherals(withServices: nil, options: nil)
        
        

    }
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("disconnected")
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        for characteris in service.characteristics!{
            if characteris.uuid.uuidString == Characteristics.heartRate.rawValue{
                heartMonitorCharacteristic = characteris
                peripheral .setNotifyValue(true, for: characteris)
            }
            if characteris.uuid.uuidString == Characteristics.stepsCount.rawValue{
                stepsCharacteristic = characteris
                getSteps()
            }
        }
    }
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if characteristic == stepsCharacteristic! {
            if let value = characteristic.value {
                let s = String(bytes: value, encoding: .utf8)
                self.uiDelegate?.didGetStep(step: s ?? "")
                print("Steps count:", s ?? "")
            }
        }
        if characteristic == heartMonitorCharacteristic{
            if let value = characteristic.value {
                let s = String(bytes: value, encoding: .utf8)
                self.uiDelegate?.didGetHeartRate(heartRate: s ?? "")
                print("Heart Rate:", s ?? "")
                
            }
        }
    }
    func getSteps() {
        myPeripheral?.readValue(for: stepsCharacteristic!)
    }
}
