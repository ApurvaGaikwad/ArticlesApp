

import UIKit
import CoreData

class ArticlesViewController: UIViewController, UISearchResultsUpdating, UISearchBarDelegate {

    var people: [NSManagedObject] = []
    private let viewModel = ArticleViewModel()
    private var isArticlesLoading: Bool = false
    private var articles = [Article]()
    private let totalPage = 5
    private var currentPage = 1
    @IBOutlet weak var articleTableView: UITableView!
    var filteredArray = [Article]()
    var shouldShowSearchResults = false
    var searchController: UISearchController!

    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "ArticleCell", bundle: nil)
        articleTableView.register(nib, forCellReuseIdentifier: "Cell")
        configureSearchController()
        loadAllArticles(page: currentPage)
        articleTableView.reloadData()
    }

    func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "Search name"
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        articleTableView.tableHeaderView = searchController.searchBar
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        shouldShowSearchResults = true
        articleTableView.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            articleTableView.reloadData()
        }
        searchController.searchBar.resignFirstResponder()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        shouldShowSearchResults = false
        articleTableView.reloadData()
    }

    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filteredArray = searchText.isEmpty ? articles : articles.filter({ (dataString: Article) -> Bool in
                return dataString.user?.first?.name?.range(of: searchText, options: .caseInsensitive) != nil
            })
            articleTableView.reloadData()
        }
    }

    private func loadAllArticles(page: Int) {
        viewModel.page = page
        viewModel.fetchArticles { (result) in
            switch result {
            case .failure(let error) :
                DispatchQueue.main.async {
                    self.updateUIWithError(error: error)
                }
            case .success(let articles):
                self.articles.append(contentsOf: articles)
                DispatchQueue.main.async {
                    self.articleTableView.reloadData()
                }
                self.isArticlesLoading = false
            }
        }
    }

    private func updateUIWithError(error : Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension ArticlesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldShowSearchResults {
            return filteredArray.count
        }
        else {
            return articles.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ArticleTableViewCell
        if shouldShowSearchResults {
            cell?.article = filteredArray[indexPath.row]
        }
        else {
            cell?.article = articles[indexPath.row]
        }
        return cell!
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height
            && currentPage <= totalPage && !isArticlesLoading {
            self.isArticlesLoading = true
            self.currentPage += 1
            self.loadAllArticles(page: currentPage)
        }
    }
}

