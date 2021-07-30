//
//  ViewController.swift
//  
//  
//  Created by maeda.tasuku on 2021/07/30
//  
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var bannerContainerView: UIView!
    @IBOutlet weak var bannerContainerViewHeightConstraint: NSLayoutConstraint!
    var bannerViewController: BannerScrollViewController!
    
    @IBOutlet var bannerPageControl : UIPageControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        bannerViewController = BannerScrollViewController()
        addChild(bannerViewController)
        bannerViewController.view.translatesAutoresizingMaskIntoConstraints = false
        bannerContainerView.addSubview(bannerViewController.view)
        bannerViewController.view.topAnchor.constraint(equalTo: bannerContainerView.topAnchor).isActive = true
        bannerViewController.view.bottomAnchor.constraint(equalTo: bannerContainerView.bottomAnchor).isActive = true
        bannerViewController.view.leadingAnchor.constraint(equalTo: bannerContainerView.leadingAnchor).isActive = true
        bannerViewController.view.trailingAnchor.constraint(equalTo: bannerContainerView.trailingAnchor).isActive = true
        bannerViewController.didMove(toParent: self)
        bannerViewController.setup()
        bannerContainerViewHeightConstraint.constant = bannerViewController.panelHeight
        bannerViewController.delegate = self
        
        setupBannerPageControl()
    }
    
    func setupBannerPageControl() {
        bannerPageControl.pageIndicatorTintColor = .lightGray
        bannerPageControl.currentPageIndicatorTintColor = .black
        bannerPageControl.numberOfPages = bannerViewController.colors.count
        bannerPageControl.currentPage = bannerViewController.pageIndex
        bannerPageControl.sizeToFit()
    }
    
    func updateBannerPageControl() {
        bannerPageControl.currentPage = bannerViewController.pageIndex
    }
    
    @IBAction func didChangeBannerPageControl() {
        bannerViewController.showPage(index: bannerPageControl.currentPage, animated: true)
    }
    
    @IBAction func didTapResetButton() {
        bannerViewController.showPage(index: 0, animated: true)
    }
}

extension ViewController: BannerScrollViewControllerDelegate {
    
    func bannerScrollViewController(_ scrollViewController: BannerScrollViewController, didChangePageIndex index: Int) {
        updateBannerPageControl()
    }
}
