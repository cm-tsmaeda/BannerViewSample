//
//  BannerViewController.swift
//  BannerViewSample
//  
//  Created by maeda.tasuku on 2021/07/30
//  
//

import UIKit

protocol BannerScrollViewControllerDelegate: class {
    /// pageIndexが変わったときに呼ばれる
    func bannerScrollViewController(_ scrollViewController: BannerScrollViewController, didChangePageIndex index: Int)
}

/// バナー表示Viewのコントローラ
/// scrollViewを使って表示している
class BannerScrollViewController: UIViewController {
    /// バナーエリアの全体の幅
    let baseComponentWidth: CGFloat = 406
    /// デザインでのパネルの幅
    let basePanelWidth: CGFloat = 355
    /// デザインでのパネルの高さ
    let basePanelImageHeight: CGFloat = 238
    /// デザインでのテキスト部分の高さ
    let basePanelTextContainerHeight: CGFloat = 30
    /// デザインでのパネルの横マージン（先頭の左マージン）
    lazy var basePanelHorizontalMargin: CGFloat = (baseComponentWidth - basePanelWidth) / 2
    /// デザインでのパネル間のマージン
    let basePanelGap: CGFloat = 8
    /// パネルの幅
    private(set) var panelWidth: CGFloat = 0
    /// パネルの高さ
    private(set) var panelHeight: CGFloat = 0
    /// パネルの横マージン（先頭の左マージン）
    private(set) var panelHorizontalMargin: CGFloat = 0
    /// パネル間のマージン
    private(set) var panelGap: CGFloat = 0
    
    private(set) var scrollView: UIScrollView!
    
    private(set) var contentView: UIView!
    private var contentViewWidthConstraint: NSLayoutConstraint!
    
    /// 現在のPageIndex
    private(set) var pageIndex: Int = 0
    
    var delegate: BannerScrollViewControllerDelegate?
    
    //開発用のダミーデータ
    let colorHexs: [String] = ["D4C2FC", "C2DDFC", "C2FCF4", "C2FCCC", "D4FCC2",
                               "EEFCC2", "FCE9C2", "FBC2A5", "FBAEA5", "FBA5CF"]
    lazy var colors: [UIColor] = {
        colorHexs.map { UIColor.hexStringToUIColor(hex: $0) }
    }()
    
    /// 初期化
    func setup() {
        setupSizes()
        setupScrollView()
        setupContentSize()
        addPanels()
    }
    
    /// viewの大きさ測定
    func setupSizes() {
        let viewWidth = view.frame.width
        let ratio: CGFloat = viewWidth / baseComponentWidth
        panelWidth = ratio * basePanelWidth
        panelHeight = ratio * basePanelImageHeight + basePanelTextContainerHeight
        panelHorizontalMargin = ratio * basePanelHorizontalMargin
        panelGap = ratio * basePanelGap
    }
    
    func setupScrollView() {
        scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        // 本来見えない箇所をclipsToBounds=falseで見えるようにしている。
        scrollView.clipsToBounds = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        
        // 横幅はパネルの幅+パネル間のマージン
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: panelHorizontalMargin).isActive = true
        view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: (panelHorizontalMargin - panelGap)).isActive = true
        // frameの外はタッチイベントがきかない。その回避策
        // https://stackoverflow.com/a/36641652
        view.addGestureRecognizer(scrollView.panGestureRecognizer)

        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        contentViewWidthConstraint = contentView.widthAnchor.constraint(equalToConstant: 0)
        contentViewWidthConstraint.isActive = true
        contentView.heightAnchor.constraint(equalToConstant: panelHeight).isActive = true
    }
    
    func setupContentSize() {
        let count = CGFloat(colors.count)
        let contentWidth = (panelWidth + panelGap) * (count)
        contentViewWidthConstraint.constant = contentWidth
        scrollView.contentSize = CGSize(width: contentWidth, height: panelHeight)
    }
    
    var bannerView: BannerView!
    
    /// パネル追加
    func addPanels() {
        var prevBannerView: BannerView?
        colors.enumerated().forEach { index, color in
            if let bannerView =  UINib(nibName: "BannerView", bundle: nil).instantiate(withOwner: nil, options: nil).first as? BannerView {
                // 中身表示
                bannerView.backgroundColor = color
                bannerView.titleLabel.text = "これはサンプルです。バナーNo. \(index + 1)"
                bannerView.subTextLabel.text = "サブテキストが入ります。あいうえお"
                
                // レイアウト
                bannerView.translatesAutoresizingMaskIntoConstraints = false
                contentView.addSubview(bannerView)
                bannerView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
                bannerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
                if index == 0 {
                    bannerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
                } else {
                    if let prevBanner = prevBannerView {
                        bannerView.leadingAnchor.constraint(equalTo: prevBanner.trailingAnchor, constant: panelGap).isActive = true
                    }
                }
                bannerView.widthAnchor.constraint(equalToConstant: panelWidth).isActive = true
                prevBannerView = bannerView
                
                // バナーをタップしたときのイベント設定
                let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapBanner(gesture:)))
                gesture.numberOfTouchesRequired = 1
                bannerView.tag = index
                bannerView.addGestureRecognizer(gesture)
            }
        }
        contentView.layoutSubviews()
    }
    
    @objc func didTapBanner(gesture: UITapGestureRecognizer) {
        if case .ended = gesture.state,
           let index = gesture.view?.tag {
            
            let alertController = UIAlertController(title: "\(index) がタップされました", message: nil, preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default) { _ in
                alertController.dismiss(animated: true, completion: nil)
            }
            alertController.addAction(okButton)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    /// 現在のページindexを返す
    func calcPageIndex(contentOffsetX: CGFloat) -> Int {
        // 0.5 - 1.5 の間は1で返す
        // 1.5 - 2.5 の間は2で返す....
        return Int(round(contentOffsetX / (panelWidth + panelGap)))
    }
    
    /// ページを表示する
    func showPage(index: Int, animated: Bool) {
        let offset = CGPoint(
            x: CGFloat(index) * (panelWidth + panelGap),
            y: 0
        )
        scrollView.setContentOffset(offset, animated: animated)
    }
}

extension BannerScrollViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentIndex = pageIndex
        let newIndex = calcPageIndex(contentOffsetX: scrollView.contentOffset.x)
        if currentIndex != newIndex {
            pageIndex = newIndex
            delegate?.bannerScrollViewController(self, didChangePageIndex: newIndex)
        }
    }
}
