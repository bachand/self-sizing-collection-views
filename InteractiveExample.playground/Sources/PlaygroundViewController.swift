import Foundation
import UIKit

private let cellReuseIdentifier = "cell"

// MARK: - PlaygroundViewController

public final class PlaygroundViewController: UIViewController,
  UICollectionViewDataSource
{
  // MARK: Lifecycle

  public init(components: [Component], layoutType: LayoutType) {
    self.components = components
    self.layoutType = layoutType
    super.init(nibName: nil, bundle: nil)
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError()
  }

  // MARK: Public

  public enum LayoutType {
    case selfSizingFlow
    case verticalStack
  }
  
  public override func loadView() {
    let rootView = UIView()
    configureRootView(rootView)

    let collectionViewLayout: UICollectionViewLayout
    switch layoutType {
    case .selfSizingFlow:
      collectionViewLayout = UICollectionViewFlowLayout()
    case .verticalStack:
      collectionViewLayout = Layout()
    }

    configureCollectionViewLayout(collectionViewLayout)

    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
    configureCollectionView(collectionView)

    self.view = rootView

    rootView.addSubview(collectionView)
    setUpConstraintsFor(collectionView)
  }

  // MARK: Private

  private let components: [Component]
  private let layoutType: LayoutType

  private func configureRootView(_ rootView: UIView) {
    rootView.backgroundColor = #colorLiteral(red: 0.462745098, green: 0.462745098, blue: 0.462745098, alpha: 1)
  }

  private func configureCollectionViewLayout(_ collectionViewLayout: UICollectionViewLayout) {
    // nothing?
  }

  private func configureCollectionView(_ collectionView: UICollectionView) {
    collectionView.dataSource = self
    collectionView.backgroundColor = .clear
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
  }

  private func setUpConstraintsFor(_ collectionView: UICollectionView) {
    collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
  }

  // MARK: CollectionViewDataSource

  public func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int) -> Int
  {
    switch section {
    case 0:
      return components.count
    default:
      preconditionFailure()
    }
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
  {
    let environment = ComponentEnvironment(index: UInt(indexPath.item))

    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath)
    components[indexPath.item].configure(cell, for: environment)
    return cell
  }
}
