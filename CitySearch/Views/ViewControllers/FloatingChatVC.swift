import UIKit

class FloatingChatVC: UIView {
    
    private let chatService = GeminiAPIService()
    private var messages: [String] = ["👋 Hi! Welcome to City Search App! How can I help?"]

    private let blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemThinMaterial)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        return tableView
    }()

    private let messageInputField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Type a message..."
        textField.backgroundColor = UIColor.systemBackground
        textField.layer.cornerRadius = 18
        textField.layer.masksToBounds = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.returnKeyType = .send  // Press Enter to Send
        return textField
    }()

    private let sendButton: UIButton = {
        let button = UIButton(type: .system)
        let sendImage = UIImage(systemName: "paperplane.fill")?.withRenderingMode(.alwaysTemplate)
        button.setImage(sendImage, for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        return button
    }()

    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Close", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(closeChat), for: .touchUpInside)
        return button
    }()

    private var panGestureRecognizer: UIPanGestureRecognizer!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupGestures()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false

        addSubview(blurEffectView)
        addSubview(closeButton)
        addSubview(tableView)
        addSubview(messageInputField)
        addSubview(sendButton)

        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        // Set Delegate for Enter Key
        messageInputField.delegate = self

        NSLayoutConstraint.activate([
            blurEffectView.topAnchor.constraint(equalTo: topAnchor),
            blurEffectView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: bottomAnchor),

            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            closeButton.widthAnchor.constraint(equalToConstant: 60),
            closeButton.heightAnchor.constraint(equalToConstant: 30),

            tableView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            tableView.bottomAnchor.constraint(equalTo: messageInputField.topAnchor, constant: -8),

            messageInputField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            messageInputField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            messageInputField.heightAnchor.constraint(equalToConstant: 40),

            sendButton.leadingAnchor.constraint(equalTo: messageInputField.trailingAnchor, constant: 8),
            sendButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            sendButton.centerYAnchor.constraint(equalTo: messageInputField.centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 40),
            sendButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    private func setupGestures() {
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleDrag(_:)))
        addGestureRecognizer(panGestureRecognizer)
    }

    @objc private func handleDrag(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: superview)
        center = CGPoint(x: center.x + translation.x, y: center.y + translation.y)
        sender.setTranslation(.zero, in: superview)
    }

    @objc private func closeChat() {
        removeFromSuperview()
    }

    @objc private func sendMessage() {
        guard let userText = messageInputField.text, !userText.isEmpty else { return }

        messages.append("🧑‍💻 You: \(userText)")
        tableView.reloadData()
        messageInputField.text = ""

        chatService.getAIResponse(for: userText) { [weak self] response in
            DispatchQueue.main.async {
                if let aiResponse = response {
                    self?.messages.append("🤖 Gemini: \(aiResponse)")
                } else {
                    self?.messages.append("🤖 Gemini: No response")
                }
                self?.tableView.reloadData()
                self?.scrollToBottom()
            }
        }
    }

    private func scrollToBottom() {
        guard messages.count > 0 else { return }
        let indexPath = IndexPath(row: messages.count - 1, section: 0)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
}

// MARK: - Enter Key Sends Message
extension FloatingChatVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendMessage()
        return true
    }
}

// MARK: - TableView DataSource
extension FloatingChatVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = messages[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.textColor = .label
        cell.backgroundColor = .clear
        return cell
    }
}
