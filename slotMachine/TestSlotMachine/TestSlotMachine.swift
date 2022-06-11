//
//  TestSlotMachine.swift
//  TestSlotMachine
//
//  Created by emil kurbanov on 20.04.2022.
//

import XCTest
import Combine
@testable import slotMachine
class TestSlotMachine: XCTestCase {
    
    var cansellable: Set<AnyCancellable> = []
    var gameModel = GamesModel()
   var timers = GamesModel()
    
    override func setUp() {
       super.setUp()
    }

    override func tearDown()  {
    }

    
    func testArrayEmoji() throws {
        let array = gameModel.arrayEmoji
        var resultArray: [String] = []
        
        array.publisher
            .collect()
            .sink {
                resultArray = $0
            }
            .store(in: &cansellable)
        XCTAssertEqual(resultArray, array)
    }
    
    func testFlatMap() {
        let strSubject1 = PassthroughSubject<String, Never>()
        let strSubject2 = PassthroughSubject<String, Never>()
        let strSubject3 = PassthroughSubject<String, Never>()
        let strSubject4 = PassthroughSubject<String, Never>()
        let strSubject5 = PassthroughSubject<String, Never>()
        let strSubject6 = PassthroughSubject<String, Never>()
        
        let publisher = PassthroughSubject<PassthroughSubject<String, Never>, Never>()
        
        let array = gameModel.arrayEmoji
        var resultArray: [String] = []
        
        publisher
            .flatMap(maxPublishers: .max(4)) { $0 }
            .sink {
                resultArray.append($0)
            }
            .store(in: &cansellable)
        
        
        publisher.send(strSubject1)
        strSubject1.send("🤪")
        
        publisher.send(strSubject2)
        strSubject2.send("😎")
        
        publisher.send(strSubject3)
        strSubject3.send("😜")
        
        publisher.send(strSubject4)
        strSubject4.send("🥶")
        
        publisher.send(strSubject5)
        strSubject1.send("😷")
        
        publisher.send(strSubject6)
        strSubject4.send("🤯")
        
        strSubject6.send("Проверка")
        publisher.send(completion: .finished)
        
        XCTAssertEqual(resultArray, array)
        
    }

    
    func testTimer() {
        let now = Date.timeIntervalSinceReferenceDate
        let expectation = self.expectation(description: "Timer")
        let expected = [0.5, 1.0, 1.5, 2.0, 2.5, 3.0]
        var result: [TimeInterval] = []
        
        let publisher = Timer.publish(every: 0.5, on: .main, in:.common)
            .autoconnect()
            .prefix(6)
        
        publisher
            .sink { _ in
                expectation.fulfill()
            } receiveValue: { [weak self] in
                guard let self = self else { return }
                result.append(self.normalize($0.timeIntervalSinceReferenceDate - now))
            }
            .store(in: &cansellable)
        wait(for: [expectation], timeout: 9)
        
        XCTAssertEqual(expected, result)
    }
    
    
    private func normalize(_ interval: TimeInterval) -> TimeInterval {
        Double(round(interval * 10) / 10)
    }
    
    
    
    

}
