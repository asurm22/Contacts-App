//
//  ViewController.swift
//  ContactBook
//
//  Created by alex surmava on 28.12.24.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private var addButton: UIButton!
    @IBOutlet private var changeButton: UIButton!
    private var table: UITableView!
    private var collectionView: UICollectionView!
    private var searchBar: UISearchBar!
    
    private var isTableActive: Bool = true
    private var isSearching: Bool = false
    
    private var filteredData: [Section] = []
    
    private lazy var data: [Section] = [
        Section(
            header: HeaderModel(
                title: "A",
                onExpand: { [unowned self] in
                    handleExpansion(for: "A")
                }
            ),
            items: [
                Contact(name: "Alex", phoneNumber: "599888888")
            ]
        ),
        Section(
            header: HeaderModel(
                title: "B",
                onExpand: { [unowned self] in
                    handleExpansion(for: "B")
                }
            ),
            items: [
                Contact(name: "Bam", phoneNumber: "599888888"),
                Contact(name: "Bbb", phoneNumber: "599888888"),
                Contact(name: "Bl", phoneNumber: "599888888")
            ]
        ),
        Section(
            header: HeaderModel(
                title: "D",
                onExpand: { [unowned self] in
                    handleExpansion(for: "D")
                }
            ),
            items: [
                Contact(name: "Dirk", phoneNumber: "599888888")
            ]
        ),
        Section(
            header: HeaderModel(
                title: "L",
                onExpand: { [unowned self] in
                    handleExpansion(for: "L")
                }
            ),
            items: [
                Contact(name: "Lebron", phoneNumber: "579232323")
            ]
        )
    ]
    
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        return layout
    }()
    
    private func handleExpansion(for headerTitle: String) {
        guard let sectionIndex = data.firstIndex(where: { $0.headerM?.header == headerTitle }) else { return }
        data[sectionIndex].isExpanded.toggle()
        reloadVisibleData()
    }
    
    private func reloadVisibleData() {
        if isTableActive {
            table.reloadData()
        } else {
            collectionView.reloadData()
        }
    }


    private func getIndexPathsForSection(_ section: Int) -> [IndexPath] {
        let itemCount = data[section].items.count
        return (0..<itemCount).map { IndexPath(item: $0, section: section) }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        configureSearchBar()
        configureTable()
        configureCollectionView()
        configureAddButton()
        configureChangeButton()
    }
    
    private func configureSearchBar() {
            searchBar = UISearchBar()
            searchBar.delegate = self
            searchBar.placeholder = "Search Contacts"
            searchBar.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(searchBar)
            NSLayoutConstraint.activate([
                searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        }
    
    private func configureTable() {
        table = UITableView(frame: .zero, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.sectionHeaderTopPadding = 0
        table.isHidden = true
        
        table.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        table.register(UINib(nibName: "ContactHeader", bundle: nil),
                       forHeaderFooterViewReuseIdentifier: "ContactHeader")
        
        table.isHidden = false
        table.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(table)
        NSLayoutConstraint.activate([
            table.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            table.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            table.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            table.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
        
        collectionView.register(
            UINib(nibName: "CollectionContactHeader", bundle: nil),
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "CollectionContactHeader"
        )
    
        collectionView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress)))
        
        collectionView.backgroundColor = .white
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.isHidden = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configureAddButton() {
        addButton.addTarget(self, action: #selector(showAddContactPopup), for: .touchUpInside)
    }
    
    private func configureChangeButton() {
        changeButton.addTarget(self, action: #selector(changeView), for: .touchUpInside)
    }
    
    @objc
    private func showAddContactPopup() {
        let alert = UIAlertController(title: "New Contact", message: "Enter name and phone number", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Name"
        }
        alert.addTextField { textField in
            textField.placeholder = "Phone Number"
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self]_ in
            guard let self = self else {return}
            guard
                let name = alert.textFields?[0].text,
                let phoneNumber = alert.textFields?[1].text,
                !name.isEmpty, !phoneNumber.isEmpty
            else { return }
            self.addContact(name: name, phoneNumber: phoneNumber)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    private func addContact(name: String, phoneNumber: String) {
        let contact = Contact(name: name, phoneNumber: phoneNumber)
        
        let first = String(name.prefix(1)).uppercased()
        if let sectionIndex = data.firstIndex(where: { $0.headerM?.header == first }) {
            let section = data[sectionIndex]
            section.items.append(contact)
            section.items.sort { $0.name.uppercased() < $1.name.uppercased() }
            data[sectionIndex] = section
        } else {
            let section = Section(header: HeaderModel(title: first, onExpand: { [unowned self] in
                handleExpansion(for: first)
            }),
            items: [contact]
            )
            data.append(section)
            data.sort { $0.headerM?.header ?? "" < $1.headerM?.header ?? "" }
        }
        
        reloadVisibleData()
    }
    
    @objc
    private func changeView(){
        isTableActive.toggle()
        table.isHidden = !isTableActive
        collectionView.isHidden = isTableActive
        
        if isTableActive{
            changeButton.setImage(UIImage(systemName: "square.grid.3x3.fill"), for: .normal)
        } else {
            changeButton.setImage(UIImage(systemName: "line.horizontal.3"), for: .normal)
        }
        collectionView.reloadData()
    }
    
    @objc
    private func handleLongPress(_ gesture: UILongPressGestureRecognizer){
        if gesture.state == .began {
            let point = gesture.location(in: collectionView)
            if let indexPath = collectionView.indexPathForItem(at: point) {
                presentActionSheet(for: indexPath)
            }
        }
    }
    
    private func presentActionSheet(for indexPath: IndexPath) {
        let alert = UIAlertController(
                title: "Actions",
                message: "What would you like to do?",
                preferredStyle: .actionSheet
            )
            
            alert.addAction(UIAlertAction(title: "Edit", style: .default, handler: { [unowned self] _ in
                editContactAlert(at: indexPath)
            }))
            
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [unowned self] _ in
                presentDeleteConfirmation(for: indexPath)
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            present(alert, animated: true)
    }
    
    private func presentEdit(for indexPath: IndexPath){
        
    }
    
    private func presentDeleteConfirmation(for indexPath: IndexPath) {
        let contact = data[indexPath.section].items[indexPath.row]
        let alert = UIAlertController(
            title: "Delete",
            message: "Confirm Deletion of \(contact.name)",
            preferredStyle: .actionSheet
        )
        alert.addAction(
            UIAlertAction(
                title: "Delete",
                style: .destructive,
                handler: { [unowned self] _ in
                    if data[indexPath.section].items.count == 1 {
                        data.remove(at: indexPath.section)
                        collectionView.deleteSections(IndexSet(integer: indexPath.section))
                    } else {
                        data[indexPath.section].items.remove(at: indexPath.row)
                        collectionView.deleteItems(at: [indexPath])
                    }
                }
            )
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath)
        if let contactCell = cell as? TableViewCell {
            let contact = isSearching ? filteredData[indexPath.section].items[indexPath.row] : data[indexPath.section].items[indexPath.row]
            contactCell.configure(contact: contact)
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredData[section].contactCount : data[section].contactCount
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ContactHeader")
        if let contactHeader = header as? ContactHeader, let model = headerModel(for: section) {
            contactHeader.configure(with: model)
        }
        return header
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [unowned self]_, _, _ in
            deleteContact(at: indexPath)
        }
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [unowned self]_, _, _ in
            editContactAlert(at: indexPath)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return isSearching ? filteredData.count : data.count
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath)
        if let contactCell = cell as? CollectionViewCell {
            let contact = isSearching ? filteredData[indexPath.section].items[indexPath.row] : data[indexPath.section].items[indexPath.row]
            contactCell.configure(contact: contact)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isSearching ? filteredData[section].contactCount : data[section].contactCount
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CollectionContactHeader", for: indexPath)
            if let contactHeader = header as? CollectionContactHeader, let model =  headerModel(for:indexPath.section) {
                contactHeader.configure(with: model)
            }
            return header
        }
        return UICollectionReusableView()
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return isSearching ? filteredData.count : data.count
    }
    
}

extension ViewController {
    
    private func headerModel(for section: Int) -> HeaderModel? {
        return data[section].headerM
    }
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let spacings = (spacing * 2) + (spacing * CGFloat(itemsInRow-1))
        let spareWidth = collectionView.frame.width - spacings
        let itemSize = spareWidth / CGFloat(itemsInRow)
        return CGSize(width: itemSize, height: itemSize)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        if data[section].isExpanded {
            return spacing
        } else {
            return 0
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        if data[section].isExpanded {
            return spacing
        } else {
            return 0
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 28)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        if data[section].isExpanded {
            return UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        } else {
            return UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
        }
    }
    
}

extension ViewController {
    
    private var spacing: CGFloat { 20 }
    private var itemsInRow: Int { 3 }
    
    private func deleteContact(at indexPath: IndexPath) {
        if self.data[indexPath.section].items.count == 1 {
            self.data.remove(at: indexPath.section)
            table.deleteSections(IndexSet(integer: indexPath.section), with: .fade)
        } else {
            self.data[indexPath.section].items.remove(at: indexPath.row)
            table.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    private func editContactAlert(at indexPath: IndexPath) {
        let contact = self.data[indexPath.section].items[indexPath.row]
        let alert = UIAlertController(
            title: "Edit Contact \(contact.name)",
            message: "Edit contact name or number",
            preferredStyle: .alert
        )
        alert.addTextField { textField in
            textField.placeholder = "Name"
        }
        alert.addTextField { textField in
            textField.placeholder = "Phone Number"
        }
        let addAction = UIAlertAction(
            title: "Edit",
            style: .default,
            handler: { [unowned self] _ in
                guard
                    let name = alert.textFields?[0].text,
                    var phoneNumber = alert.textFields?[1].text
                else { return }
                
                if !phoneNumber.isEmpty{
                    self.data[indexPath.section].items[indexPath.row].phoneNumber = phoneNumber
                } else {
                    phoneNumber = self.data[indexPath.section].items[indexPath.row].phoneNumber
                }
                if !name.isEmpty{
                    deleteContact(at: indexPath)
                    addContact(name: name, phoneNumber: phoneNumber)
                }
                
                reloadVisibleData()
            }
        )
        alert.addAction(addAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            reloadVisibleData()
        } else {
            isSearching = true
            filteredData = data.compactMap { section in
                let filteredItems = section.items.filter {
                    $0.name.lowercased().contains(searchText.lowercased())
                }
                return filteredItems.isEmpty ? nil : Section(header: section.headerM!, items: filteredItems)
            }
            reloadVisibleData()
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        searchBar.text = ""
        reloadVisibleData()
    }
}

