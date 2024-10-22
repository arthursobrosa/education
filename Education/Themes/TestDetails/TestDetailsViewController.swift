

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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    override func loadView() {
        super.loadView()
        
        updateInterface()
            
        self.view = self.testDetailsView
        
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationItems()
        
    }
    
    
    func updateInterface(){
        self.testDetailsView.notesContent.text = self.viewModel.test.unwrappedComment
        self.testDetailsView.questionsLabel.text = "\(self.viewModel.test.rightQuestions)/\(self.viewModel.test.totalQuestions)"
        self.testDetailsView.titleLabel.text = self.viewModel.theme.unwrappedName
        self.testDetailsView.circularProgressView.progress = CGFloat(self.viewModel.test.rightQuestions) / CGFloat(self.viewModel.test.totalQuestions)
        self.testDetailsView.dateLabel.text = self.viewModel.getDateString(from: self.viewModel.test)
        self.testDetailsView.percentageLabel.text = "\(Int((CGFloat(self.viewModel.test.rightQuestions) / CGFloat(self.viewModel.test.totalQuestions) * 100)))%"
    }
    
    // MARK: - Methods
    private func setNavigationItems() {
        self.navigationItem.title = self.viewModel.getDateFullString(from: self.viewModel.test)
        
        self.navigationController?.navigationBar.titleTextAttributes = [.font : UIFont(name: Fonts.darkModeOnSemiBold, size: 14) ?? .systemFont(ofSize: 14, weight: .semibold)]
        self.navigationController?.navigationBar.tintColor = .systemText
        
        let editButton = UIButton(configuration: .plain())
        editButton.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        editButton.setPreferredSymbolConfiguration(.init(pointSize: 16), forImageIn: .normal)
        editButton.imageView?.contentMode = .scaleAspectFit
        editButton.tintColor = .systemText
        
        editButton.addTarget(self, action: #selector(didTapEditButton), for: .touchUpInside)
        
        let editItem = UIBarButtonItem(customView: editButton)
        
        self.navigationItem.rightBarButtonItems = [editItem]
    }
    
    @objc private func didTapEditButton() {
        self.coordinator?.showTestPage(theme: self.viewModel.theme, test: self.viewModel.test)
    }
    
}

