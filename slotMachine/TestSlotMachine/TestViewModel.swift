//
//  TestViewModel.swift
//  TestSlotMachine
//
//  Created by emil kurbanov on 20.04.2022.
//

import XCTest
import Combine
@testable import slotMachine
class TestViewModel: XCTestCase {

    var cancellables: Set<AnyCancellable> = []
    var viewModel: GamesModel!
    let array = GamesModel()
    override func setUp() {
        super.setUp()
        viewModel = GamesModel()
    }

    override func tearDown() {
        cancellables = []
        viewModel = nil
        super.tearDown()
    }

    func testViewModelTextx() {

        var result = ""
      //проверка на ошибку:
      //var textExample = "🥶"
        let textExample = "🤡"
        viewModel.$textSlot3
            .sink {
                result = $0
            }
            .store(in: &cancellables)
        
        XCTAssert(result == textExample)
    }



}
