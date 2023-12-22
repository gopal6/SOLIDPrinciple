import XCTest
@testable import SOLIDPrinciple

final class CommentsViewModelTest: XCTestCase {
    

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    func testComments_Success() {
        
    }
    
    func testComments_Failure() {
        let mock =  MockCommentViewService(fileName:"comments")
        let sut: ContentViewModel = ContentViewModel(commentService: mock)
        let expectation = XCTestExpectation(description: "fetch Comments")
        sut.getComments()
        wait(for: [expectation], timeout: 5.0)
        XCTAssertTrue(sut.comments.count > 0)
    }
}
