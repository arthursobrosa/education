import UIKit

class TestDetailsViewController: UIViewController {
    // MARK: - Coordinator and ViewModel

    weak var coordinator: (Dismissing & ShowingTestPage)?
    let viewModel: TestDetailsViewModel

    // MARK: - Properties

    private lazy var testDetailsView: TestDetailsView = {
        let view = TestDetailsView()

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

        setNavigationItems()
        updateInterface()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    // MARK: - Methods

    private func setNavigationItems() {
        navigationItem.title = viewModel.getDateFullString(from: viewModel.test)

        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont(name: Fonts.darkModeOnSemiBold, size: 14) ?? .systemFont(ofSize: 14, weight: .semibold)]
        navigationController?.navigationBar.tintColor = .systemText

        let editButton = UIButton(configuration: .plain())
        editButton.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        editButton.setPreferredSymbolConfiguration(.init(pointSize: 16), forImageIn: .normal)
        editButton.imageView?.contentMode = .scaleAspectFit
        editButton.tintColor = .systemText

        editButton.addTarget(self, action: #selector(didTapEditButton), for: .touchUpInside)

        let editItem = UIBarButtonItem(customView: editButton)

        navigationItem.rightBarButtonItems = [editItem]
    }
    
    func updateInterface() {
        testDetailsView.notesContent.text = viewModel.test.unwrappedComment
        testDetailsView.questionsLabel.text = "\(viewModel.test.rightQuestions)/\(viewModel.test.totalQuestions)"
        testDetailsView.titleLabel.text = viewModel.theme.unwrappedName
        testDetailsView.circularProgressView.progress = CGFloat(viewModel.test.rightQuestions) / CGFloat(viewModel.test.totalQuestions)
        testDetailsView.dateLabel.text = viewModel.getDateString(from: viewModel.test)
        testDetailsView.percentageLabel.text = "\(Int(CGFloat(viewModel.test.rightQuestions) / CGFloat(viewModel.test.totalQuestions) * 100))%"
    }

    @objc 
    private func didTapEditButton() {
        coordinator?.showTestPage(theme: viewModel.theme, test: viewModel.test)
    }
}
