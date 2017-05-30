//
//  ViewController.swift
//  FastlaneExample
//
//  Created by Ivan Bruel on 30/05/2017.
//  Copyright © 2017 Swift Aveiro. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class RepositoriesViewController: UIViewController {

  // MARK: - Views
  fileprivate lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.register(DetailTableViewCell.self, forCellReuseIdentifier: DetailTableViewCell.reuseIdentifier)
    return tableView
  }()
  fileprivate let disposeBag = DisposeBag()

  // MARK: - ViewModel
  fileprivate let viewModel: RepositoriesViewModel

  // MARK: - Initializers
  init(viewModel: RepositoriesViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("RepositoriesViewController should never be initialized by Storyboard")
  }

}

// MARK: - Lifecycle
extension RepositoriesViewController {

  override func loadView() {
    super.loadView()

    view.addSubview(tableView)

    tableView.snp.makeConstraints { make in
      make.edges.equalTo(view)
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setup()

    loadRepositories(username: "ivanbruel")
  }
}

// MARK: - Setup
extension RepositoriesViewController {

  fileprivate func setup() {
    viewModel.items
      .bind(to: tableView.rx.items(cellIdentifier: DetailTableViewCell.reuseIdentifier,
                                   cellType: DetailTableViewCell.self)) { row, viewModel, cell in
                                    cell.textLabel?.text = viewModel.name
                                    cell.detailTextLabel?.text = viewModel.stars
      }.disposed(by: disposeBag)
  }

  fileprivate func loadRepositories(username: String) {
    viewModel
      .getRepositories(username: "ivanbruel")
      .subscribeResult(onSuccess: nil) { [weak self] error in
        self?.showAlert(error: error)
      }.disposed(by: disposeBag)
  }
}

// MARK: - Alert
extension RepositoriesViewController {

  fileprivate func showAlert(error: RepositoriesError) {
    let controller = UIAlertController(title: error.message, message: nil, preferredStyle: .alert)
    controller.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
    present(controller, animated: true, completion: nil)
  }
}

