import UIKit
import ReSwift
import SnapKit
import SDWebImage

final class ViewController: UIViewController, StoreSubscriber {
    
    typealias StoreSubscriberStateType = AppState
    
    // MARK: - Properties
    
    private lazy var imageView = makeImageView()
    private lazy var loadedImageButton = makeButton(.loaded)
    private lazy var activityIndicator = makeActivityIndicatorView()
    
    private lazy var horizontalStackLabels = makeHorizontalStack()
    private lazy var descriptionLabel = makeLabel(Constants.descriptionLabelText)
    private lazy var counterLabel = makeLabel()
    
    private lazy var horizontalStackButtons = makeHorizontalStack()
    private lazy var counterAddButton = makeButton(.add)
    private lazy var counterRemoveButton = makeButton(.remove)
    
    // MARK: - Lyfie cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setConstraint()
        setTargetToButtons()
        
        mainStore.subscribe(self)
    }
    
    // MARK: - Redux methods
    
    func newState(state: AppState) {
        if state.counter == 0 {
            counterRemoveButton.isEnabled = false
        } else {
            counterRemoveButton.isEnabled = true
        }
        counterLabel.text = "\(mainStore.state.counter)"
        if state.imageState == .loading {
            activityIndicator.startAnimating()
            let url_1 = URL(string: "https://s1.1zoom.ru/big3/241/431666-Kysb.jpg")
            imageView.sd_setImage(with: url_1) { image, _, _, _ in
                self.activityIndicator.stopAnimating()
            }
        }
    }
}

// MARK: - Private func

private extension ViewController {
    func configureUI() {
        view.backgroundColor = .black
        
        view.addSubview(imageView)
        imageView.addSubview(activityIndicator)
        view.addSubview(loadedImageButton)
        
        view.addSubview(horizontalStackLabels)
        horizontalStackLabels.addArrangedSubview(descriptionLabel)
        horizontalStackLabels.addArrangedSubview(counterLabel)
        
        view.addSubview(horizontalStackButtons)
        horizontalStackButtons.addArrangedSubview(counterRemoveButton)
        horizontalStackButtons.addArrangedSubview(counterAddButton)
    }
    
    func setConstraint() {
        imageView.snp.makeConstraints { make in
            make.height.width.equalTo(300)
            make.centerX.equalTo(self.view.snp.centerX)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(25)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalTo(imageView.snp.center)
        }
        
        loadedImageButton.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(50)
            make.centerX.equalTo(self.view.snp.centerX)
            make.height.equalTo(50)
            make.left.equalTo(self.view.snp.left).offset(25)
            make.right.equalTo(self.view.snp.right).inset(25)
        }
        
        horizontalStackLabels.snp.makeConstraints { make in
            make.top.equalTo(loadedImageButton.snp.bottom).offset(100)
            make.centerX.equalTo(self.view.snp.centerX)
            make.height.equalTo(50)
        }
        
        horizontalStackButtons.snp.makeConstraints { make in
            make.top.equalTo(horizontalStackLabels.snp.bottom).offset(15)
            make.centerX.equalTo(self.view.snp.centerX)
            make.height.equalTo(50)
            make.left.equalTo(self.view.snp.left).offset(25)
            make.right.equalTo(self.view.snp.right).inset(25)
        }
        
        counterAddButton.snp.makeConstraints { make in
            make.width.equalTo(counterRemoveButton.snp.width)
        }
    }
    
    // MARK: - Set Target to buttons
    
    func setTargetToButtons() {
        counterAddButton.addTarget(
            self,
            action: #selector(tapCounterAdd(_:)),
            for: .touchUpInside
        )
        
        counterRemoveButton.addTarget(
            self,
            action: #selector(tapCounterRemove(_:)),
            for: .touchUpInside
        )
        
        loadedImageButton.addTarget(
            self,
            action: #selector(tapLoaded(_:)),
            for: .touchUpInside
        )
    }
}

// MARK: - Factory methods

private extension ViewController {
    func makeImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 25
        if #available(iOS 13, *) {
            imageView.layer.cornerCurve = .continuous
        }
        imageView.backgroundColor = .black
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.white.cgColor
        
        imageView.clipsToBounds = true
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    func makeLabel(_ text: String? = nil) -> UILabel {
        let label = UILabel()
        
        if let text = text {
            label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            label.text = text
        } else {
            label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
            label.text = "0"
        }
        label.numberOfLines = 1
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    func makeButton(_ type: TypeButton) -> InteractiveButton {
        let button = InteractiveButton()
        button.layer.cornerRadius = 15
        if #available(iOS 13, *) {
            button.layer.cornerCurve = .continuous
        }
        button.titleLabel?.font = UIFont.systemFont(
            ofSize: 14,
            weight: .regular
        )
        switch type {
        case .add:
            button.setTitle(Constants.buttonAddText, for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.backgroundColor = .yellow
        case .remove:
            button.setTitle(Constants.buttonRemoveText, for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .red
        case .loaded:
            button.setTitle(Constants.buttonLoadImageText, for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .blue
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    func makeHorizontalStack() -> UIStackView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 5
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }
    
    func makeActivityIndicatorView() -> UIActivityIndicatorView {
        let activity = UIActivityIndicatorView()
        activity.style = .large
        activity.color = UIColor.white
        activity.hidesWhenStopped = true
        return activity
    }
}

// MARK: - Targets buttons

private extension ViewController {
    @objc
    func tapCounterAdd(_ button: UIButton) {
        mainStore.dispatch(CounterActionIncrease())
    }
    
    @objc
    func tapCounterRemove(_ button: UIButton) {
        mainStore.dispatch(CounterActionDecrease())
    }
    
    @objc
    func tapLoaded(_ button: UIButton) {
        mainStore.dispatch(LoadAction())
    }
}

// MARK: - Enums & Constants

private extension ViewController {
    enum TypeButton {
        case add
        case remove
        case loaded
    }
    
    enum Constants {
        static let buttonAddText: String = "Увеличить"
        static let buttonRemoveText: String = "Уменьшить"
        static let buttonLoadImageText: String = "Загрузить картинку"
        static let descriptionLabelText: String = "Количество багов ->  "
    }
}

