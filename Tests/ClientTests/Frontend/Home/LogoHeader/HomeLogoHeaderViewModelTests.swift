// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import XCTest
@testable import Client

class HomeLogoHeaderViewModelTests: XCTestCase, FeatureFlaggable {
    private var profile: MockProfile!

    override func setUp() {
        super.setUp()
        profile = MockProfile()
        featureFlags.initializeDeveloperFeatures(with: profile)
    }

    override func tearDown() {
        super.tearDown()
        profile = nil
    }

    func testDefaultHomepageViewModelProtocolValues() {
        let subject = createSubject()
        XCTAssertEqual(subject.sectionType, .logoHeader)
        XCTAssertEqual(subject.headerViewModel, LabelButtonHeaderViewModel.emptyHeader)
        XCTAssertEqual(subject.numberOfItemsInSection(), 1)
        XCTAssertTrue(subject.isEnabled)
    }

    func testConfigureOnTapAction() throws {
        let subject = createSubject()

        let cellBeforeConfig = HomeLogoHeaderCell(frame: CGRect.zero)
        XCTAssertNil(cellBeforeConfig.logoButton.touchUpAction)

        subject.onTapAction = { _ in }
        let cellAfterConfig = try XCTUnwrap(subject.configure(HomeLogoHeaderCell(frame: CGRect.zero),
                                                              at: IndexPath()) as? HomeLogoHeaderCell)
        XCTAssertNotNil(cellAfterConfig.logoButton.touchUpAction)
    }
}

extension HomeLogoHeaderViewModelTests {

    func createSubject(file: StaticString = #file, line: UInt = #line) -> HomeLogoHeaderViewModel {
        let subject = HomeLogoHeaderViewModel(profile: profile)
        trackForMemoryLeaks(subject, file: file, line: line)
        return subject
    }
}

extension LabelButtonHeaderViewModel: Equatable {
    public static func == (lhs: LabelButtonHeaderViewModel, rhs: LabelButtonHeaderViewModel) -> Bool {
        return lhs.title == rhs.title && lhs.isButtonHidden == rhs.isButtonHidden
    }
}