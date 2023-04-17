//
//  ViewController.swift
//  ImageFeed
//
//  Created by Alexander Farizanov on 22.01.2023.
//

import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

protocol ImagesListViewControllerProtocol {
    var presenter: ImageListPresenterProtocol? { get set }
    var photos: [Photo] { get set }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
}

final class ImagesListViewController: UIViewController, ImagesListViewControllerProtocol {
    var presenter: ImageListPresenterProtocol?
    
    @IBOutlet private var tableView: UITableView!
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    private let ShowSingleImageSegueIdentifier = "ShowSingleImage"
    private let imagesListService = ImagesListService.shared
    private var imageListServiceObserver: NSObjectProtocol?
    
    var photos: [Photo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = ImageListPresenter()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        imageListServiceObserver = NotificationCenter.default.addObserver(forName: ImagesListService.DidChangeNotification,
                                                                          object: nil, queue: .main) { [weak self] _ in
            guard let self = self else { return }
            self.updateTableViewAnimated()
        }
        presenter?.fetchPhotosNextPage()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowSingleImageSegueIdentifier {
            let viewController = segue.destination as! SingleImageViewController
            let indexPath = sender as! IndexPath
            guard let url = URL(string: photos[indexPath.row].largeImageURL) else { return }
            viewController.imageURL = url
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let url = URL(string: photos[indexPath.row].thumbImageURL) else { return }
        cell.imageViewCell.kf.setImage(with: url, placeholder: UIImage(named: "zaglushka.png"), completionHandler: { [weak self] _ in
            guard let self = self else { return }
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        })
        cell.imageViewCell.kf.indicatorType = .activity
        guard let textData = photos[indexPath.row].createdAt else { return }
        cell.dateTextLabel.text = dateFormatter.string(from: textData)
        cell.setLike(like: photos[indexPath.row].isLiked)
    }
    
    func updateTableViewAnimated() {
        let oldCount = photos.count
        guard let newCount = presenter?.imagesListService.photos.count else { return }
        guard let newPhotos = presenter?.imagesListService.photos else { return }
        photos = newPhotos
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        imageListCell.delegate = self
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter?.chekFilledList(indexPath)
    }
}


extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: ShowSingleImageSegueIdentifier, sender: indexPath)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let image = photos[indexPath.row]
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}


extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        UIBlockingProgressHUD.show()
        presenter?.setLike(photoId: photo.id, isLike: photo.isLiked, {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                guard let newPhotos = self.presenter?.imagesListService.photos else { return }
                self.photos = newPhotos
                cell.setLike(like: self.photos[indexPath.row].isLiked)
                UIBlockingProgressHUD.dismiss()
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                print(error.localizedDescription)
            }
        })
    }
}
