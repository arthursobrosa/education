import UIKit

class TestDetailsViewController: UIViewController {
    // MARK: - Coordinator and ViewModel

    weak var coordinator: (Dismissing & ShowingTestPage)?
    let viewModel: TestDetailsViewModel

    // MARK: - UI Properties

    private lazy var testDetailsView: TestDetailsView = {
        let view = TestDetailsView()
        view.config = viewModel.getTestDetailsConfig()
        view.delegate = self
        return view
    }()

    // MARK: - Initialization

    init(viewModel: TestDetailsViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Lifecycle

    override func loadView() {
        view = testDetailsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateInterface()
    }

    // MARK: - Methods
    
    func updateInterface() {
        testDetailsView.config = viewModel.getTestDetailsConfig()
    }
}
