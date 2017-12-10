import UIKit
import RemindersCore

class RemindersViewController: UIViewController {

    private var router: Router!
    private var presenter: RemindersPresenter!

    private var reminders: [Reminder]!

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initCollaborators()
        presenter.loadReminders()
    }

    private func initView() {
        title = "Reminders"
        navigationController?.navigationBar.prefersLargeTitles = true
        let addReminderButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addReminder))
        navigationItem.setRightBarButtonItems([addReminderButton], animated: false)
    }

    private func initCollaborators() {
        router = AppRouter(controller: self)
        let repository = InMemoryRemindersRepository()
        presenter = RemindersPresenter(view: self,
                                       router: router,
                                       repository: repository)
    }

    @objc private func addReminder() {
        presenter.addNewReminder()
    }
}

extension RemindersViewController: RemindersView {

    func showNoReminders() {
        let label = UILabel()
        label.text = "You have no reminders"
        label.textAlignment = .center
        label.backgroundColor = .white
        view = label
    }

    func showReminders(reminders: [Reminder]) {
        self.reminders = reminders
        let tableView = UITableView()
        tableView.accessibilityLabel = "Reminders"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        tableView.dataSource = self
        view = tableView
    }
}

extension RemindersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminders.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewCell(tableView: tableView, reuseIdentifier: "UITableViewCell")
        cell.textLabel?.text = reminders[indexPath.row].title
        return cell
    }

    private func tableViewCell(tableView: UITableView, reuseIdentifier: String) -> UITableViewCell {
        if let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) {
            return dequeuedCell
        } else {
            return UITableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
        }
    }
}
