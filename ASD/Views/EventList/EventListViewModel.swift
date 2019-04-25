//
//  EventListViewModel.swift
//  ASD
//
//  Created by Guillem Budia Tirado on 17/03/2019.
//  Copyright © 2019 Guillem Budia Tirado. All rights reserved.
//

import RxSwift
import Foundation
import RealmSwift
import SwiftMessages

class EventListViewModel: NSObject {

    let eventRepo: EventRepo
    let flightControlRepo: FlightControlRepo
    
    
    let areaID: String
    let events: Results<Event>
    let flightControl: FlightControl
    
    var areaNetworkObject: Variable<NetworkObject<Area>?> = Variable(nil)
    let title: Variable<String> = Variable("Events")
    let isLoading: Variable<Bool> = Variable(false)
    let isScanning: Variable<Bool> = Variable(false)
    let requestState: Variable<NetworkRequestState> = Variable(.initial)
    let flightState: Variable<FlightState> = Variable(.initial)
    let flightStartRequest: Variable<NetworkRequestState> = Variable(.initial)
    let flightStopRequest: Variable<NetworkRequestState> = Variable(.initial)
    let scanButtonEnabled: Variable<Bool> = Variable(true)
    let buttonText: Variable<String> = Variable("Scan")

    
    let bag = DisposeBag()
    private var eventTimer = Timer()
    private var flightTimer = Timer()

    
    init(areaID: String, eventRepo: EventRepo = EventRepo.shared, flightControlRepo: FlightControlRepo = FlightControlRepo.shared) {
        self.areaID = areaID
        self.eventRepo = eventRepo
        self.events = eventRepo.getSortdEvents(for: areaID)
        self.flightControlRepo = flightControlRepo
        self.flightControl = flightControlRepo.getFlightControl()
        super.init()
        
        bindAreaNetworkObject()
        bindRequestState()
        bindFlightControl()
        bindFlightState()
    }
    
    func handleScanAction() {
        
        switch flightState.value {
        case .initial, .landed: //Going to Starting on click
            requestFlightStart()
            buttonText.value = "Stop"
            scanButtonEnabled.value = false
            
        case .starting: //Going to Scanning, button is disabled
            break
            
        case .scanning: //Going to Stopping on click
            requestFlightStop()
            stopEventTimer()
            buttonText.value = "Scan"
            scanButtonEnabled.value = false
            
        case .stopping: //Going to landed, button disabled
            break
            
        case .error:
            break
        }
    }
    
    func handleRefresh() {
        fetchEvents()
        fetchFlightControl()
    }
    
    func fetchEvents() {
        eventRepo.fetchList(withKey: areaID, toUpdate: requestState)
    }
    
    func fetchFlightControl() {
        flightControlRepo.fetch()
    }
    
    func requestFlightStart() {
        flightControlRepo.requestStart(for: areaID, networkState: flightStartRequest)
    }
    
    func requestFlightStop() {
        flightControlRepo.requestStop(networkState: flightStopRequest)
    }
    
    private func bindFlightState() {
        
        flightState.bind({ [weak self] (state) in
            
            Utils.printDebug(sender: self, message: "Flight State Changed: \(state.rawValue)")
            
            self?.displayState(state)
            
            switch state {
            
            case .initial, .landed:
                self?.stopFlightTimer()
                self?.buttonText.value = "Scan"
                self?.scanButtonEnabled.value = true
                
            case .starting:
                self?.startFlightTimer()
                self?.buttonText.value = "Stop"
                self?.scanButtonEnabled.value = false
                
            case .scanning:
                self?.startEventTimer()
                self?.buttonText.value = "Stop"
                self?.scanButtonEnabled.value = true
                
            case .stopping:
                self?.buttonText.value = "Scan"
                self?.scanButtonEnabled.value = false
                
            case .error:
                self?.buttonText.value = "Error"
                self?.scanButtonEnabled.value = false
            }
            
        }, disposedBy: bag)
        
    }
    
    private func displayState(_ state: FlightState) {
        
        var config = SwiftMessages.Config()
        
        config.duration = .seconds(seconds: 2.0)
        config.presentationStyle = .bottom
        
        SwiftMessages.show(config: config) { () -> UIView in
            let view = MessageView.viewFromNib(layout: .cardView)
            
            view.configureTheme(.success)
            view.button?.isHidden = true
            view.configureDropShadow()
            view.configureContent(title: "\(state.rawValue.uppercased()) STATE", body: "The drone is in a new state", iconImage: UIImage(named: "drone") ?? UIImage())
            
            return view
        }
    }
    
    private func bindAreaNetworkObject() {
        
        areaNetworkObject.observe(onObjectUpdate: { [weak self] (area) in
            
            self?.title.value = "Events in \(area.getTitle())"
            
        }, onNetworkStatusUpdate: { (areaRequestState) in
            
        }, withDisposeBag: bag)
        
    }
    
    private func bindFlightControl() {
        
        Observable.from(object: flightControl).bind { [weak self] (flightControl) in
            
            if self == nil { return }
            
            if flightControl.getState() != self!.flightState.value {
                self!.flightState.value = flightControl.getState()
            }
            
        }.disposed(by: bag)
        
    }
    
    private func bindRequestState() {
        
        requestState.bind({ [weak self] (state) in
            
            self?.isLoading.value = (state == .loading)
            
        }, disposedBy: bag)
    }
    
    private func startEventTimer() {
        eventTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { [weak self] (_) in
            self?.fetchEvents()
        })
    }
    
    private func stopEventTimer() {
        eventTimer.invalidate()
    }
    
    private func startFlightTimer() {
        flightTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { [weak self] (_) in
            self?.fetchFlightControl()
        })
    }
    
    private func stopFlightTimer() {
        flightTimer.invalidate()
    }
}
