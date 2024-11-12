//
//  ActivityManagerTests.swift
//  EducationTests
//
//  Created by Arthur Sobrosa on 08/10/24.
//

@testable import Education
import XCTest

final class MockTimer: TimerProtocol {
    var timerBlock: ((Timer) -> Void)?
    var isInvalidated: Bool = false

    func scheduledTimer(withTimeInterval _: TimeInterval, repeats _: Bool, block: @escaping (Timer) -> Void) {
        timerBlock = block
    }

    func invalidate() {
        isInvalidated = true
    }

    func fire() {
        timerBlock?(Timer())
    }
}

// swiftlint:disable type_body_length
class TimerTests: XCTestCase {
    var sut: ActivityManager!
    var mockTimer: MockTimer!

    override func setUp() {
        super.setUp()
        sut = ActivityManager(notificationService: nil)
        mockTimer = MockTimer()
    }

    override func tearDown() {
        sut = nil
        mockTimer = nil
        super.tearDown()
    }

    func testStartTimer_updatesTimerSecondsAndProgress() {
        // Arrange
        let fakeStartDate = Date(timeIntervalSince1970: 0)
        var currentDate = fakeStartDate
        let mockCurrentDate = { currentDate }

        sut.timerCase = .timer
        sut.totalSeconds = 60
        sut.timerSeconds = sut.totalSeconds

        // Act
        sut.startTimer(timer: mockTimer, currentDate: mockCurrentDate)

        currentDate = fakeStartDate.addingTimeInterval(30)
        mockTimer.fire()

        // Assert
        XCTAssertEqual(sut.timerSeconds, 30)
        XCTAssertEqual(sut.progress, 0.5)
    }

    func testStartStopwatch_incrementsOnce() {
        // Arrange
        sut.timerSeconds = 0
        sut.progress = 1

        // Act
        sut.startStopwatch(timer: mockTimer)

        mockTimer.fire()

        // Assert
        XCTAssertEqual(sut.timerSeconds, 1)
        XCTAssertEqual(sut.progress, 0)
    }

    func testStartStopwatch_incrementsMultipleTimes() {
        // Arrange
        sut.timerSeconds = 0
        sut.progress = 1

        // Act
        sut.startStopwatch(timer: mockTimer)

        mockTimer.fire()
        mockTimer.fire()
        mockTimer.fire()

        // Assert
        XCTAssertEqual(sut.timerSeconds, 3)
        XCTAssertEqual(sut.progress, 0)
    }

    func testStopTimer() {
        // Arrange
        sut.timer = mockTimer
        sut.startTime = Date(timeIntervalSince1970: 0)
        sut.timerCase = .timer

        // Act
        sut.stopTimer { Date(timeIntervalSince1970: 10) }

        // Assert
        XCTAssertEqual(sut.pausedTime, 10)
    }

    func testResetTimer() {
        // Arrange
        sut.isPaused = false
        sut.timerFinished = true
        sut.isExtending = true
        sut.isProgressingActivityBar = true
        sut.extendedTime = 10
        sut.originalTime = 20
        sut.progress = 1.0
        sut.totalSeconds = 20
        sut.timerSeconds = 10
        sut.pausedTime = 5
        let fakeStartDate = Date(timeIntervalSince1970: 0)
        sut.startTime = fakeStartDate
        sut.isAtWorkTime = false
        sut.workTime = 20
        sut.restTime = 5
        sut.numberOfLoops = 2
        sut.currentLoop = 1

        // Act
        sut.resetTimer()

        // Assert
        XCTAssertEqual(sut.isPaused, true)
        XCTAssertEqual(sut.timerFinished, false)
        XCTAssertEqual(sut.isExtending, false)
        XCTAssertEqual(sut.isProgressingActivityBar, false)
        XCTAssertEqual(sut.extendedTime, 0)
        XCTAssertEqual(sut.originalTime, 0)
        XCTAssertEqual(sut.progress, 0)
        XCTAssertEqual(sut.totalSeconds, 0)
        XCTAssertEqual(sut.timerSeconds, 0)
        XCTAssertEqual(sut.pausedTime, 0)
        XCTAssertEqual(sut.startTime, nil)
        XCTAssertEqual(sut.isAtWorkTime, true)
        XCTAssertEqual(sut.workTime, 0)
        XCTAssertEqual(sut.restTime, 0)
        XCTAssertEqual(sut.numberOfLoops, 0)
        XCTAssertEqual(sut.currentLoop, 0)
    }

    func testHandleTimerEnd_notExtending() {
        // Arrange
        sut.timerCase = .timer
        sut.timerFinished = false
        sut.isExtending = false

        // Act
        sut.handleTimerEnd()

        // Assert
        XCTAssertEqual(sut.timerFinished, true)
    }

    func testHandleTimerEnd_extending() {
        // Arrange
        sut.timerCase = .timer
        sut.timerFinished = false
        sut.isExtending = true

        // Act
        sut.handleTimerEnd()

        // Assert
        XCTAssertEqual(sut.timerFinished, true)
        XCTAssertEqual(sut.isExtending, false)
    }

    func testIsTimerTrackerShowing() {
        // Arrange
        sut.timerCase = .timer
        // Act
        var isTimerTrackerShowing = sut.isTimerTrackerShowing()
        // Assert
        XCTAssertEqual(isTimerTrackerShowing, true)

        // Arrange
        sut.timerCase = .pomodoro(workTime: 120, restTime: 60, numberOfLoops: 2)
        // Act
        isTimerTrackerShowing = sut.isTimerTrackerShowing()
        // Assert
        XCTAssertEqual(isTimerTrackerShowing, true)

        // Arrange
        sut.timerCase = .stopwatch
        // Act
        isTimerTrackerShowing = sut.isTimerTrackerShowing()
        // Assert
        XCTAssertEqual(isTimerTrackerShowing, false)
    }

    func testIsClockwise() {
        // Arrange
        sut.timerCase = .stopwatch
        // Act
        var isClockwise = sut.isClockwise()
        // Assert
        XCTAssertEqual(isClockwise, true)

        // Arrange
        sut.timerCase = .timer
        // Act
        isClockwise = sut.isClockwise()
        // Assert
        XCTAssertEqual(isClockwise, true)

        // Arrange
        sut.timerCase = .pomodoro(workTime: 120, restTime: 60, numberOfLoops: 2)
        sut.isProgressingActivityBar = true
        // Act
        isClockwise = sut.isClockwise()
        // Assert
        XCTAssertEqual(isClockwise, false)

        // Arrange
        sut.isProgressingActivityBar = false
        sut.isAtWorkTime = false
        // Act
        isClockwise = sut.isClockwise()
        // Assert
        XCTAssertEqual(isClockwise, sut.isAtWorkTime)
    }

    func testGetAngles() {
        // Arrange
        sut.timerCase = .stopwatch
        // Act
        var angles = sut.getAngles()
        // Assert
        XCTAssertEqual(angles.startAngle, -(CGFloat.pi / 2))
        XCTAssertEqual(angles.endAngle, -(CGFloat.pi / 2) + CGFloat.pi * 2)

        // Arrange
        sut.timerCase = .timer
        // Act
        angles = sut.getAngles()
        // Assert
        XCTAssertEqual(angles.startAngle, -(CGFloat.pi / 2))
        XCTAssertEqual(angles.endAngle, -(CGFloat.pi / 2) + CGFloat.pi * 2)

        // Arrange
        sut.timerCase = .pomodoro(workTime: 120, restTime: 60, numberOfLoops: 2)
        sut.isAtWorkTime = true
        // Act
        angles = sut.getAngles()
        // Assert
        XCTAssertEqual(angles.startAngle, -(CGFloat.pi / 2))
        XCTAssertEqual(angles.endAngle, -(CGFloat.pi / 2) + CGFloat.pi * 2)

        // Arrange
        sut.isAtWorkTime = false
        // Act
        angles = sut.getAngles()
        // Assert
        XCTAssertEqual(angles.startAngle, -(CGFloat.pi / 2) + CGFloat.pi * 2)
        XCTAssertEqual(angles.endAngle, -(CGFloat.pi / 2))
    }

    func testGetLayersConfig() {
        // Arrange
        sut.progress = 0.5
        sut.timerCase = .timer
        let isTimerTrackerShowing = sut.isTimerTrackerShowing()
        let isClockwise = sut.isClockwise()
        let angles = sut.getAngles()

        // Act
        let layersConfig = sut.getLayersConfig()

        // Assert
        XCTAssertEqual(layersConfig.strokeEnd, sut.progress)
        XCTAssertEqual(layersConfig.isTimerTrackerShowing, isTimerTrackerShowing)
        XCTAssertEqual(layersConfig.isClockwise, isClockwise)
        XCTAssertEqual(layersConfig.startAngle, angles.startAngle)
        XCTAssertEqual(layersConfig.endAngle, angles.endAngle)
    }

    func testComputeExtendedTime_timer() {
        // Arrange
        sut.timerCase = .timer
        sut.extendedTime = 10
        sut.totalSeconds = 10

        // Act
        sut.computeExtendedTime()

        // Assert
        XCTAssertEqual(sut.extendedTime, 20)
    }

    func testComputeExtendedTime_pomodoro_workTime() {
        // Arrange
        sut.timerCase = .pomodoro(workTime: 0, restTime: 0, numberOfLoops: 2)
        sut.extendedTime = 10
        sut.totalSeconds = 10
        sut.isAtWorkTime = true

        // Act
        sut.computeExtendedTime()

        // Assert
        XCTAssertEqual(sut.extendedTime, 20)
    }

    func testComputeExtendedTime_pomodoro_restTime() {
        // Arrange
        sut.timerCase = .pomodoro(workTime: 0, restTime: 0, numberOfLoops: 2)
        sut.extendedTime = 10
        sut.totalSeconds = 10
        sut.isAtWorkTime = false

        // Act
        sut.computeExtendedTime()

        // Assert
        XCTAssertEqual(sut.extendedTime, 10)
    }

    func testResetToOriginalConfig_timer() {
        // Arrange
        sut.timerCase = .timer
        sut.totalSeconds = 20
        sut.originalTime = 30

        // Act
        sut.resetToOriginalConfig()

        // Assert
        XCTAssertEqual(sut.totalSeconds, 30)
    }

    func testResetToOriginalConfig_pomodoro_workTime() {
        // Arrange
        sut.timerCase = .pomodoro(workTime: 20, restTime: 10, numberOfLoops: 2)
        sut.numberOfLoops = 2
        sut.workTime = 20
        sut.restTime = 10
        sut.originalTime = 30
        sut.isAtWorkTime = true

        // Act
        sut.resetToOriginalConfig()

        // Assert
        XCTAssertEqual(sut.workTime, 30)
        XCTAssertEqual(sut.restTime, 10)
        XCTAssertEqual(sut.timerCase, .pomodoro(workTime: 30, restTime: 10, numberOfLoops: 2))
    }

    func testResetToOriginalConfig_pomodoro_restTime() {
        // Arrange
        sut.timerCase = .pomodoro(workTime: 20, restTime: 10, numberOfLoops: 2)
        sut.numberOfLoops = 2
        sut.workTime = 20
        sut.restTime = 10
        sut.originalTime = 30
        sut.isAtWorkTime = false

        // Act
        sut.resetToOriginalConfig()

        // Assert
        XCTAssertEqual(sut.workTime, 20)
        XCTAssertEqual(sut.restTime, 30)
        XCTAssertEqual(sut.timerCase, .pomodoro(workTime: 20, restTime: 30, numberOfLoops: 2))
    }

    func testIsLastPomodoro() {
        // Arrange
        sut.timerCase = .pomodoro(workTime: 0, restTime: 0, numberOfLoops: 0)
        sut.isAtWorkTime = true
        sut.numberOfLoops = 2
        sut.currentLoop = 1

        // Act
        let isLastPomodoro = sut.isLastPomodoro()

        // Assert
        XCTAssertEqual(isLastPomodoro, true)
    }

    func testContinuePomodoro_lastLoop() {
        // Arrange
        sut.timerFinished = true
        sut.timerCase = .pomodoro(workTime: 0, restTime: 0, numberOfLoops: 0)
        sut.isAtWorkTime = true
        sut.numberOfLoops = 2
        sut.currentLoop = 1

        // Act
        let isLastPomodoro = sut.isLastPomodoro()

        // Assert
        XCTAssertEqual(isLastPomodoro, true)
        XCTAssertEqual(sut.timerFinished, true)
    }

    func testContinuePomodoro_notLastLoop_workTime() {
        // Arrange
        sut.timerFinished = true
        sut.timerCase = .pomodoro(workTime: 0, restTime: 0, numberOfLoops: 0)
        sut.workTime = 60
        sut.restTime = 30
        sut.totalSeconds = sut.workTime
        sut.timerSeconds = 0
        sut.isAtWorkTime = true
        sut.numberOfLoops = 2
        sut.currentLoop = 0
        let fakeStartDate = Date(timeIntervalSince1970: 0)
        sut.startTime = fakeStartDate
        sut.pausedTime = 10
        sut.progress = 0.68

        // Act
        sut.continuePomodoro()

        // Assert
        XCTAssertEqual(sut.timerFinished, false)
        XCTAssertEqual(sut.currentLoop, 0)
        XCTAssertEqual(sut.isAtWorkTime, false)
        XCTAssertEqual(sut.totalSeconds, 30)
        XCTAssertEqual(sut.timerSeconds, 30)
        XCTAssertNotEqual(sut.startTime, fakeStartDate)
        XCTAssertEqual(sut.pausedTime, 0)
        XCTAssertEqual(sut.progress, 0)
        XCTAssertEqual(sut.isPaused, false)
    }

    func testContinuePomodoro_notLastLoop_restTime() {
        // Arrange
        sut.timerFinished = true
        sut.timerCase = .pomodoro(workTime: 0, restTime: 0, numberOfLoops: 0)
        sut.workTime = 60
        sut.restTime = 30
        sut.totalSeconds = sut.restTime
        sut.timerSeconds = 0
        sut.isAtWorkTime = false
        sut.numberOfLoops = 2
        sut.currentLoop = 0
        let fakeStartDate = Date(timeIntervalSince1970: 0)
        sut.startTime = fakeStartDate
        sut.pausedTime = 10
        sut.progress = 0.68

        // Act
        sut.continuePomodoro()

        // Assert
        XCTAssertEqual(sut.timerFinished, false)
        XCTAssertEqual(sut.currentLoop, 1)
        XCTAssertEqual(sut.isAtWorkTime, true)
        XCTAssertEqual(sut.totalSeconds, 60)
        XCTAssertEqual(sut.timerSeconds, 60)
        XCTAssertNotEqual(sut.startTime, fakeStartDate)
        XCTAssertEqual(sut.pausedTime, 0)
        XCTAssertEqual(sut.progress, 0)
        XCTAssertEqual(sut.isPaused, false)
    }

    func testExtendTimer() {
        // Arrange
        let extendedTime = 25
        sut.totalSeconds = 20
        sut.timerSeconds = 0
        sut.timerFinished = true
        sut.isExtending = false
        sut.progress = 0.5
        sut.pausedTime = 30
        sut.isPaused = true

        // Act
        sut.extendTimer(in: 25)

        // Assert
        XCTAssertEqual(sut.timerFinished, false)
        XCTAssertEqual(sut.isExtending, true)
        XCTAssertEqual(sut.totalSeconds, extendedTime)
        XCTAssertEqual(sut.timerSeconds, extendedTime)
        XCTAssertEqual(sut.progress, 0)
        XCTAssertEqual(sut.pausedTime, 0)
        XCTAssertEqual(sut.isPaused, false)
    }

    func testUpdatePomodoroAfterExtension_workTime() {
        // Arrange
        let extendedTime = 25
        sut.timerCase = .pomodoro(workTime: 20, restTime: 10, numberOfLoops: 3)
        sut.isAtWorkTime = true
        sut.workTime = 20
        sut.restTime = 10
        sut.numberOfLoops = 3

        // Act
        sut.updatePomodoroAfterExtension(seconds: extendedTime)

        // Assert
        XCTAssertEqual(sut.workTime, extendedTime)
        XCTAssertEqual(sut.restTime, sut.restTime)
        XCTAssertEqual(sut.timerCase, .pomodoro(workTime: extendedTime, restTime: sut.restTime, numberOfLoops: sut.numberOfLoops))
    }

    func testUpdatePomodoroAfterExtension_restTime() {
        // Arrange
        let extendedTime = 25
        sut.timerCase = .pomodoro(workTime: 20, restTime: 10, numberOfLoops: 3)
        sut.isAtWorkTime = false
        sut.workTime = 20
        sut.restTime = 10
        sut.numberOfLoops = 3

        // Act
        sut.updatePomodoroAfterExtension(seconds: extendedTime)

        // Assert
        XCTAssertEqual(sut.workTime, sut.workTime)
        XCTAssertEqual(sut.restTime, extendedTime)
        XCTAssertEqual(sut.timerCase, .pomodoro(workTime: sut.workTime, restTime: extendedTime, numberOfLoops: sut.numberOfLoops))
    }
}
// swiftlint:enable type_body_length

// swiftlint:disable type_body_length
class SessionTest: XCTestCase {
    var sut: ActivityManager!
    var mockFocusSessionModel: FocusSessionModel = {
        let fakeDate = Date(timeIntervalSince1970: 0)
        let timerCase: TimerCase = .pomodoro(workTime: 60, restTime: 30, numberOfLoops: 3)
        let model = FocusSessionModel(
            date: fakeDate,
            totalSeconds: 60,
            timerSeconds: 60,
            timerCase: timerCase,
            subject: nil,
            isAtWorkTime: true,
            blocksApps: true,
            isTimeCountOn: true,
            isAlarmOn: false,
            color: UIColor.black
        )

        return model
    }()

    override func setUp() {
        super.setUp()
        sut = ActivityManager(notificationService: nil)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testHandleDismissedActivity_didTapFinish() {
        // Arrange
        sut.isPaused = false
        sut.timerFinished = true
        sut.progress = 1.0
        sut.totalSeconds = 20
        sut.timerSeconds = 10
        sut.pausedTime = 5
        let fakeStartDate = Date(timeIntervalSince1970: 0)
        sut.startTime = fakeStartDate
        sut.isAtWorkTime = false
        sut.workTime = 20
        sut.restTime = 5
        sut.numberOfLoops = 2
        sut.currentLoop = 1

        // Act
        sut.handleDismissedActivity(didTapFinish: true)

        // Assert
        XCTAssertEqual(sut.isPaused, true)
        XCTAssertEqual(sut.timerFinished, false)
        XCTAssertEqual(sut.progress, 0)
        XCTAssertEqual(sut.totalSeconds, 0)
        XCTAssertEqual(sut.timerSeconds, 0)
        XCTAssertEqual(sut.pausedTime, 0)
        XCTAssertEqual(sut.startTime, nil)
        XCTAssertEqual(sut.isAtWorkTime, true)
        XCTAssertEqual(sut.workTime, 0)
        XCTAssertEqual(sut.restTime, 0)
        XCTAssertEqual(sut.numberOfLoops, 0)
        XCTAssertEqual(sut.currentLoop, 0)
    }

    func testHandleDismissedActivity_didNotTapFinish() {
        // Arrange
        sut.isShowingActivityBar = false

        // Act
        sut.handleDismissedActivity(didTapFinish: false)

        // Assert
        XCTAssertEqual(sut.isShowingActivityBar, true)
    }

    func testComputeTimerTotalTime_isExtending() {
        // Arrange
        sut.timerCase = .timer
        sut.isExtending = true
        sut.totalSeconds = 60
        sut.timerSeconds = 30
        sut.originalTime = 120
        sut.extendedTime = 10
        sut.totalTime = 0

        // Act
        sut.computeTimerTotalTime()

        // Assert
        XCTAssertEqual(sut.extendedTime, 40)
        XCTAssertEqual(sut.totalTime, 160)
    }

    func testComputeTimerTotalTime_isNotExtending() {
        // Arrange
        sut.timerCase = .timer
        sut.isExtending = false
        sut.totalSeconds = 60
        sut.timerSeconds = 30
        sut.extendedTime = 10
        sut.totalTime = 0

        // Act
        sut.computeTimerTotalTime()

        // Assert
        XCTAssertEqual(sut.extendedTime, 10)
        XCTAssertEqual(sut.totalTime, 40)
    }

    func testComputePomodoroTotalTime_workTime_isExtending() {
        // Arrange
        sut.timerCase = .pomodoro(workTime: 120, restTime: 60, numberOfLoops: 2)
        sut.isExtending = true
        sut.isAtWorkTime = true
        sut.extendedTime = 5
        sut.totalTime = 0
        sut.workTime = 30
        sut.originalTime = 120
        sut.timerSeconds = 10
        sut.currentLoop = 0

        // Act
        sut.computePomodoroTotalTime()

        // Assert
        XCTAssertEqual(sut.extendedTime, 25)
        XCTAssertEqual(sut.totalTime, 145)
    }

    func testComputePomodoroTotalTime_workTime_isNotExtending() {
        // Arrange
        sut.timerCase = .pomodoro(workTime: 120, restTime: 60, numberOfLoops: 2)
        sut.isExtending = false
        sut.isAtWorkTime = true
        sut.extendedTime = 5
        sut.totalTime = 0
        sut.workTime = 120
        sut.timerSeconds = 10
        sut.currentLoop = 0

        // Act
        sut.computePomodoroTotalTime()

        // Assert
        XCTAssertEqual(sut.extendedTime, 5)
        XCTAssertEqual(sut.totalTime, 115)
    }

    func testComputePomodoroTotalTime_restTime() {
        // Arrange
        sut.timerCase = .pomodoro(workTime: 120, restTime: 60, numberOfLoops: 2)
        sut.isExtending = true
        sut.isAtWorkTime = false
        sut.extendedTime = 25
        sut.totalTime = 0
        sut.workTime = 90
        sut.timerSeconds = 10
        sut.currentLoop = 0

        // Act
        sut.computePomodoroTotalTime()

        // Assert
        XCTAssertEqual(sut.extendedTime, 25)
        XCTAssertEqual(sut.totalTime, 115)

        // Arrange
        sut.isExtending = false
        
        // Act
        sut.computePomodoroTotalTime()
        XCTAssertEqual(sut.extendedTime, 25)
        XCTAssertEqual(sut.totalTime, 115)
    }

    func testFinishSession() {
        // Arrange
        sut.isShowingActivityBar = true

        // Act
        sut.finishSession()

        // Assert
        XCTAssertEqual(sut.isShowingActivityBar, false)
    }

    func testUpdateFocusSession() {
        // Arrange
        sut.totalSeconds = 30
        sut.timerSeconds = 15
        sut.timerCase = .timer
        sut.subject = nil
        sut.isAtWorkTime = false
        sut.currentLoop = 2
        sut.blocksApps = false
        sut.isTimeCountOn = false
        sut.isAlarmOn = true
        sut.color = UIColor.red
        sut.workTime = 30
        sut.restTime = 15
        sut.numberOfLoops = 5

        // Act
        sut.updateFocusSession(with: mockFocusSessionModel)

        // Assert
        XCTAssertEqual(sut.totalSeconds, 60)
        XCTAssertEqual(sut.timerSeconds, 60)
        XCTAssertEqual(sut.timerCase, .pomodoro(workTime: 60, restTime: 30, numberOfLoops: 3))
        XCTAssertEqual(sut.subject, nil)
        XCTAssertEqual(sut.isAtWorkTime, true)
        XCTAssertEqual(sut.currentLoop, 0)
        XCTAssertEqual(sut.blocksApps, true)
        XCTAssertEqual(sut.isTimeCountOn, true)
        XCTAssertEqual(sut.isAlarmOn, false)
        XCTAssertEqual(sut.color, UIColor.black)
        XCTAssertEqual(sut.workTime, 60)
        XCTAssertEqual(sut.restTime, 30)
        XCTAssertEqual(sut.numberOfLoops, 3)
    }

    func testRestartActivity() {
        // Arrange
        sut.timerFinished = true
        let fakeDate = Date(timeIntervalSince1970: 20)
        sut.date = fakeDate
        sut.totalSeconds = 300
        sut.timerSeconds = 50
        sut.timerCase = .timer
        sut.subject = nil
        sut.isAtWorkTime = false
        sut.blocksApps = false
        sut.isTimeCountOn = false
        sut.isAlarmOn = true
        sut.currentLoop = 4
        sut.color = UIColor.blue
        sut.workTime = 300
        sut.restTime = 150
        sut.numberOfLoops = 6
        sut.progress = 0.68
        sut.pausedTime = 10

        // Act
        sut.restartActivity()

        // Assert
        XCTAssertEqual(sut.timerFinished, false)
        XCTAssertEqual(sut.date, fakeDate)
        XCTAssertEqual(sut.totalSeconds, 300)
        XCTAssertEqual(sut.timerSeconds, 300)
        XCTAssertEqual(sut.timerCase, .timer)
        XCTAssertEqual(sut.subject, nil)
        XCTAssertEqual(sut.isAtWorkTime, false)
        XCTAssertEqual(sut.blocksApps, false)
        XCTAssertEqual(sut.isTimeCountOn, false)
        XCTAssertEqual(sut.isAlarmOn, true)
        XCTAssertEqual(sut.currentLoop, 4)
        XCTAssertEqual(sut.color, UIColor.blue)
        XCTAssertEqual(sut.workTime, 300)
        XCTAssertEqual(sut.restTime, 150)
        XCTAssertEqual(sut.numberOfLoops, 6)
        XCTAssertEqual(sut.progress, 0)
        XCTAssertEqual(sut.pausedTime, 0)
    }

    func testGetLoopStartTime_workTime_isExtending() {
        // Arrange
        sut.timerCase = .pomodoro(workTime: 30, restTime: 60, numberOfLoops: 3)
        sut.isExtending = true
        sut.isAtWorkTime = true
        sut.currentLoop = 2
        sut.workTime = 30
        sut.restTime = 60
        sut.originalTime = 120

        // Act
        let loopStartTime = sut.getLoopStartTime()

        // Assert
        XCTAssertEqual(loopStartTime, 360)
    }

    func testGetLoopStartTime_restTime_isExtending() {
        // Arrange
        sut.timerCase = .pomodoro(workTime: 120, restTime: 30, numberOfLoops: 3)
        sut.isExtending = true
        sut.isAtWorkTime = false
        sut.currentLoop = 2
        sut.workTime = 120
        sut.restTime = 30
        sut.originalTime = 60

        // Act
        let loopStartTime = sut.getLoopStartTime()

        // Assert
        XCTAssertEqual(loopStartTime, 360)
    }

    func testGetLoopStartTime_isNotExtending() {
        // Arrange
        sut.timerCase = .pomodoro(workTime: 120, restTime: 60, numberOfLoops: 3)
        sut.isExtending = false
        sut.currentLoop = 2
        sut.workTime = 120
        sut.restTime = 60

        // Act
        let loopStartTime = sut.getLoopStartTime()

        // Assert
        XCTAssertEqual(loopStartTime, 360)
    }

    func testGetInLoopTime_workTime_isExtending() {
        // Act
        sut.timerCase = .pomodoro(workTime: 30, restTime: 60, numberOfLoops: 3)
        sut.isExtending = true
        sut.isAtWorkTime = true
        sut.workTime = 30
        sut.restTime = 60
        sut.originalTime = 120
        let lastTimerSeconds = 10

        // Act
        let inLoopTime = sut.getInLoopTime(lastTimerSeconds: lastTimerSeconds)

        // Assert
        XCTAssertEqual(inLoopTime, 140)
    }

    func testGetInLoopTime_restTime_isExtending() {
        // Act
        sut.timerCase = .pomodoro(workTime: 120, restTime: 30, numberOfLoops: 3)
        sut.isExtending = true
        sut.isAtWorkTime = false
        sut.workTime = 120
        sut.restTime = 30
        sut.originalTime = 60
        let lastTimerSeconds = 10

        // Act
        let inLooptime = sut.getInLoopTime(lastTimerSeconds: lastTimerSeconds)

        // Assert
        XCTAssertEqual(inLooptime, 200)
    }

    func testGetInLoopTime_workTime_isNotExtending() {
        // Arrange
        sut.timerCase = .pomodoro(workTime: 60, restTime: 30, numberOfLoops: 3)
        sut.isExtending = false
        sut.isAtWorkTime = true
        sut.workTime = 60
        sut.restTime = 30
        let lastTimerSeconds = 15

        // Act
        let inLoopTime = sut.getInLoopTime(lastTimerSeconds: lastTimerSeconds)

        // Assert
        XCTAssertEqual(inLoopTime, 45)
    }

    func testGetInLoopTime_restTime_isNotExtending() {
        // Arrange
        sut.timerCase = .pomodoro(workTime: 60, restTime: 30, numberOfLoops: 3)
        sut.isExtending = false
        sut.isAtWorkTime = false
        sut.workTime = 60
        sut.restTime = 30
        let lastTimerSeconds = 15

        // Act
        let inLoopTime = sut.getInLoopTime(lastTimerSeconds: lastTimerSeconds)

        // Assert
        XCTAssertEqual(inLoopTime, 75)
    }

    func testGetCurrentLoop() {
        // Arrange
        sut.timerCase = .pomodoro(workTime: 120, restTime: 60, numberOfLoops: 3)
        sut.isExtending = false
        sut.currentLoop = 0
        sut.workTime = 120
        sut.restTime = 60
        let totalPassedTime = 300

        // Act
        sut.currentLoop = sut.getCurrentLoop(totalPassedTime: totalPassedTime)

        // Assert
        XCTAssertEqual(sut.currentLoop, 1)
    }

    func testHandlePomodoro_workTime_isExtending_lesserTimeInBackground() {
        // Arrange
        sut.timerCase = .pomodoro(workTime: 30, restTime: 60, numberOfLoops: 3)
        sut.isAtWorkTime = true
        sut.isExtending = true
        sut.timerFinished = false
        sut.currentLoop = 0
        sut.originalTime = 120
        sut.workTime = 30
        sut.restTime = 60
        let lastTimerSeconds = 20
        let timeInBackground = TimeInterval(5)

        // Act
        sut.handlePomodoro(lastTimerSeconds: lastTimerSeconds, timeInBackground: timeInBackground)

        // Assert
        XCTAssertEqual(sut.isAtWorkTime, true)
        XCTAssertEqual(sut.isExtending, true)
        XCTAssertEqual(sut.timerFinished, false)
        XCTAssertEqual(sut.currentLoop, 0)
        XCTAssertEqual(sut.originalTime, 120)
        XCTAssertEqual(sut.workTime, 30)
        XCTAssertEqual(sut.restTime, 60)
        XCTAssertEqual(sut.pausedTime, TimeInterval(5))
    }

    func testHandlePomodoro_workTime_isExtending_greaterTimeInBackground_timerNotFinished() {
        // Arrange
        sut.timerCase = .pomodoro(workTime: 30, restTime: 60, numberOfLoops: 3)
        sut.isAtWorkTime = true
        sut.isExtending = true
        sut.timerFinished = false
        sut.currentLoop = 1
        sut.numberOfLoops = 3
        sut.originalTime = 120
        sut.workTime = 30
        sut.restTime = 60
        sut.totalSeconds = sut.workTime
        let lastTimerSeconds = 20
        let timeInBackground = TimeInterval(25)
        sut.extendedTime = 0

        // Act
        sut.handlePomodoro(lastTimerSeconds: lastTimerSeconds, timeInBackground: timeInBackground)

        // Assert
        XCTAssertEqual(sut.isAtWorkTime, false)
        XCTAssertEqual(sut.isExtending, false)
        XCTAssertEqual(sut.timerFinished, false)
        XCTAssertEqual(sut.currentLoop, 1)
        XCTAssertEqual(sut.workTime, 120)
        XCTAssertEqual(sut.restTime, 60)
        XCTAssertEqual(sut.totalSeconds, sut.restTime)
        XCTAssertEqual(sut.pausedTime, TimeInterval(5))
        XCTAssertEqual(sut.extendedTime, 30)
    }

    func testHandlePomodoro_workTime_isExtending_greaterTimeInBackground_timerFinished() {
        // Arrange
        sut.timerCase = .pomodoro(workTime: 30, restTime: 60, numberOfLoops: 2)
        sut.isAtWorkTime = true
        sut.isExtending = true
        sut.timerFinished = false
        sut.currentLoop = 1
        sut.numberOfLoops = 2
        sut.originalTime = 120
        sut.workTime = 30
        sut.restTime = 60
        sut.totalSeconds = sut.workTime
        let lastTimerSeconds = 20
        let timeInBackground = TimeInterval(85)
        sut.extendedTime = 20

        // Act
        sut.handlePomodoro(lastTimerSeconds: lastTimerSeconds, timeInBackground: timeInBackground)

        // Assert
        XCTAssertEqual(sut.isAtWorkTime, true)
        XCTAssertEqual(sut.isExtending, false)
        XCTAssertEqual(sut.timerFinished, true)
        XCTAssertEqual(sut.currentLoop, 2)
        XCTAssertEqual(sut.workTime, 120)
        XCTAssertEqual(sut.restTime, 60)
        XCTAssertEqual(sut.extendedTime, 50)
    }

    func testHandlePomodoro_restTime_isExtending_lesserTimeInBackground() {
        // Arrange
        sut.timerCase = .pomodoro(workTime: 120, restTime: 30, numberOfLoops: 2)
        sut.isExtending = true
        sut.isAtWorkTime = false
        sut.timerFinished = false
        sut.currentLoop = 0
        sut.originalTime = 60
        sut.workTime = 120
        sut.restTime = 30
        let lastTimerSeconds = 20
        let timeInBackground = TimeInterval(5)

        // Act
        sut.handlePomodoro(lastTimerSeconds: lastTimerSeconds, timeInBackground: timeInBackground)

        // Assert
        XCTAssertEqual(sut.isAtWorkTime, false)
        XCTAssertEqual(sut.isExtending, true)
        XCTAssertEqual(sut.timerFinished, false)
        XCTAssertEqual(sut.currentLoop, 0)
        XCTAssertEqual(sut.originalTime, 60)
        XCTAssertEqual(sut.workTime, 120)
        XCTAssertEqual(sut.restTime, 30)
        XCTAssertEqual(sut.pausedTime, TimeInterval(5))
    }

    func testHandlePomodoro_restTime_isExtending_greaterTimeInBackground_timerNotFinished() {
        // Arrange
        sut.timerCase = .pomodoro(workTime: 120, restTime: 30, numberOfLoops: 2)
        sut.isExtending = true
        sut.isAtWorkTime = false
        sut.timerFinished = false
        sut.currentLoop = 0
        sut.numberOfLoops = 2
        sut.originalTime = 60
        sut.workTime = 120
        sut.restTime = 30
        sut.totalSeconds = sut.restTime
        let lastTimerSeconds = 20
        let timeInBackground = TimeInterval(30)
        sut.extendedTime = 0

        // Act
        sut.handlePomodoro(lastTimerSeconds: lastTimerSeconds, timeInBackground: timeInBackground)

        // Assert
        XCTAssertEqual(sut.isAtWorkTime, true)
        XCTAssertEqual(sut.isExtending, false)
        XCTAssertEqual(sut.timerFinished, false)
        XCTAssertEqual(sut.currentLoop, 1)
        XCTAssertEqual(sut.workTime, 120)
        XCTAssertEqual(sut.restTime, 60)
        XCTAssertEqual(sut.totalSeconds, sut.workTime)
        XCTAssertEqual(sut.pausedTime, TimeInterval(10))
        XCTAssertEqual(sut.extendedTime, 0)
    }

    func testHandlePomodoro_restTime_isExtending_greaterTimeInBackground_timerFinished() {
        // Arrange
        sut.timerCase = .pomodoro(workTime: 120, restTime: 30, numberOfLoops: 2)
        sut.isExtending = true
        sut.isAtWorkTime = false
        sut.timerFinished = false
        sut.currentLoop = 0
        sut.numberOfLoops = 2
        sut.originalTime = 60
        sut.workTime = 120
        sut.restTime = 30
        sut.totalSeconds = sut.restTime
        let lastTimerSeconds = 20
        let timeInBackground = TimeInterval(200)
        sut.extendedTime = 10

        // Act
        sut.handlePomodoro(lastTimerSeconds: lastTimerSeconds, timeInBackground: timeInBackground)

        // Assert
        XCTAssertEqual(sut.isAtWorkTime, true)
        XCTAssertEqual(sut.isExtending, false)
        XCTAssertEqual(sut.timerFinished, true)
        XCTAssertEqual(sut.currentLoop, 2)
        XCTAssertEqual(sut.workTime, 120)
        XCTAssertEqual(sut.restTime, 60)
        XCTAssertEqual(sut.extendedTime, 10)
    }

    func testUpdateAfterBackground_timer() {
        // Arrange
        sut.timerCase = .timer
        sut.isPaused = false
        sut.updateAfterBackground = false

        // Act
        sut.updateAfterBackground(timeInBackground: TimeInterval(50), lastTimerSeconds: 10)

        // Assert
        XCTAssertEqual(sut.updateAfterBackground, true)
    }

    func testUpdateAfterBackground_stopwatch() {
        // Arrange
        sut.timerCase = .stopwatch
        sut.isPaused = false
        sut.updateAfterBackground = false
        sut.timerSeconds = 20

        // Act
        sut.updateAfterBackground(timeInBackground: TimeInterval(50), lastTimerSeconds: sut.timerSeconds)

        // Assert
        XCTAssertEqual(sut.timerSeconds, 70)
        XCTAssertEqual(sut.updateAfterBackground, false)
    }

    func testUpdateAfterBackground_pomodoro() {
        // Arrange
        sut.timerCase = .pomodoro(workTime: 60, restTime: 30, numberOfLoops: 3)
        sut.numberOfLoops = 3
        sut.currentLoop = 0
        sut.isAtWorkTime = true
        sut.workTime = 60
        sut.restTime = 30
        sut.totalSeconds = sut.workTime
        sut.timerSeconds = 10
        sut.isPaused = false
        sut.updateAfterBackground = false
        let timeInBackground = TimeInterval(20)

        // Act
        sut.updateAfterBackground(timeInBackground: timeInBackground, lastTimerSeconds: sut.timerSeconds)

        // Assert
        XCTAssertEqual(sut.currentLoop, 0)
        XCTAssertEqual(sut.isAtWorkTime, false)
        XCTAssertEqual(sut.timerFinished, false)
        XCTAssertEqual(sut.totalSeconds, 30)
        XCTAssertEqual(sut.pausedTime, TimeInterval(10))
    }
}
// swiftlint:enable type_body_length
