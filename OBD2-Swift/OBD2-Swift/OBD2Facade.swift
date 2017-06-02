//
//  OBD2Facade.swift
//  OBD2Swift
//
//  Created by Max Vitruk on 24/05/2017.
//  Copyright © 2017 Lemberg. All rights reserved.
//

import Foundation


protocol ScanDelegate {
  func didReceive()
}

open class OBD2 {
  typealias CallBack = (Bool, Error?)->()
  
  private var host : String
  private var port : Int
  
  var scanner : Scanner

  public convenience init(){
    self.init(host : "192.168.0.10", port : 35000)
  }
  
  public init(host : String, port : Int){
    self.host = host
    self.port = port
    
    self.scanner = Scanner(host: host, port: port)
  }
  
  var logger : Any?
  var cache : Any?
  
  public func connect(_ block : CallBack){
    scanner.startScan()
  }
  
  public func disconnect(){
    //
  }
  
  public func startScan(){
    
  }
  
  public func stopScan(){
    
  }
  
  public func setSensors(){
    
  }
  
  public func requestTroubleCodes(){
    scanner.request(command: DataRequest.init(from: "03"))
  }
  
  public func requestVIN(){
    scanner.request(command: DataRequest.init(from: "0902"))
  }
  
  public func request(command str: String){
    scanner.request(command: DataRequest.init(from: str))
  }
  
  public func request<T : CommandType>(command : T, block : @escaping (_ descriptor : T.Descriptor?)->()){
    let dataRequest = command.dataRequest
    
    scanner.request(command: dataRequest, response: { (response) in
      let described = T.Descriptor(describe: response)
      block(described)
      
      self.dispatchToObserver(command: command, with: response)
    })
  }
  
  private func dispatchToObserver<T : CommandType>(command : T, with response : Response){
    ObserverQueue.shared.dispatch(command: command, response: response)
  }
}


